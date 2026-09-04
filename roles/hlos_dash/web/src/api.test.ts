import { afterEach, describe, expect, it, vi } from "vitest";

import { patchSettings, resetSettings, saveAppDisplaySettings } from "./api";

describe("patchSettings", () => {
  afterEach(() => {
    vi.restoreAllMocks();
  });

  it("sends generic dot-path changes", async () => {
    const fetchMock = vi.spyOn(globalThis, "fetch").mockResolvedValue(
      new Response(
        JSON.stringify({
          install_dir: "/tmp/homelabos",
          settings_file: "/tmp/homelabos/settings/config.yml",
          lock_file: "/tmp/homelabos/settings/config.yml.lock",
          settings: {},
          deployed_settings: {},
          has_diff: false,
          changed_paths: [],
          changed_services: [],
        }),
        { status: 200, headers: { "Content-Type": "application/json" } },
      ),
    );

    await patchSettings("http://127.0.0.1:8081", "secret", { "jellyfin.enable": true });

    expect(fetchMock).toHaveBeenCalledWith("http://127.0.0.1:8081/v1/homelabos/settings", {
      method: "PATCH",
      body: JSON.stringify({ changes: { "jellyfin.enable": true } }),
      headers: {
        Authorization: "Bearer secret",
        "Content-Type": "application/json",
      },
    });
  });
});

describe("resetSettings", () => {
  afterEach(() => {
    vi.restoreAllMocks();
  });

  it("posts to the settings reset endpoint", async () => {
    const fetchMock = vi.spyOn(globalThis, "fetch").mockResolvedValue(
      new Response(
        JSON.stringify({
          install_dir: "/tmp/homelabos",
          settings_file: "/tmp/homelabos/settings/config.yml",
          lock_file: "/tmp/homelabos/settings/config.yml.lock",
          settings: {},
          deployed_settings: {},
          has_diff: false,
          changed_paths: [],
          changed_services: [],
        }),
        { status: 200, headers: { "Content-Type": "application/json" } },
      ),
    );

    await resetSettings("http://127.0.0.1:8081", "secret");

    expect(fetchMock).toHaveBeenCalledWith("http://127.0.0.1:8081/v1/homelabos/settings/reset", {
      method: "POST",
      headers: {
        Authorization: "Bearer secret",
        "Content-Type": "application/json",
      },
    });
  });
});

describe("saveAppDisplaySettings", () => {
  afterEach(() => {
    vi.restoreAllMocks();
  });

  it("puts app display ordering records", async () => {
    const fetchMock = vi.spyOn(globalThis, "fetch").mockResolvedValue(
      new Response(JSON.stringify({ jellyfin: { previous_sort_item: "TOP" } }), {
        status: 200,
        headers: { "Content-Type": "application/json" },
      }),
    );

    await saveAppDisplaySettings("http://127.0.0.1:8081", "secret", [
      { app_id: "jellyfin", previous_sort_item: "TOP", hidden: true },
      { app_id: "actual", previous_sort_item: "jellyfin", hidden: false },
      { app_id: "virtual-docs", previous_sort_item: null, hidden: false, virtual_item: true, name: "Docs", url: "https://docs.example.test/" },
    ]);

    expect(fetchMock).toHaveBeenCalledWith("http://127.0.0.1:8081/v1/homelabos/app-display-settings", {
      method: "PUT",
      body: JSON.stringify({
        items: [
          { app_id: "jellyfin", previous_sort_item: "TOP", hidden: true },
          { app_id: "actual", previous_sort_item: "jellyfin", hidden: false },
          { app_id: "virtual-docs", previous_sort_item: null, hidden: false, virtual_item: true, name: "Docs", url: "https://docs.example.test/" },
        ],
      }),
      headers: {
        Authorization: "Bearer secret",
        "Content-Type": "application/json",
      },
    });
  });
});
