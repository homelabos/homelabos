export type ServiceStateFilter = "all" | "enabled" | "disabled";

export type ServiceCardModel = {
  id: string;
  config: Record<string, unknown>;
  name?: string;
  description?: string;
  category?: string;
  enabled: boolean;
  enableValue: unknown;
  docsUrl: string;
  iconUrl: string;
  launchUrl?: string;
  launchHost?: string;
  domain?: string;
  subdomain?: string;
  customDomain?: string;
  fieldCount: number;
  searchableText: string;
  changed: boolean;
  virtualItem?: boolean;
};

export type CategoryTagColor = {
  background: string;
  border: string;
  text: string;
};

export type ServiceMetadata = {
  full_service_name?: string;
  description?: string;
  category?: string;
};

export type ServiceFilters = {
  search: string;
  state: ServiceStateFilter;
  category: string;
};

export type AppDisplaySettings = Record<
  string,
  { previous_sort_item?: string | null; hidden?: boolean; virtual_item?: boolean; name?: string; url?: string }
>;

export const TOP_SORT_ITEM = "TOP";

export function deriveServices(
  settings: Record<string, unknown>,
  changedServices: string[] = [],
  serviceMetadata: Record<string, ServiceMetadata> = {},
): ServiceCardModel[] {
  const changedServiceSet = new Set(changedServices);
  const rootDomain = formatNonDefaultDomain(settings.domain);
  return Object.entries(settings)
    .flatMap(([id, value]) => {
      if (!isRecord(value) || !Object.prototype.hasOwnProperty.call(value, "enable")) {
        return [];
      }

      const domain = formatNonDefaultDomain(value.domain);
      const subdomain = formatNonDefaultSubdomain(id, value.subdomain);
      const customDomain = formatOptionalValue(value.custom_domain ?? value.customDomain);
      const launchHost = serviceLaunchHost(id, value, rootDomain);
      const launchUrl = launchHost ? hostToUrl(launchHost) : undefined;
      const metadata = serviceMetadata[id] ?? {};
      const name = formatOptionalValue(metadata.full_service_name);
      const description = formatOptionalValue(metadata.description);
      const category = formatOptionalValue(metadata.category);
      const visibleValues = [id, name, description, category, domain, subdomain, customDomain, launchHost].filter(Boolean).join(" ");

      return [
        {
          id,
          config: value,
          name,
          description,
          category,
          enabled: parseEnabled(value.enable),
          enableValue: value.enable,
          docsUrl: serviceDocsUrl(id),
          iconUrl: serviceIconUrl(id),
          launchUrl,
          launchHost,
          domain,
          subdomain,
          customDomain,
          fieldCount: Object.keys(value).length,
          searchableText: visibleValues.toLowerCase(),
          changed: changedServiceSet.has(id),
        },
      ];
    })
    .sort((a, b) => Number(b.enabled) - Number(a.enabled) || a.id.localeCompare(b.id));
}

export function filterServices(services: ServiceCardModel[], filters: ServiceFilters): ServiceCardModel[] {
  const query = filters.search.trim().toLowerCase();
  const category = filters.category.trim();
  const filtered = services.filter((service) => {
    return matchesState(service, filters.state) && matchesCategory(service, category) && (!query || service.searchableText.includes(query));
  });
  if (!query) {
    return filtered;
  }
  return filtered.sort((a, b) => serviceSearchRank(a, query) - serviceSearchRank(b, query) || a.id.localeCompare(b.id));
}

export function serviceCategories(services: ServiceCardModel[]): string[] {
  const categories = new Set<string>();
  for (const service of services) {
    if (service.category) {
      categories.add(service.category);
    }
  }
  return [...categories].sort((a, b) => a.localeCompare(b));
}

export function orderServicesByDisplaySettings<T extends { id: string }>(
  services: T[],
  displaySettings: AppDisplaySettings = {},
): T[] {
  const alphabetical = [...services].sort((a, b) => a.id.localeCompare(b.id));
  const remaining = new Map(alphabetical.map((service) => [service.id, service]));
  const ordered: T[] = [];

  function appendChain(start: T | undefined) {
    let current = start;
    while (current && remaining.has(current.id)) {
      ordered.push(current);
      remaining.delete(current.id);
      current = alphabetical.find(
        (service) => remaining.has(service.id) && displaySettings[service.id]?.previous_sort_item === current?.id,
      );
    }
  }

  appendChain(alphabetical.find((service) => displaySettings[service.id]?.previous_sort_item === TOP_SORT_ITEM));
  while (remaining.size > 0) {
    appendChain(alphabetical.find((service) => remaining.has(service.id)));
  }

  return ordered;
}

