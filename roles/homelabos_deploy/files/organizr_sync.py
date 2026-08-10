#!/usr/bin/env python3

import json
import os
import re
import ssl
import sys
import tempfile
import urllib.error
import urllib.request
from typing import Any, Dict, List, Optional


def log(message: str) -> None:
    print(f"[organizr-sync] {message}")


def load_json(path: str) -> Dict[str, Any]:
    with open(path, "r", encoding="utf-8") as handle:
        return json.load(handle)


def load_state(path: str) -> Dict[str, int]:
    if not os.path.exists(path):
        return {}
    with open(path, "r", encoding="utf-8") as handle:
        raw = json.load(handle)
    if isinstance(raw, dict) and "managed_tabs" in raw and isinstance(raw["managed_tabs"], dict):
        raw = raw["managed_tabs"]
    if not isinstance(raw, dict):
        return {}
    state: Dict[str, int] = {}
    for key, value in raw.items():
        try:
            state[str(key)] = int(value)
        except (TypeError, ValueError):
            continue
    return state


def write_state(path: str, state: Dict[str, int]) -> None:
    os.makedirs(os.path.dirname(path), exist_ok=True)
    payload = {"managed_tabs": dict(sorted(state.items()))}
    fd, temp_path = tempfile.mkstemp(prefix="organizr-tabs-", suffix=".json", dir=os.path.dirname(path))
    try:
        with os.fdopen(fd, "w", encoding="utf-8") as handle:
            json.dump(payload, handle, indent=2, sort_keys=True)
            handle.write("\n")
        os.replace(temp_path, path)
    finally:
        if os.path.exists(temp_path):
            os.unlink(temp_path)


def extract_php_string(path: str, key: str) -> Optional[str]:
    with open(path, "r", encoding="utf-8") as handle:
        content = handle.read()
    match = re.search(r"'" + re.escape(key) + r"'\s*=>\s*'([^']+)'", content)
    return match.group(1) if match else None


def make_request(
    base_url: str,
    host_header: str,
    api_key: str,
    method: str,
    path: str,
    payload: Optional[Any] = None,
) -> Dict[str, Any]:
    data = None
    headers = {
        "Accept": "application/json",
        "Host": host_header,
        "Token": api_key,
    }
    if payload is not None:
        data = json.dumps(payload).encode("utf-8")
        headers["Content-Type"] = "application/json"
    request = urllib.request.Request(base_url + path, data=data, method=method, headers=headers)
    context = ssl._create_unverified_context()
    try:
        with urllib.request.urlopen(request, context=context, timeout=15) as response:
            body = response.read().decode("utf-8").strip()
            if not body:
                return {}
            try:
                return json.loads(body)
            except json.JSONDecodeError as exc:
                raise RuntimeError(f"{method} {path} returned non-JSON content") from exc
    except urllib.error.HTTPError as exc:
        body = exc.read().decode("utf-8", errors="replace").strip()
        detail = body
        try:
            parsed = json.loads(body) if body else {}
            detail = parsed.get("response", {}).get("message") or body or str(exc)
        except json.JSONDecodeError:
            pass
        raise RuntimeError(f"{method} {path} failed with HTTP {exc.code}: {detail}") from exc
    except urllib.error.URLError as exc:
        raise RuntimeError(f"{method} {path} failed: {exc}") from exc


def fetch_tabs(base_url: str, host_header: str, api_key: str) -> List[Dict[str, Any]]:
    payload = make_request(base_url, host_header, api_key, "GET", "/api/v2/tabs")
    data = payload.get("response", {}).get("data")
    if isinstance(data, dict):
        tabs = data.get("tabs")
        return tabs if isinstance(tabs, list) else []
    return data if isinstance(data, list) else []


def is_public_service(compose_path: str, service_domain: str) -> bool:
    if not service_domain or not os.path.exists(compose_path):
        return False
    with open(compose_path, "r", encoding="utf-8") as handle:
        content = handle.read()
    patterns = [
        rf"Host\(`{re.escape(service_domain)}`\)",
        rf"Host\('{re.escape(service_domain)}'\)",
        rf'Host\("{re.escape(service_domain)}"\)',
    ]
    return any(re.search(pattern, content) for pattern in patterns)


def derive_default_icon(label: str, fallback: str = "alphanumeric::?") -> str:
    for char in label:
        if char.isalnum():
            return f"alphanumeric::{char.upper()}"
    return fallback


def normalize_url(url: Any) -> str:
    if not isinstance(url, str):
        return ""
    return url.rstrip("/")


