import { describe, expect, it } from "vitest";

import {
  categoryTagColor,
  deriveServices,
  filterServices,
  orderServicesByDisplaySettings,
  parseEnabled,
  serviceCategories,
  serviceDocsUrl,
  serviceIconSlug,
  serviceIconUrl,
} from "./services";

describe("parseEnabled", () => {
  it("handles booleans and string booleans", () => {
    expect(parseEnabled(true)).toBe(true);
    expect(parseEnabled(false)).toBe(false);
    expect(parseEnabled("true")).toBe(true);
    expect(parseEnabled("True")).toBe(true);
    expect(parseEnabled(" TRUE ")).toBe(true);
    expect(parseEnabled("false")).toBe(false);
    expect(parseEnabled("False")).toBe(false);
    expect(parseEnabled("yes")).toBe(false);
    expect(parseEnabled(undefined)).toBe(false);
  });
});

describe("deriveServices", () => {
  it("uses only top-level objects with an enable field", () => {
    const services = deriveServices({
      domain: "example.test",
      jellyfin: {
        enable: true,
        subdomain: "jellyfin",
        domain: false,
      },
      ollama: {
        enable: "False",
        custom_domain: "ai.example.test",
      },
      empty: {},
      list: [{ enable: true }],
    }, [], {
      jellyfin: {
        full_service_name: "Jellyfin",
        description: "Jellyfin is a media server.",
        category: "media-streaming",
      },
    });

    expect(services.map((service) => service.id)).toEqual(["jellyfin", "ollama"]);
    expect(services[0]).toMatchObject({
      id: "jellyfin",
      name: "Jellyfin",
      description: "Jellyfin is a media server.",
      category: "media-streaming",
      enabled: true,
      docsUrl: "https://homelabos.com/docs/software/jellyfin/",
      iconUrl: "https://cdn.jsdelivr.net/gh/selfhst/icons/png/jellyfin.png",
      launchHost: "jellyfin.example.test",
      launchUrl: "https://jellyfin.example.test",
      fieldCount: 3,
    });
    expect(services[0].domain).toBeUndefined();
    expect(services[0].subdomain).toBeUndefined();
    expect(services[1]).toMatchObject({
      id: "ollama",
      enabled: false,
      customDomain: "ai.example.test",
      launchHost: "ai.example.test",
      launchUrl: "https://ai.example.test",
      fieldCount: 2,
    });
  });

  it("sorts enabled services first then alphabetically", () => {
    const services = deriveServices({
      zed: { enable: false },
      actual: { enable: true },
      alpha: { enable: false },
      media: { enable: true },
    });

    expect(services.map((service) => service.id)).toEqual(["actual", "media", "alpha", "zed"]);
  });

  it("shows non-default domain and subdomain values", () => {
    const services = deriveServices({
      jellyfin: { enable: true, domain: "media.example.test", subdomain: "watch" },
    });

    expect(services[0]).toMatchObject({
      domain: "media.example.test",
      subdomain: "watch",
    });
  });

  it("marks changed services", () => {
    const services = deriveServices(
      {
        actual: { enable: true },
        jellyfin: { enable: false },
      },
      ["jellyfin"],
    );

    expect(services.map((service) => [service.id, service.changed])).toEqual([
      ["actual", false],
      ["jellyfin", true],
    ]);
  });

  it("derives sorted categories", () => {
    const services = deriveServices(
      {
        jellyfin: { enable: true },
        actual: { enable: false },
        ollama: { enable: true },
      },
      [],
      {
        jellyfin: { category: "media-streaming" },
        actual: { category: "money-budgeting-and-management" },
      },
    );

    expect(serviceCategories(services)).toEqual(["media-streaming", "money-budgeting-and-management"]);
  });
});

describe("service links", () => {
  it("builds HomelabOS docs links and self-hosted icon urls", () => {
    expect(serviceDocsUrl("firefly_iii")).toBe("https://homelabos.com/docs/software/firefly_iii/");
    expect(serviceIconSlug("Firefly_III")).toBe("firefly-iii");
    expect(serviceIconUrl("paperless_ngx")).toBe("https://cdn.jsdelivr.net/gh/selfhst/icons/png/paperless-ngx.png");
  });

  it("builds launch urls from custom domains first", () => {
    const services = deriveServices({
      domain: "example.test",
      ollama: { enable: true, custom_domain: "http://ai.example.test" },
    });

    expect(services[0]).toMatchObject({
      launchHost: "http://ai.example.test",
      launchUrl: "http://ai.example.test",
    });
  });

  it("builds launch urls from subdomain and top-level domain", () => {
    const services = deriveServices({
      domain: "example.test",
      actual: { enable: true, subdomain: "budget" },
    });

    expect(services[0]).toMatchObject({
      launchHost: "budget.example.test",
      launchUrl: "https://budget.example.test",
    });
  });

  it("builds launch urls from service-level domain overrides", () => {
    const services = deriveServices({
      domain: "example.test",
      jellyfin: { enable: true, domain: "media.example.test", subdomain: "watch" },
    });

    expect(services[0]).toMatchObject({
      launchHost: "watch.media.example.test",
      launchUrl: "https://watch.media.example.test",
    });
  });

  it("omits launch urls when no usable domain exists", () => {
    const services = deriveServices({
      actual: { enable: true, domain: false },
    });

    expect(services[0].launchHost).toBeUndefined();
    expect(services[0].launchUrl).toBeUndefined();
  });
});

