export type SettingsResponse = {
  install_dir: string;
  settings_file: string;
  lock_file: string;
  settings: Record<string, unknown>;
  deployed_settings: Record<string, unknown>;
  service_metadata?: Record<string, ServiceMetadata>;
  app_display_settings?: Record<string, AppDisplaySetting>;
  has_diff: boolean;
  changed_paths: string[];
  changed_services: string[];
};

export type ProLabOSSettingsResponse = {
  repo_dir: string;
  config_file: string;
  vault_file: string;
  config_lock_file: string;
  vault_lock_file: string;
  config: Record<string, unknown>;
  vault: Record<string, unknown>;
  deployed_config: Record<string, unknown>;
  deployed_vault: Record<string, unknown>;
  has_diff: boolean;
  changed_paths: string[];
  client_secret_generated: boolean;
};

export type AppDisplaySetting = {
  previous_sort_item?: string | null;
  hidden?: boolean;
  virtual_item?: boolean;
  name?: string;
  url?: string;
};

export type AppDisplaySettingItem = {
  app_id: string;
  previous_sort_item: string | null;
  hidden: boolean;
  virtual_item?: boolean;
  name?: string;
  url?: string;
};

export type ServiceMetadata = {
  full_service_name?: string;
  description?: string;
  category?: string;
};

export type DeployStatusResponse = {
  running: boolean;
  status: "idle" | "running" | "succeeded" | "failed";
  started_at?: string;
  completed_at?: string;
  error?: string;
};

export class HlosDashApiError extends Error {
  readonly status: number;
  readonly body: unknown;

  constructor(message: string, status: number, body: unknown) {
    super(message);
    this.name = "HlosDashApiError";
    this.status = status;
    this.body = body;
  }
}

export function getConfiguredApiUrl(): string {
  const configured = import.meta.env.HLOS_DASH_API_URL?.trim();
  return normalizeApiUrl(configured || "http://127.0.0.1:8081");
}

export function normalizeApiUrl(value: string): string {
  const trimmed = value.trim();
  if (!trimmed) {
    throw new Error("API URL is required");
  }
  const withProtocol = trimmed.includes("://") ? trimmed : `http://${trimmed}`;
  return new URL(withProtocol).toString();
}

export async function fetchSettings(apiUrl: string, token: string): Promise<SettingsResponse> {
  return request(apiUrl, token, "/v1/homelabos/settings", { method: "GET" });
}

export async function patchSettings(
  apiUrl: string,
  token: string,
  changes: Record<string, unknown>,
): Promise<SettingsResponse> {
  return request(apiUrl, token, "/v1/homelabos/settings", {
    method: "PATCH",
    body: JSON.stringify({ changes }),
  });
}

export async function resetSettings(apiUrl: string, token: string): Promise<SettingsResponse> {
  return request(apiUrl, token, "/v1/homelabos/settings/reset", { method: "POST" });
}

export async function fetchProLabOSSettings(apiUrl: string, token: string): Promise<ProLabOSSettingsResponse> {
  return request(apiUrl, token, "/v1/prolabos/settings", { method: "GET" });
}

export async function patchProLabOSSettings(
  apiUrl: string,
  token: string,
  changes: Record<string, unknown>,
): Promise<ProLabOSSettingsResponse> {
  return request(apiUrl, token, "/v1/prolabos/settings", {
    method: "PATCH",
    body: JSON.stringify({ changes }),
  });
}

export async function resetProLabOSSettings(apiUrl: string, token: string): Promise<ProLabOSSettingsResponse> {
  return request(apiUrl, token, "/v1/prolabos/settings/reset", { method: "POST" });
}

export async function startDeploy(apiUrl: string, token: string): Promise<DeployStatusResponse> {
  return request(apiUrl, token, "/v1/homelabos/deploy", { method: "POST" });
}

export async function fetchDeployStatus(apiUrl: string, token: string): Promise<DeployStatusResponse> {
  return request(apiUrl, token, "/v1/homelabos/deploy/status", { method: "GET" });
}

export async function saveAppDisplaySettings(
  apiUrl: string,
  token: string,
  items: AppDisplaySettingItem[],
): Promise<Record<string, AppDisplaySetting>> {
  return request(apiUrl, token, "/v1/homelabos/app-display-settings", {
    method: "PUT",
    body: JSON.stringify({ items }),
  });
}

async function request<T>(apiUrl: string, token: string, path: string, init: RequestInit): Promise<T> {
  const response = await fetch(new URL(path, normalizeApiUrl(apiUrl)).toString(), {
    ...init,
    headers: {
      Authorization: `Bearer ${token.trim()}`,
      "Content-Type": "application/json",
      ...init.headers,
    },
  });

  const contentType = response.headers.get("Content-Type") ?? "";
  const body = contentType.includes("application/json") ? await response.json() : await response.text();
  if (!response.ok) {
    const message =
      typeof body === "object" && body !== null && "error" in body && typeof body.error === "string"
        ? body.error
        : `HTTP ${response.status}`;
    throw new HlosDashApiError(message, response.status, body);
  }

  return body as T;
}