def desired_services(manifest: Dict[str, Any]) -> Dict[str, Dict[str, Any]]:
    excluded = set(manifest.get("exclude_services") or [])
    desired: Dict[str, Dict[str, Any]] = {}
    for service in manifest.get("services", []):
        name = service.get("name")
        if not name or name == "organizr" or name in excluded:
            continue
        if not service.get("enabled"):
            continue
        if not is_public_service(service.get("compose_path", ""), service.get("service_domain", "")):
            continue
        display_name = service.get("full_name") or name
        configured_icon = service.get("icon") or ""
        default_icon = manifest.get("default_icon") or "auto"
        image = (
            configured_icon
            if configured_icon
            else derive_default_icon(display_name, default_icon if default_icon != "auto" else "alphanumeric::?")
        )
        desired[name] = {
            "name": display_name,
            "url": f"https://{service['service_domain']}",
            "image": image,
            "enabled": 1,
            "type": 1,
        }
    return desired


def find_created_tab(tabs: List[Dict[str, Any]], payload: Dict[str, Any]) -> Optional[Dict[str, Any]]:
    for tab in tabs:
        if tab.get("name") != payload["name"]:
            continue
        if normalize_url(tab.get("url")) == normalize_url(payload["url"]):
            return tab
    return None


def create_or_refresh_tab(
    base_url: str,
    host_header: str,
    api_key: str,
    tabs: List[Dict[str, Any]],
    payload: Dict[str, Any],
) -> Optional[int]:
    make_request(base_url, host_header, api_key, "POST", "/api/v2/tabs", payload)
    refreshed = fetch_tabs(base_url, host_header, api_key)
    created = find_created_tab(refreshed, payload)
    if not created:
        raise RuntimeError(f"created tab for {payload['name']} but could not find it afterwards")
    tabs[:] = refreshed
    return int(created["id"])


def main() -> int:
    if len(sys.argv) != 2:
        log("usage: organizr_sync.py <manifest-path>")
        return 1

    manifest = load_json(sys.argv[1])
    state_path = manifest["state_path"]
    config_path = manifest["organizr_config_path"]
    organizr_domain = manifest["organizr_domain"]
    base_url = manifest.get("organizr_api_base_url") or "https://127.0.0.1"

    if not os.path.exists(config_path):
        log(f"skip: Organizr config not found at {config_path}")
        return 0

    api_key = extract_php_string(config_path, "organizrAPI")
    if not api_key:
        log("skip: could not extract organizrAPI from Organizr config")
        return 0

    try:
        tabs = fetch_tabs(base_url, organizr_domain, api_key)
    except RuntimeError as exc:
        log(f"skip: {exc}")
        return 0

    tabs_by_id = {int(tab["id"]): tab for tab in tabs if "id" in tab}
    state = load_state(state_path)
    desired = desired_services(manifest)

    for service_name, tab_id in list(state.items()):
        if service_name in desired:
            continue
        if tab_id in tabs_by_id:
            try:
                make_request(base_url, organizr_domain, api_key, "DELETE", f"/api/v2/tabs/{tab_id}")
                log(f"deleted managed tab for disabled or non-public service '{service_name}'")
            except RuntimeError as exc:
                log(f"warning: failed deleting tab {tab_id} for '{service_name}': {exc}")
                continue
        state.pop(service_name, None)

    tabs = fetch_tabs(base_url, organizr_domain, api_key)
    tabs_by_id = {int(tab["id"]): tab for tab in tabs if "id" in tab}

    for service_name, payload in desired.items():
        tab_id = state.get(service_name)
        current = tabs_by_id.get(tab_id) if tab_id is not None else None

        if current is None and tab_id is not None:
            log(f"managed tab {tab_id} for '{service_name}' is missing; recreating")
            state.pop(service_name, None)

        if current is None:
            matching_tab = find_created_tab(tabs, payload)
            if matching_tab and "id" in matching_tab:
                adopted_id = int(matching_tab["id"])
                state[service_name] = adopted_id
                current = matching_tab
                tabs_by_id[adopted_id] = matching_tab
                log(f"adopted existing tab for '{service_name}'")

        if current is None:
            try:
                new_id = create_or_refresh_tab(base_url, organizr_domain, api_key, tabs, payload)
            except RuntimeError as exc:
                log(f"warning: failed creating tab for '{service_name}': {exc}")
                continue
            state[service_name] = new_id
            tabs_by_id = {int(tab["id"]): tab for tab in tabs if "id" in tab}
            log(f"created managed tab for '{service_name}'")
            continue

        updates = {}
        for key in ("name", "image", "enabled", "type"):
            if current.get(key) != payload[key]:
                updates[key] = payload[key]
        if normalize_url(current.get("url")) != normalize_url(payload["url"]):
            updates["url"] = payload["url"]

        if updates:
            try:
                make_request(base_url, organizr_domain, api_key, "PUT", f"/api/v2/tabs/{tab_id}", updates)
                log(f"updated managed tab for '{service_name}'")
            except RuntimeError as exc:
                log(f"warning: failed updating tab {tab_id} for '{service_name}': {exc}")

    write_state(state_path, state)
    return 0


if __name__ == "__main__":
    sys.exit(main())