const CATEGORY_TAG_PALETTE: CategoryTagColor[] = [
  { background: "rgba(14, 165, 233, 0.26)", border: "rgba(56, 189, 248, 0.52)", text: "#e0f2fe" },
  { background: "rgba(16, 185, 129, 0.24)", border: "rgba(52, 211, 153, 0.5)", text: "#d1fae5" },
  { background: "rgba(245, 158, 11, 0.25)", border: "rgba(251, 191, 36, 0.5)", text: "#fef3c7" },
  { background: "rgba(244, 63, 94, 0.24)", border: "rgba(251, 113, 133, 0.5)", text: "#ffe4e6" },
  { background: "rgba(139, 92, 246, 0.26)", border: "rgba(167, 139, 250, 0.52)", text: "#ede9fe" },
  { background: "rgba(20, 184, 166, 0.24)", border: "rgba(45, 212, 191, 0.5)", text: "#ccfbf1" },
  { background: "rgba(132, 204, 22, 0.22)", border: "rgba(190, 242, 100, 0.46)", text: "#ecfccb" },
  { background: "rgba(217, 70, 239, 0.24)", border: "rgba(232, 121, 249, 0.5)", text: "#fae8ff" },
  { background: "rgba(99, 102, 241, 0.26)", border: "rgba(129, 140, 248, 0.52)", text: "#e0e7ff" },
  { background: "rgba(249, 115, 22, 0.24)", border: "rgba(251, 146, 60, 0.5)", text: "#ffedd5" },
  { background: "rgba(6, 182, 212, 0.24)", border: "rgba(34, 211, 238, 0.5)", text: "#cffafe" },
  { background: "rgba(236, 72, 153, 0.24)", border: "rgba(244, 114, 182, 0.5)", text: "#fce7f3" },
];

export function categoryTagColor(category: string): CategoryTagColor {
  return CATEGORY_TAG_PALETTE[hashString(category) % CATEGORY_TAG_PALETTE.length];
}

function hashString(value: string): number {
  let hash = 0;
  for (const character of value.trim().toLowerCase()) {
    hash = (hash * 31 + character.charCodeAt(0)) >>> 0;
  }
  return hash;
}

function matchesState(service: ServiceCardModel, state: ServiceStateFilter): boolean {
  if (state === "enabled") {
    return service.enabled;
  }
  if (state === "disabled") {
    return !service.enabled;
  }
  return true;
}

function matchesCategory(service: ServiceCardModel, category: string): boolean {
  return !category || service.category === category;
}

function serviceSearchRank(service: ServiceCardModel, query: string): number {
  if ([service.id, service.name].filter(Boolean).join(" ").toLowerCase().includes(query)) {
    return 0;
  }
  if ((service.description ?? "").toLowerCase().includes(query)) {
    return 1;
  }
  return 2;
}

export function parseEnabled(value: unknown): boolean {
  if (typeof value === "boolean") {
    return value;
  }
  if (typeof value === "string") {
    return value.trim().toLowerCase() === "true";
  }
  return false;
}

export function serviceDocsUrl(serviceID: string): string {
  return `https://homelabos.com/docs/software/${encodeURIComponent(serviceID)}/`;
}

export function serviceIconUrl(serviceID: string): string {
  return `https://cdn.jsdelivr.net/gh/selfhst/icons/png/${serviceIconSlug(serviceID)}.png`;
}

export function serviceIconSlug(serviceID: string): string {
  return serviceID.trim().toLowerCase().replaceAll("_", "-");
}

function formatOptionalValue(value: unknown): string | undefined {
  if (typeof value === "string") {
    const trimmed = value.trim();
    return trimmed ? trimmed : undefined;
  }
  if (typeof value === "number" || typeof value === "boolean") {
    return String(value);
  }
  return undefined;
}

function formatNonDefaultDomain(value: unknown): string | undefined {
  if (value === false) {
    return undefined;
  }
  if (typeof value === "string" && value.trim().toLowerCase() === "false") {
    return undefined;
  }
  return formatOptionalValue(value);
}

function formatNonDefaultSubdomain(serviceID: string, value: unknown): string | undefined {
  const formatted = formatOptionalValue(value);
  if (!formatted || formatted === serviceID) {
    return undefined;
  }
  return formatted;
}

function serviceLaunchHost(serviceID: string, config: Record<string, unknown>, rootDomain?: string): string | undefined {
  const customDomain = formatOptionalValue(config.custom_domain ?? config.customDomain);
  if (customDomain) {
    return customDomain;
  }

  const domain = formatNonDefaultDomain(config.domain) ?? rootDomain;
  if (!domain) {
    return undefined;
  }

  const subdomain = formatOptionalValue(config.subdomain) ?? serviceID;
  return `${subdomain}.${domain}`;
}

function hostToUrl(host: string): string {
  return /^https?:\/\//i.test(host) ? host : `https://${host}`;
}

function isRecord(value: unknown): value is Record<string, unknown> {
  return typeof value === "object" && value !== null && !Array.isArray(value);
}
