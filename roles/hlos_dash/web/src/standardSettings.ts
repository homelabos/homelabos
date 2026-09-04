export type StandardSettingType = "boolean" | "number" | "string";

export type StandardSettingField = {
  key: string;
  label: string;
  type: StandardSettingType;
  value: boolean | number | string;
  inputType: "checkbox" | "email" | "number" | "text";
};

export type StandardSettingDrafts = Record<string, boolean | number | string>;

const STANDARD_SETTING_KEYS = [
  "domain",
  "homelab_ip",
  "homelab_port",
  "homelab_ssh_user",
  "common_timezone",
  "admin_email",
  "ansible_port",
  "default_username",
  "volumes_root",
  "storage_dir",
  "ubuntu_release",
  "arm",
  "ldap_org_name",
  "enable_sslip",
  "enable_tor",
];

export function deriveStandardSettings(settings: Record<string, unknown>): StandardSettingField[] {
  return STANDARD_SETTING_KEYS.flatMap((key) => {
    const value = settings[key];
    if (!isEditableScalar(value)) {
      return [];
    }
    const type = standardSettingType(value);
    return [
      {
        key,
        label: formatSettingLabel(key),
        type,
        value,
        inputType: inputTypeFor(key, type),
      },
    ];
  });
}

export function deriveScalarSettings(settings: Record<string, unknown>): StandardSettingField[] {
  return Object.entries(settings)
    .flatMap(([key, value]) => {
      if (!isEditableScalar(value)) {
        return [];
      }
      const type = standardSettingType(value);
      return [
        {
          key,
          label: formatSettingLabel(key),
          type,
          value,
          inputType: inputTypeFor(key, type),
        },
      ];
    })
    .sort((a, b) => a.key.localeCompare(b.key));
}

export function standardSettingDrafts(fields: StandardSettingField[]): StandardSettingDrafts {
  return Object.fromEntries(fields.map((field) => [field.key, field.value]));
}

export function standardSettingChanges(
  fields: StandardSettingField[],
  drafts: StandardSettingDrafts,
): Record<string, boolean | number | string> {
  const changes: Record<string, boolean | number | string> = {};
  for (const field of fields) {
    if (!Object.prototype.hasOwnProperty.call(drafts, field.key)) {
      continue;
    }
    const draft = drafts[field.key];
    if (draft !== field.value) {
      changes[field.key] = draft;
    }
  }
  return changes;
}

export function coerceStandardSettingDraft(field: StandardSettingField, value: string | boolean): boolean | number | string {
  if (field.type === "boolean") {
    return Boolean(value);
  }
  if (field.type === "number") {
    return typeof value === "number" ? value : Number(value);
  }
  return String(value);
}

function isEditableScalar(value: unknown): value is boolean | number | string {
  return typeof value === "boolean" || typeof value === "number" || typeof value === "string";
}

function standardSettingType(value: boolean | number | string): StandardSettingType {
  if (typeof value === "boolean") {
    return "boolean";
  }
  if (typeof value === "number") {
    return "number";
  }
  return "string";
}

function inputTypeFor(key: string, type: StandardSettingType): StandardSettingField["inputType"] {
  if (type === "boolean") {
    return "checkbox";
  }
  if (type === "number") {
    return "number";
  }
  if (key === "admin_email") {
    return "email";
  }
  return "text";
}

function formatSettingLabel(key: string): string {
  return key
    .split("_")
    .filter(Boolean)
    .map((part) => part[0]?.toUpperCase() + part.slice(1))
    .join(" ");
}