describe("category tag colors", () => {
  it("assigns stable category colors", () => {
    expect(categoryTagColor("media-streaming")).toEqual(categoryTagColor("media-streaming"));
    expect(categoryTagColor("media-streaming").background).toMatch(/^rgba\(/);
    expect(categoryTagColor("media-streaming").text).toMatch(/^#/);
  });
});

describe("filterServices", () => {
  const services = deriveServices({
    actual: { enable: true, subdomain: "budget" },
    jellyfin: { enable: false, domain: "media.example.test" },
    ollama: { enable: "True", custom_domain: "ai.example.test" },
  }, [], {
    jellyfin: { description: "Jellyfin is a media server." },
  });

  it("filters by state", () => {
    expect(filterServices(services, { search: "", state: "enabled", category: "" }).map((service) => service.id)).toEqual([
      "actual",
      "ollama",
    ]);
    expect(filterServices(services, { search: "", state: "disabled", category: "" }).map((service) => service.id)).toEqual([
      "jellyfin",
    ]);
  });

  it("filters by service id and visible values", () => {
    expect(filterServices(services, { search: "jelly", state: "all", category: "" }).map((service) => service.id)).toEqual([
      "jellyfin",
    ]);
    expect(filterServices(services, { search: "media.example", state: "all", category: "" }).map((service) => service.id)).toEqual([
      "jellyfin",
    ]);
    expect(filterServices(services, { search: "ai", state: "enabled", category: "" }).map((service) => service.id)).toEqual([
      "ollama",
    ]);
    expect(filterServices(services, { search: "media server", state: "all", category: "" }).map((service) => service.id)).toEqual([
      "jellyfin",
    ]);
  });

  it("sorts name matches before description matches", () => {
    const services = deriveServices(
      {
        photos: { enable: true },
        streaming: { enable: true },
        zed: { enable: true },
      },
      [],
      {
        photos: { full_service_name: "Photo Media" },
        streaming: { description: "A media server for movies and shows." },
        zed: { description: "Another media helper." },
      },
    );

    expect(filterServices(services, { search: "media", state: "all", category: "" }).map((service) => service.id)).toEqual([
      "photos",
      "streaming",
      "zed",
    ]);
  });

  it("filters by category", () => {
    const categorizedServices = deriveServices(
      {
        actual: { enable: true },
        jellyfin: { enable: false },
        ollama: { enable: true },
      },
      [],
      {
        actual: { category: "money-budgeting-and-management" },
        jellyfin: { category: "media-streaming" },
      },
    );

    expect(
      filterServices(categorizedServices, { search: "", state: "all", category: "media-streaming" }).map(
        (service) => service.id,
      ),
    ).toEqual(["jellyfin"]);
  });
});

describe("orderServicesByDisplaySettings", () => {
  const services = deriveServices({
    actual: { enable: true },
    jellyfin: { enable: true },
    ollama: { enable: true },
    paperless: { enable: true },
  });

  it("places the TOP item first and follows previous_sort_item chains", () => {
    expect(
      orderServicesByDisplaySettings(services, {
        ollama: { previous_sort_item: "TOP", hidden: true },
        actual: { previous_sort_item: "ollama" },
      }).map((service) => service.id),
    ).toEqual(["ollama", "actual", "jellyfin", "paperless"]);
  });

  it("starts alphabetically and plugs matching followers after each preceding item", () => {
    expect(
      orderServicesByDisplaySettings(services, {
        paperless: { previous_sort_item: "actual" },
        jellyfin: { previous_sort_item: "paperless" },
      }).map((service) => service.id),
    ).toEqual(["actual", "paperless", "jellyfin", "ollama"]);
  });

  it("ignores missing references and cycles without dropping services", () => {
    expect(
      orderServicesByDisplaySettings(services, {
        actual: { previous_sort_item: "missing" },
        jellyfin: { previous_sort_item: "paperless" },
        paperless: { previous_sort_item: "jellyfin" },
      }).map((service) => service.id),
    ).toEqual(["actual", "jellyfin", "paperless", "ollama"]);
  });
});
