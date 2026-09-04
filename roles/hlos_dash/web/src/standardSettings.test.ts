import { describe, expect, it } from "vitest";

import {
  coerceStandardSettingDraft,
  deriveScalarSettings,
  deriveStandardSettings,
  standardSettingChanges,
  standardSettingDrafts,
} from "./standardSettings";

describe("deriveStandardSettings", () => {
  it("includes core top-level scalar settings and excludes services or nested groups", () => {
    const fields = deriveStandardSettings({
      domain: "example.test",
      homelab_port: 22,
      arm: false,
      enable_tor: true,
      jellyfin: { enable: true },
      bastion: { enable: false },
      minio_access_key: "{{ vault.minio_access_key }}",
      unsupported_list: ["value"],
    });

    expect(fields.map((field) => field.key)).toEqual(["domain", "homelab_port", "arm", "enable_tor"]);
    expect(fields).toContainEqual({
      key: "domain",
      label: "Domain",
      type: "string",
      value: "example.test",
      inputType: "text",
    });
    expect(fields).toContainEqual({
      key: "homelab_port",
      label: "Homelab Port",
      type: "number",
      value: 22,
      inputType: "number",
    });
    expect(fields).toContainEqual({
      key: "arm",
      label: "Arm",
      type: "boolean",
      value: false,
      inputType: "checkbox",
    });
  });

  it("uses an email input for admin_email", () => {
    expect(deriveStandardSettings({ admin_email: "admin@example.test" })[0]).toMatchObject({
      key: "admin_email",
      inputType: "email",
    });
  });
});

describe("deriveScalarSettings", () => {
  it("derives editable scalar fields from any settings object", () => {
    const fields = deriveScalarSettings({
      enable: true,
      port: 8096,
      subdomain: "jellyfin",
      nested: { value: true },
      list: ["ignored"],
    });

    expect(fields.map((field) => [field.key, field.type, field.value])).toEqual([
      ["enable", "boolean", true],
      ["port", "number", 8096],
      ["subdomain", "string", "jellyfin"],
    ]);
  });
});

describe("standard setting drafts and changes", () => {
  it("computes only changed fields", () => {
    const fields = deriveStandardSettings({
      domain: "example.test",
      homelab_port: 22,
      arm: false,
    });
    const drafts = standardSettingDrafts(fields);
    drafts.domain = "home.example.test";
    drafts.homelab_port = 2222;

    expect(standardSettingChanges(fields, drafts)).toEqual({
      domain: "home.example.test",
      homelab_port: 2222,
    });
  });

  it("coerces form values back to their original scalar types", () => {
    const fields = deriveStandardSettings({
      domain: "example.test",
      homelab_port: 22,
      arm: false,
    });

    expect(coerceStandardSettingDraft(fields[0], "home.example.test")).toBe("home.example.test");
    expect(coerceStandardSettingDraft(fields[1], "2222")).toBe(2222);
    expect(coerceStandardSettingDraft(fields[2], true)).toBe(true);
  });
});
