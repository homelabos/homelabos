import type React from "react";
import { useEffect, useMemo, useState } from "react";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { AlertTriangle, BookOpen, ChevronDown, Eye, EyeOff, ExternalLink, Filter, KeyRound, LoaderCircle, Plus, RefreshCcw, Rocket, RotateCcw, Search, Server, Settings, X } from "lucide-react";

import { Button, Card, SectionTitle, StatusPill, joinClasses } from "@homelabos/ui";

import {
  HlosDashApiError,
  fetchDeployStatus,
  fetchSettings,
  getConfiguredApiUrl,
  patchSettings,
  resetSettings,
  saveAppDisplaySettings,
  startDeploy,
  type AppDisplaySettingItem,
  type SettingsResponse,
} from "./api";
import {
  TOP_SORT_ITEM,
  categoryTagColor,
  deriveServices,
  filterServices,
  orderServicesByDisplaySettings,
  serviceCategories,
  type AppDisplaySettings,
  type ServiceStateFilter,
} from "./services";
import {
  coerceStandardSettingDraft,
  deriveScalarSettings,
  deriveStandardSettings,
  standardSettingChanges,
  standardSettingDrafts,
  type StandardSettingDrafts,
  type StandardSettingField,
} from "./standardSettings";

const TOKEN_STORAGE_KEY = "hlos_dash_api_token";
const API_URL = getConfiguredApiUrl();
type ActiveView = "dashboard" | "services" | "settings";
type DashboardService = ReturnType<typeof deriveServices>[number];

function valueAtPath(obj: unknown, path: string): unknown {
  if (!obj || typeof obj !== "object") return undefined;
  let node: unknown = obj;
  for (const segment of path.split(".")) {
    if (node == null || typeof node !== "object" || !(segment in node)) return undefined;
    node = (node as Record<string, unknown>)[segment];
  }
  return node;
}

function formatDiffValue(value: unknown): string {
  return value === undefined ? "(not set)" : JSON.stringify(value);
}

export function App() {
  const [token, setToken] = useState(() => localStorage.getItem(TOKEN_STORAGE_KEY) ?? "");
  const [draftToken, setDraftToken] = useState(token);
  const [activeView, setActiveView] = useState<ActiveView>("dashboard");
  const [selectedDashboardServiceID, setSelectedDashboardServiceID] = useState<string | null>(null);
  const [search, setSearch] = useState("");
  const [stateFilter, setStateFilter] = useState<ServiceStateFilter>("all");
  const [categoryFilter, setCategoryFilter] = useState("");
  const [standardDrafts, setStandardDrafts] = useState<StandardSettingDrafts>({});
  const [editingServiceID, setEditingServiceID] = useState<string | null>(null);
  const [serviceDrafts, setServiceDrafts] = useState<StandardSettingDrafts>({});
  const [dashboardOrderOverride, setDashboardOrderOverride] = useState<string[] | null>(null);
  const [showHiddenDashboardServices, setShowHiddenDashboardServices] = useState(false);
  const [addingVirtualApp, setAddingVirtualApp] = useState(false);
  const [virtualAppDraft, setVirtualAppDraft] = useState({ name: "", url: "" });
  const [pollDeploy, setPollDeploy] = useState(false);
  const queryClient = useQueryClient();

  const settingsQuery = useQuery({
    queryKey: ["homelabos-settings", token],
    queryFn: () => fetchSettings(API_URL, token),
    enabled: token.trim().length > 0,
    retry: false,
  });
  const deployStatusQuery = useQuery({
    queryKey: ["homelabos-deploy-status", token],
    queryFn: () => fetchDeployStatus(API_URL, token),
    enabled: token.trim().length > 0 && pollDeploy,
    refetchInterval: (query) => (query.state.data?.running ? 1000 : false),
    retry: false,
  });
  const patchSettingsMutation = useMutation({
    mutationFn: ({ changes }: { changes: Record<string, unknown>; syncDrafts?: boolean }) => patchSettings(API_URL, token, changes),
    onSuccess: (settings, variables) => {
      queryClient.setQueryData(["homelabos-settings", token], settings);
      if (variables.syncDrafts) {
        setStandardDrafts(standardSettingDrafts(deriveStandardSettings(settings.settings)));
      }
    },
  });
  const startDeployMutation = useMutation({
    mutationFn: () => startDeploy(API_URL, token),
    onSuccess: (status) => {
      setPollDeploy(true);
      queryClient.setQueryData(["homelabos-deploy-status", token], status);
    },
  });
  const resetSettingsMutation = useMutation({
    mutationFn: () => resetSettings(API_URL, token),
    onSuccess: (settings) => {
      queryClient.setQueryData(["homelabos-settings", token], settings);
      setStandardDrafts(standardSettingDrafts(deriveStandardSettings(settings.settings)));
    },
  });
  const appDisplaySettingsMutation = useMutation({
    mutationFn: ({ items }: { items: AppDisplaySettingItem[] }) => saveAppDisplaySettings(API_URL, token, items),
    onSuccess: (appDisplaySettings) => {
      queryClient.setQueryData<SettingsResponse>(["homelabos-settings", token], (current) =>
        current ? { ...current, app_display_settings: appDisplaySettings } : current,
      );
      setDashboardOrderOverride(null);
    },
  });

  const services = useMemo(
    () =>
      deriveServices(
        settingsQuery.data?.settings ?? {},
        settingsQuery.data?.changed_services ?? [],
        settingsQuery.data?.service_metadata ?? {},
      ),
    [settingsQuery.data?.changed_services, settingsQuery.data?.service_metadata, settingsQuery.data?.settings],
  );
  const categories = useMemo(() => serviceCategories(services), [services]);
  const filteredServices = useMemo(
    () => filterServices(services, { search, state: stateFilter, category: categoryFilter }),
    [categoryFilter, search, services, stateFilter],
  );
  const virtualDashboardServices = useMemo(
    () => virtualServicesFromDisplaySettings(settingsQuery.data?.app_display_settings ?? {}),
    [settingsQuery.data?.app_display_settings],
  );
  const dashboardServices = useMemo(
    () => [...services.filter((service) => service.enabled && service.launchUrl), ...virtualDashboardServices],
    [services, virtualDashboardServices],
  );
  const orderedDashboardServices = useMemo(() => {
    if (!dashboardOrderOverride) {
      return orderServicesByDisplaySettings(dashboardServices, settingsQuery.data?.app_display_settings ?? {});
    }
    const serviceByID = new Map(dashboardServices.map((service) => [service.id, service]));
    const ordered = dashboardOrderOverride.flatMap((serviceID) => {
      const service = serviceByID.get(serviceID);
      if (!service) {
        return [];
      }
      serviceByID.delete(serviceID);
      return [service];
    });
    return [...ordered, ...orderServicesByDisplaySettings([...serviceByID.values()], settingsQuery.data?.app_display_settings ?? {})];
  }, [dashboardOrderOverride, dashboardServices, settingsQuery.data?.app_display_settings]);
  const visibleDashboardServices = useMemo(
    () =>
      orderedDashboardServices.filter(
        (service) => showHiddenDashboardServices || !settingsQuery.data?.app_display_settings?.[service.id]?.hidden,
      ),
    [orderedDashboardServices, settingsQuery.data?.app_display_settings, showHiddenDashboardServices],
  );
  const editingService = services.find((service) => service.id === editingServiceID);
  const serviceFields = useMemo(
    () => deriveScalarSettings(editingService?.config ?? {}),
    [editingService?.config],
  );
  const serviceChanges = useMemo(
    () => standardSettingChanges(serviceFields, serviceDrafts),
    [serviceDrafts, serviceFields],
  );
  const standardFields = useMemo(
    () => deriveStandardSettings(settingsQuery.data?.settings ?? {}),
    [settingsQuery.data?.settings],
  );
  const standardChanges = useMemo(
    () => standardSettingChanges(standardFields, standardDrafts),
    [standardDrafts, standardFields],
  );
  const standardDirty = Object.keys(standardChanges).length > 0;
  const enabledCount = services.filter((service) => service.enabled).length;
  const disabledCount = services.length - enabledCount;
  const deployStatus = deployStatusQuery.data;
  const deployRunning = deployStatus?.running || startDeployMutation.isPending;
  const controlsDisabled = Boolean(deployRunning || patchSettingsMutation.isPending || resetSettingsMutation.isPending);

  useEffect(() => {
    if (!pollDeploy || deployStatus?.running || !deployStatus || deployStatus.status === "idle") {
      return;
    }
    if (deployStatus.status === "succeeded") {
      settingsQuery.refetch();
    }
    setPollDeploy(false);
  }, [deployStatus, pollDeploy, settingsQuery]);

  useEffect(() => {
    if (!standardDirty) {
      setStandardDrafts(standardSettingDrafts(standardFields));
    }
  }, [standardDirty, standardFields]);

  useEffect(() => {
    if (visibleDashboardServices.length === 0) {
      setSelectedDashboardServiceID(null);
      return;
    }
    if (!selectedDashboardServiceID || !visibleDashboardServices.some((service) => service.id === selectedDashboardServiceID)) {
      setSelectedDashboardServiceID(visibleDashboardServices[0].id);
    }
  }, [selectedDashboardServiceID, visibleDashboardServices]);

  function saveToken() {
    const normalized = draftToken.trim();
    localStorage.setItem(TOKEN_STORAGE_KEY, normalized);
    setToken(normalized);
  }

  function clearToken() {
    localStorage.removeItem(TOKEN_STORAGE_KEY);
    setToken("");
    setDraftToken("");
    setPollDeploy(false);
  }

  function handleToggle(serviceID: string, enabled: boolean) {
    patchSettingsMutation.mutate({ changes: { [`${serviceID}.enable`]: enabled } });
  }

  function handleSaveStandardSettings() {
    patchSettingsMutation.mutate({ changes: standardChanges, syncDrafts: true });
  }

  function handleOpenServiceSettings(serviceID: string) {
    const service = services.find((candidate) => candidate.id === serviceID);
    if (!service) {
      return;
    }
    const fields = deriveScalarSettings(service.config);
    setEditingServiceID(serviceID);
    setServiceDrafts(standardSettingDrafts(fields));
  }

  function handleCloseServiceSettings() {
    setEditingServiceID(null);
    setServiceDrafts({});
  }

  function handleSaveServiceSettings() {
    if (!editingService) {
      return;
    }
    const changes = Object.fromEntries(
      Object.entries(serviceChanges).map(([key, value]) => [`${editingService.id}.${key}`, value]),
    );
    patchSettingsMutation.mutate(
      { changes },
      {
        onSuccess: () => {
          handleCloseServiceSettings();
        },
      },
    );
  }

  function handleDeploy() {
    startDeployMutation.mutate();
  }

  function handleResetSettings() {
    resetSettingsMutation.mutate();
  }

  function handleDashboardReorder(serviceIDs: string[]) {
    const previousOrder = visibleDashboardServices.map((service) => service.id);
    const items = dashboardDisplayItems(dashboardServices, settingsQuery.data?.app_display_settings ?? {}, {
      orderedServiceIDs: serviceIDs,
      preserveSortForMissing: true,
    });
    setDashboardOrderOverride(serviceIDs);
    saveDashboardDisplayItems(items, previousOrder);
  }

  function handleDashboardHiddenChange(serviceID: string, hidden: boolean) {
    const currentSettings = settingsQuery.data?.app_display_settings ?? {};
    const items = dashboardDisplayItems(dashboardServices, currentSettings, { hiddenOverrides: { [serviceID]: hidden } });
    saveDashboardDisplayItems(items, visibleDashboardServices.map((service) => service.id));
  }

  function handleDashboardSortAlphabetically() {
    const items = dashboardDisplayItems(dashboardServices, settingsQuery.data?.app_display_settings ?? {}, { clearSort: true });
    setDashboardOrderOverride(null);
    saveDashboardDisplayItems(items, visibleDashboardServices.map((service) => service.id));
  }

  function handleAddVirtualApp() {
    const name = virtualAppDraft.name.trim();
    const url = normalizeVirtualAppUrl(virtualAppDraft.url);
    if (!name || !url) {
      return;
    }
    const appID = `virtual-${globalThis.crypto?.randomUUID?.() ?? `${Date.now()}-${Math.random().toString(16).slice(2)}`}`;
    const currentSettings = settingsQuery.data?.app_display_settings ?? {};
    const currentItems = dashboardDisplayItems(dashboardServices, currentSettings);
    const items: AppDisplaySettingItem[] = [
      ...currentItems,
      {
        app_id: appID,
        previous_sort_item: null,
        hidden: false,
        virtual_item: true,
        name,
        url,
      },
    ];
    saveDashboardDisplayItems(items, visibleDashboardServices.map((service) => service.id));
    setVirtualAppDraft({ name: "", url: "" });
    setAddingVirtualApp(false);
  }

  function saveDashboardDisplayItems(items: AppDisplaySettingItem[], previousOrder: string[]) {
    const previousSettings = settingsQuery.data?.app_display_settings ?? {};
    queryClient.setQueryData<SettingsResponse>(["homelabos-settings", token], (current) =>
      current ? { ...current, app_display_settings: appDisplaySettingsFromItems(items) } : current,
    );
    appDisplaySettingsMutation.mutate(
      { items },
      {
        onError: () => {
          queryClient.setQueryData<SettingsResponse>(["homelabos-settings", token], (current) =>
            current ? { ...current, app_display_settings: previousSettings } : current,
          );
          setDashboardOrderOverride(previousOrder);
          settingsQuery.refetch();
        },
      },
    );
  }

  return (
    <div className="prolabos-page">
      <header className="prolabos-nav hlos-nav">
        <div className="hlos-nav-primary">
          <a className="prolabos-nav-brand" href="/">
            HomelabOS Dash
          </a>
          {token ? (
            <nav className="hlos-top-tabs" aria-label="Dashboard sections">
              <button
                className={joinClasses(activeView === "dashboard" && "is-active")}
                type="button"
                onClick={() => setActiveView("dashboard")}
              >
                Dashboard
              </button>
              <button
                className={joinClasses(activeView === "services" && "is-active")}
                type="button"
                onClick={() => setActiveView("services")}
              >
                App store
              </button>
              <button
                className={joinClasses(activeView === "settings" && "is-active")}
                type="button"
                onClick={() => setActiveView("settings")}
              >
                Settings
              </button>
            </nav>
          ) : null}
        </div>
        <div className="hlos-nav-meta">
          {token ? (
            <Button type="button" variant="ghost" onClick={clearToken}>
              <span className="inline-flex items-center gap-2">
                <KeyRound size={16} />
                Logout
              </span>
            </Button>
          ) : null}
        </div>
      </header>

      <main className={joinClasses("hlos-dashboard", activeView === "dashboard" && "hlos-dashboard-wide")}>
        {!token ? (
          <TokenPanel draftToken={draftToken} setDraftToken={setDraftToken} saveToken={saveToken} />
        ) : (
          <>
            {activeView === "dashboard" ? null : (
              <section className="hlos-hero">
                <div>
                  <p className="prolabos-eyebrow">Local HomelabOS</p>
                  <h1>{activeView === "services" ? "App store" : "Settings"}</h1>
                  <p className="prolabos-muted">
                    {activeView === "services"
                      ? "Review services from the current HomelabOS settings file."
                      : "Edit core top-level HomelabOS settings from the current settings file."}
                  </p>
                </div>
                <Button type="button" variant="secondary" onClick={() => settingsQuery.refetch()} disabled={settingsQuery.isFetching}>
                  <span className="inline-flex items-center gap-2">
                    <RefreshCcw size={16} />
                    Refresh
                  </span>
                </Button>
              </section>
            )}

            {settingsQuery.isLoading ? <StatusCard icon={<Settings size={18} />} title="Loading settings" /> : null}

            {settingsQuery.isError ? (
              <ErrorCard error={settingsQuery.error} clearToken={clearToken} />
            ) : settingsQuery.data ? (
              <>
                {settingsQuery.data.has_diff ? (
                  <Card className="hlos-diff-banner">
                    <AlertTriangle size={20} />
                    <div>
                      <SectionTitle>Settings are not deployed</SectionTitle>
                      <p className="prolabos-muted mt-2">
                        {settingsQuery.data.changed_services.length} services and {settingsQuery.data.changed_paths.length} settings differ from the deployed lock.
                      </p>
                      {deployStatus?.status === "failed" ? (
                        <p className="hlos-error-text mt-2">{deployStatus.error || "Deploy failed"}</p>
                      ) : null}
                    </div>
                    <div className="hlos-diff-actions">
                      <Button type="button" variant="secondary" onClick={handleResetSettings} disabled={controlsDisabled}>
                        <span className="inline-flex items-center gap-2">
                          {resetSettingsMutation.isPending ? <LoaderCircle className="hlos-spin" size={16} /> : <RotateCcw size={16} />}
                          Reset
                        </span>
                      </Button>
                      <Button type="button" onClick={handleDeploy} disabled={deployRunning || resetSettingsMutation.isPending}>
                        <span className="inline-flex items-center gap-2">
                          {deployRunning ? <LoaderCircle className="hlos-spin" size={16} /> : <Rocket size={16} />}
                          {deployRunning ? "Deploying" : "Deploy"}
                        </span>
                      </Button>
                    </div>
                    <details className="hlos-diff-details">
                      <summary className="hlos-diff-summary">
                        <ChevronDown size={16} />
                        <span>Show diff</span>
                      </summary>
                      <div className="hlos-diff-list">
                        {settingsQuery.data.changed_paths.map((path) => {
                          const current = valueAtPath(settingsQuery.data.settings, path);
                          const deployed = valueAtPath(settingsQuery.data.deployed_settings, path);
                          return (
                            <div className="hlos-diff-row" key={path}>
                              <code className="hlos-diff-path">{path}</code>
                              <div className="hlos-diff-values">
                                <span className="hlos-diff-old" title="deployed">{formatDiffValue(deployed)}</span>
                                <span className="hlos-diff-arrow">→</span>
                                <span className="hlos-diff-new" title="current">{formatDiffValue(current)}</span>
                              </div>
                            </div>
                          );
                        })}
                      </div>
                    </details>
                  </Card>
                ) : deployStatus?.status === "succeeded" ? (
                  <Card className="hlos-clean-banner">
                    <Rocket size={18} />
                    <span>Latest settings have been deployed.</span>
                  </Card>
                ) : null}

                {patchSettingsMutation.isError ? <InlineError error={patchSettingsMutation.error} /> : null}
                {startDeployMutation.isError ? <InlineError error={startDeployMutation.error} /> : null}
                {resetSettingsMutation.isError ? <InlineError error={resetSettingsMutation.error} /> : null}
                {appDisplaySettingsMutation.isError ? <InlineError error={appDisplaySettingsMutation.error} /> : null}

                {activeView === "dashboard" ? (
                  <DashboardView
                    appDisplaySettings={settingsQuery.data.app_display_settings ?? {}}
                    isSavingOrder={appDisplaySettingsMutation.isPending}
                    selectedServiceID={selectedDashboardServiceID}
                    services={visibleDashboardServices}
                    showHidden={showHiddenDashboardServices}
                    onAddVirtualApp={() => setAddingVirtualApp(true)}
                    onHiddenChange={handleDashboardHiddenChange}
                    onReorder={handleDashboardReorder}
                    onSelectService={setSelectedDashboardServiceID}
                    onShowHiddenChange={setShowHiddenDashboardServices}
                    onSortAlphabetically={handleDashboardSortAlphabetically}
                  />
                ) : activeView === "services" ? (
                  <ServicesView
                    categories={categories}
                    categoryFilter={categoryFilter}
                    controlsDisabled={controlsDisabled}
                    disabledCount={disabledCount}
                    enabledCount={enabledCount}
                    filteredServices={filteredServices}
                    search={search}
                    servicesCount={services.length}
                    stateFilter={stateFilter}
                    setCategoryFilter={setCategoryFilter}
                    setSearch={setSearch}
                    setStateFilter={setStateFilter}
                    onOpenServiceSettings={handleOpenServiceSettings}
                    onToggle={handleToggle}
                  />
                ) : (
                  <SettingsView
                    changes={standardChanges}
                    controlsDisabled={controlsDisabled}
                    drafts={standardDrafts}
                    fields={standardFields}
                    isSaving={patchSettingsMutation.isPending}
                    onDraftChange={setStandardDrafts}
                    onSave={handleSaveStandardSettings}
                  />
                )}
                {addingVirtualApp ? (
                  <VirtualAppModal
                    draft={virtualAppDraft}
                    onChange={setVirtualAppDraft}
                    onClose={() => setAddingVirtualApp(false)}
                    onSave={handleAddVirtualApp}
                  />
                ) : null}
                {editingService ? (
                  <ServiceSettingsModal
                    changes={serviceChanges}
                    controlsDisabled={controlsDisabled}
                    drafts={serviceDrafts}
                    fields={serviceFields}
                    isSaving={patchSettingsMutation.isPending}
                    serviceID={editingService.id}
                    onClose={handleCloseServiceSettings}
                    onDraftChange={setServiceDrafts}
                    onSave={handleSaveServiceSettings}
                  />
                ) : null}
              </>
            ) : null}
          </>
        )}
      </main>
    </div>
  );
}

function DashboardView({
  appDisplaySettings,
  isSavingOrder,
  selectedServiceID,
  services,
  showHidden,
  onAddVirtualApp,
  onHiddenChange,
  onReorder,
  onSelectService,
  onShowHiddenChange,
  onSortAlphabetically,
}: {
  appDisplaySettings: AppDisplaySettings;
  isSavingOrder: boolean;
  selectedServiceID: string | null;
  services: DashboardService[];
  showHidden: boolean;
  onAddVirtualApp: () => void;
  onHiddenChange: (serviceID: string, hidden: boolean) => void;
  onReorder: (serviceIDs: string[]) => void;
  onSelectService: (serviceID: string) => void;
  onShowHiddenChange: (showHidden: boolean) => void;
  onSortAlphabetically: () => void;
}) {
  const [draggedServiceID, setDraggedServiceID] = useState<string | null>(null);
  const [dragOverServiceID, setDragOverServiceID] = useState<string | null>(null);
  const [settingsOpen, setSettingsOpen] = useState(false);
  const selectedService = services.find((service) => service.id === selectedServiceID) ?? services[0];

  return (
    <section className="hlos-service-dashboard" aria-label="Enabled service dashboard">
      <aside
        className="hlos-service-sidebar"
        aria-label="Enabled services"
        onDragOver={(event) => event.preventDefault()}
        onDrop={(event) => {
          event.preventDefault();
          if (draggedServiceID && event.currentTarget === event.target) {
            onReorder(moveServiceID(services.map((service) => service.id), draggedServiceID));
          }
          setDraggedServiceID(null);
          setDragOverServiceID(null);
        }}
      >
        <div className="hlos-service-sidebar-header">
          <span>Apps</span>
          <div className="hlos-service-sidebar-tools">
            <button
              className="hlos-icon-button hlos-service-sidebar-tool-button"
              type="button"
              title="Add app"
              aria-label="Add app"
              onClick={onAddVirtualApp}
            >
              <Plus size={16} />
            </button>
          <div className="hlos-service-sidebar-settings">
            <button
              className="hlos-icon-button hlos-service-sidebar-tool-button"
              type="button"
              title="Dashboard list settings"
              aria-label="Dashboard list settings"
              aria-expanded={settingsOpen}
              onClick={() => setSettingsOpen((current) => !current)}
            >
              <Settings size={16} />
            </button>
            {settingsOpen ? (
              <div className="hlos-service-sidebar-menu">
                <button type="button" onClick={onSortAlphabetically} disabled={isSavingOrder}>
                  Sort A-Z
                </button>
                <label>
                  <span>Show Hidden</span>
                  <input
                    type="checkbox"
                    checked={showHidden}
                    onChange={(event) => onShowHiddenChange(event.target.checked)}
                  />
                </label>
              </div>
            ) : null}
          </div>
          </div>
        </div>
        {services.map((service) => (
          <button
            key={service.id}
            className={joinClasses(
              "hlos-service-nav-item",
              selectedService?.id === service.id && "is-active",
              draggedServiceID === service.id && "is-dragging",
              dragOverServiceID === service.id && draggedServiceID !== service.id && "is-drag-over",
              appDisplaySettings[service.id]?.hidden && "is-hidden",
            )}
            draggable={!isSavingOrder}
            type="button"
            onDragEnd={() => {
              setDraggedServiceID(null);
              setDragOverServiceID(null);
            }}
            onDragOver={(event) => {
              event.preventDefault();
              if (draggedServiceID && draggedServiceID !== service.id) {
                setDragOverServiceID(service.id);
              }
            }}
            onDragStart={(event) => {
              setDraggedServiceID(service.id);
              event.dataTransfer.effectAllowed = "move";
              event.dataTransfer.setData("text/plain", service.id);
            }}
            onDrop={(event) => {
              event.preventDefault();
              const sourceID = draggedServiceID || event.dataTransfer.getData("text/plain");
              if (sourceID && sourceID !== service.id) {
                onReorder(moveServiceID(services.map((candidate) => candidate.id), sourceID, service.id));
              }
              setDraggedServiceID(null);
              setDragOverServiceID(null);
            }}
            onClick={() => onSelectService(service.id)}
          >
            <ServiceIcon service={service} />
            <span>
              <strong>{service.name || service.id}</strong>
              <small>{service.launchHost}</small>
            </span>
            <span className="hlos-service-nav-actions">
              {appDisplaySettings[service.id]?.hidden ? (
                <span
                  className="hlos-icon-button hlos-service-nav-action"
                  role="button"
                  tabIndex={0}
                  title={`Show ${service.id}`}
                  aria-label={`Show ${service.id}`}
                  onClick={(event) => {
                    event.stopPropagation();
                    onHiddenChange(service.id, false);
                  }}
                  onKeyDown={(event) => {
                    if (event.key === "Enter" || event.key === " ") {
                      event.preventDefault();
                      event.stopPropagation();
                      onHiddenChange(service.id, false);
                    }
                  }}
                >
                  <Eye size={15} />
                </span>
              ) : (
                <span
                  className="hlos-icon-button hlos-service-nav-action"
                  role="button"
                  tabIndex={0}
                  title={`Hide ${service.id}`}
                  aria-label={`Hide ${service.id}`}
                  onClick={(event) => {
                    event.stopPropagation();
                    onHiddenChange(service.id, true);
                  }}
                  onKeyDown={(event) => {
                    if (event.key === "Enter" || event.key === " ") {
                      event.preventDefault();
                      event.stopPropagation();
                      onHiddenChange(service.id, true);
                    }
                  }}
                >
                  <EyeOff size={15} />
                </span>
              )}
            </span>
          </button>
        ))}
      </aside>

      <section className="hlos-service-frame-panel" aria-label={selectedService ? `${selectedService.id} service` : "Selected service"}>
        {selectedService ? (
          <>
            <div className="hlos-service-frame-header">
              <div>
                <SectionTitle>{selectedService.name || selectedService.id}</SectionTitle>
                <p className="prolabos-muted mt-2">{selectedService.launchHost}</p>
              </div>
              <a
                className="hlos-icon-button"
                href={selectedService.launchUrl}
                target="_blank"
                rel="noreferrer"
                title={`Open ${selectedService.id} in a new tab`}
                aria-label={`Open ${selectedService.id} in a new tab`}
              >
                <ExternalLink size={16} />
              </a>
            </div>
            <iframe
              className="hlos-service-frame"
              src={selectedService.launchUrl}
              title={`${selectedService.id} dashboard`}
            />
          </>
        ) : (
          <StatusCard icon={<Server size={18} />} title="No enabled services have launch URLs" />
        )}
      </section>
    </section>
  );
}

function moveServiceID(serviceIDs: string[], sourceID: string, targetID?: string): string[] {
  const sourceIndex = serviceIDs.indexOf(sourceID);
  if (sourceIndex === -1) {
    return serviceIDs;
  }
  const nextIDs = [...serviceIDs];
  nextIDs.splice(sourceIndex, 1);
  if (!targetID) {
    nextIDs.push(sourceID);
    return nextIDs;
  }
  const targetIndex = nextIDs.indexOf(targetID);
  if (targetIndex === -1) {
    nextIDs.push(sourceID);
    return nextIDs;
  }
  nextIDs.splice(targetIndex, 0, sourceID);
  return nextIDs;
}

function VirtualAppModal({
  draft,
  onChange,
  onClose,
  onSave,
}: {
  draft: { name: string; url: string };
  onChange: (draft: { name: string; url: string }) => void;
  onClose: () => void;
  onSave: () => void;
}) {
  return (
    <div className="hlos-modal-backdrop" role="presentation" onMouseDown={onClose}>
      <Card
        className="hlos-modal hlos-virtual-app-modal"
        role="dialog"
        aria-modal="true"
        aria-labelledby="hlos-virtual-app-title"
        onMouseDown={(event) => event.stopPropagation()}
      >
        <div className="hlos-settings-panel-header">
          <div>
            <SectionTitle id="hlos-virtual-app-title">Add app tab</SectionTitle>
            <p className="prolabos-muted mt-2">Add a custom app to this dashboard.</p>
          </div>
          <button className="hlos-icon-button" type="button" title="Close" aria-label="Close add app" onClick={onClose}>
            <X size={16} />
          </button>
        </div>
        <div className="hlos-settings-grid">
          <label className="hlos-setting-field">
            <span>
              <strong>Name</strong>
              <code>Display name</code>
            </span>
            <input
              type="text"
              value={draft.name}
              onChange={(event) => onChange({ ...draft, name: event.target.value })}
            />
          </label>
          <label className="hlos-setting-field">
            <span>
              <strong>URL</strong>
              <code>Application URL</code>
            </span>
            <input
              type="url"
              value={draft.url}
              onChange={(event) => onChange({ ...draft, url: event.target.value })}
            />
          </label>
        </div>
        <div className="hlos-modal-actions">
          <Button type="button" variant="secondary" onClick={onClose}>
            Cancel
          </Button>
          <Button type="button" onClick={onSave} disabled={!draft.name.trim() || !draft.url.trim()}>
            <span className="inline-flex items-center gap-2">
              <Plus size={16} />
              Add
            </span>
          </Button>
        </div>
      </Card>
    </div>
  );
}

function dashboardDisplayItems(
  services: DashboardService[],
  currentSettings: AppDisplaySettings,
  options: {
    clearSort?: boolean;
    hiddenOverrides?: Record<string, boolean>;
    orderedServiceIDs?: string[];
    preserveSortForMissing?: boolean;
  } = {},
): AppDisplaySettingItem[] {
  const serviceIDs = services.map((service) => service.id);
  const orderedIDs = options.orderedServiceIDs ?? [];
  const orderedSet = new Set(orderedIDs);
  const previousByID = new Map<string, string | null>();

  if (!options.clearSort && options.orderedServiceIDs) {
    orderedIDs.forEach((serviceID, index) => {
      previousByID.set(serviceID, index === 0 ? TOP_SORT_ITEM : orderedIDs[index - 1]);
    });
  }

  return serviceIDs.map((serviceID) => {
    const current = currentSettings[serviceID];
    const service = services.find((candidate) => candidate.id === serviceID);
    const hidden = options.hiddenOverrides?.[serviceID] ?? Boolean(current?.hidden);
    const virtualItem = Boolean(current?.virtual_item || service?.virtualItem);
    let previousSortItem: string | null = null;
    if (!options.clearSort) {
      previousSortItem =
        previousByID.get(serviceID) ??
        (!options.orderedServiceIDs || (options.preserveSortForMissing && !orderedSet.has(serviceID))
          ? current?.previous_sort_item ?? null
          : null);
    }
    return {
      app_id: serviceID,
      previous_sort_item: previousSortItem,
      hidden,
      virtual_item: virtualItem || undefined,
      name: virtualItem ? current?.name || service?.name : undefined,
      url: virtualItem ? current?.url || service?.launchUrl : undefined,
    };
  });
}

function appDisplaySettingsFromItems(items: AppDisplaySettingItem[]): AppDisplaySettings {
  return Object.fromEntries(
    items.map((item) => [
      item.app_id,
      {
        previous_sort_item: item.previous_sort_item,
        hidden: item.hidden,
        virtual_item: item.virtual_item,
        name: item.name,
        url: item.url,
      },
    ]),
  );
}

function virtualServicesFromDisplaySettings(displaySettings: AppDisplaySettings): DashboardService[] {
  return Object.entries(displaySettings)
    .flatMap(([appID, setting]) => {
      if (!setting.virtual_item || !setting.name || !setting.url) {
        return [];
      }
      const launchUrl = normalizeVirtualAppUrl(setting.url);
      if (!launchUrl) {
        return [];
      }
      return [
        {
          id: appID,
          config: {},
          name: setting.name,
          enabled: true,
          enableValue: true,
          docsUrl: launchUrl,
          iconUrl: "",
          launchUrl,
          launchHost: virtualAppHost(launchUrl),
          fieldCount: 0,
          searchableText: `${appID} ${setting.name} ${launchUrl}`.toLowerCase(),
          changed: false,
          virtualItem: true,
        },
      ];
    })
    .sort((a, b) => a.id.localeCompare(b.id));
}

function normalizeVirtualAppUrl(value: string): string {
  const trimmed = value.trim();
  if (!trimmed) {
    return "";
  }
  const withProtocol = /^https?:\/\//i.test(trimmed) ? trimmed : `https://${trimmed}`;
  try {
    return new URL(withProtocol).toString();
  } catch {
    return "";
  }
}

function virtualAppHost(value: string): string {
  try {
    return new URL(value).host;
  } catch {
    return value;
  }
}

function ServicesView({
  categories,
  categoryFilter,
  controlsDisabled,
  disabledCount,
  enabledCount,
  filteredServices,
  search,
  servicesCount,
  stateFilter,
  setCategoryFilter,
  setSearch,
  setStateFilter,
  onOpenServiceSettings,
  onToggle,
}: {
  categories: string[];
  categoryFilter: string;
  controlsDisabled: boolean;
  disabledCount: number;
  enabledCount: number;
  filteredServices: ReturnType<typeof deriveServices>;
  search: string;
  servicesCount: number;
  stateFilter: ServiceStateFilter;
  setCategoryFilter: (value: string) => void;
  setSearch: (value: string) => void;
  setStateFilter: (value: ServiceStateFilter) => void;
  onOpenServiceSettings: (serviceID: string) => void;
  onToggle: (serviceID: string, enabled: boolean) => void;
}) {
  return (
    <>
      <section className="hlos-summary-grid" aria-label="Service summary">
        <SummaryCard label="Total services" value={servicesCount} />
        <SummaryCard label="Enabled" value={enabledCount} tone="success" />
        <SummaryCard label="Disabled" value={disabledCount} tone="warning" />
      </section>

      <Card className="hlos-toolbar">
        <label className="hlos-search">
          <Search size={18} />
          <input
            value={search}
            onChange={(event) => setSearch(event.target.value)}
            placeholder="Search services, descriptions, domains"
          />
        </label>
        <label className="hlos-select-field">
          <span>Category</span>
          <select value={categoryFilter} onChange={(event) => setCategoryFilter(event.target.value)}>
            <option value="">All categories</option>
            {categories.map((category) => (
              <option key={category} value={category}>
                {formatCategory(category)}
              </option>
            ))}
          </select>
        </label>
        <div className="hlos-segmented" aria-label="Service state filter">
          {[
            ["all", "All"],
            ["enabled", "Enabled"],
            ["disabled", "Disabled"],
          ].map(([value, label]) => (
            <button
              key={value}
              className={joinClasses(stateFilter === value && "is-active")}
              type="button"
              onClick={() => setStateFilter(value as ServiceStateFilter)}
            >
              {label}
            </button>
          ))}
        </div>
      </Card>

      {filteredServices.length ? (
        <section className="hlos-service-grid" aria-label="Services">
          {filteredServices.map((service) => (
            <ServiceCard
              key={service.id}
              disabled={controlsDisabled}
              service={service}
              onSelectCategory={setCategoryFilter}
              onOpenSettings={onOpenServiceSettings}
              onToggle={onToggle}
            />
          ))}
        </section>
      ) : (
        <StatusCard icon={<Filter size={18} />} title="No services match these filters" />
      )}
    </>
  );
}

function ServiceSettingsModal({
  changes,
  controlsDisabled,
  drafts,
  fields,
  isSaving,
  serviceID,
  onClose,
  onDraftChange,
  onSave,
}: {
  changes: Record<string, boolean | number | string>;
  controlsDisabled: boolean;
  drafts: StandardSettingDrafts;
  fields: StandardSettingField[];
  isSaving: boolean;
  serviceID: string;
  onClose: () => void;
  onDraftChange: React.Dispatch<React.SetStateAction<StandardSettingDrafts>>;
  onSave: () => void;
}) {
  const dirtyKeys = new Set(Object.keys(changes));
  const isDirty = dirtyKeys.size > 0;

  function updateField(field: StandardSettingField, value: string | boolean) {
    const coerced = coerceStandardSettingDraft(field, value);
    onDraftChange((current) => ({ ...current, [field.key]: coerced }));
  }

  return (
    <div className="hlos-modal-backdrop" role="presentation" onMouseDown={onClose}>
      <Card
        className="hlos-modal"
        role="dialog"
        aria-modal="true"
        aria-labelledby="hlos-service-settings-title"
        onMouseDown={(event) => event.stopPropagation()}
      >
        <div className="hlos-settings-panel-header">
          <div>
            <SectionTitle id="hlos-service-settings-title">{serviceID} settings</SectionTitle>
            <p className="prolabos-muted mt-2">
              {isDirty ? `${dirtyKeys.size} setting${dirtyKeys.size === 1 ? "" : "s"} changed.` : "No unsaved setting changes."}
            </p>
          </div>
          <button className="hlos-icon-button" type="button" title="Close" aria-label="Close service settings" onClick={onClose}>
            <X size={16} />
          </button>
        </div>

        {fields.length ? (
          <div className="hlos-settings-grid">
            {fields.map((field) => (
              <SettingField
                key={field.key}
                dirty={dirtyKeys.has(field.key)}
                disabled={controlsDisabled}
                draft={drafts[field.key] ?? field.value}
                field={field}
                onChange={updateField}
              />
            ))}
          </div>
        ) : (
          <p className="prolabos-muted">No scalar settings found for this service.</p>
        )}

        <div className="hlos-modal-actions">
          <Button type="button" variant="secondary" onClick={onClose}>
            Cancel
          </Button>
          <Button type="button" onClick={onSave} disabled={!isDirty || controlsDisabled}>
            <span className="inline-flex items-center gap-2">
              {isSaving ? <LoaderCircle className="hlos-spin" size={16} /> : <Settings size={16} />}
              Save
            </span>
          </Button>
        </div>
      </Card>
    </div>
  );
}

function SettingsView({
  changes,
  controlsDisabled,
  drafts,
  fields,
  isSaving,
  onDraftChange,
  onSave,
}: {
  changes: Record<string, boolean | number | string>;
  controlsDisabled: boolean;
  drafts: StandardSettingDrafts;
  fields: StandardSettingField[];
  isSaving: boolean;
  onDraftChange: React.Dispatch<React.SetStateAction<StandardSettingDrafts>>;
  onSave: () => void;
}) {
  const dirtyKeys = new Set(Object.keys(changes));
  const isDirty = dirtyKeys.size > 0;

  function updateField(field: StandardSettingField, value: string | boolean) {
    const coerced = coerceStandardSettingDraft(field, value);
    onDraftChange((current) => ({ ...current, [field.key]: coerced }));
  }

  return (
    <Card className="hlos-settings-panel">
      <div className="hlos-settings-panel-header">
        <div>
          <SectionTitle>Core settings</SectionTitle>
          <p className="prolabos-muted mt-2">
            {isDirty ? `${dirtyKeys.size} setting${dirtyKeys.size === 1 ? "" : "s"} changed.` : "No unsaved setting changes."}
          </p>
        </div>
        <Button type="button" onClick={onSave} disabled={!isDirty || controlsDisabled}>
          <span className="inline-flex items-center gap-2">
            {isSaving ? <LoaderCircle className="hlos-spin" size={16} /> : <Settings size={16} />}
            Save
          </span>
        </Button>
      </div>

      {fields.length ? (
        <div className="hlos-settings-grid">
          {fields.map((field) => (
            <SettingField
              key={field.key}
              dirty={dirtyKeys.has(field.key)}
              disabled={controlsDisabled}
              draft={drafts[field.key] ?? field.value}
              field={field}
              onChange={updateField}
            />
          ))}
        </div>
      ) : (
        <p className="prolabos-muted">No standard top-level settings found.</p>
      )}
    </Card>
  );
}

function SettingField({
  dirty,
  disabled,
  draft,
  field,
  onChange,
}: {
  dirty: boolean;
  disabled: boolean;
  draft: boolean | number | string;
  field: StandardSettingField;
  onChange: (field: StandardSettingField, value: string | boolean) => void;
}) {
  if (field.inputType === "checkbox") {
    return (
      <label className={joinClasses("hlos-setting-field hlos-setting-field-toggle", dirty && "is-dirty")}>
        <span>
          <strong>{field.label}</strong>
          <code>{field.key}</code>
        </span>
        <input
          type="checkbox"
          checked={Boolean(draft)}
          disabled={disabled}
          onChange={(event) => onChange(field, event.target.checked)}
        />
      </label>
    );
  }

  return (
    <label className={joinClasses("hlos-setting-field", dirty && "is-dirty")}>
      <span>
        <strong>{field.label}</strong>
        <code>{field.key}</code>
      </span>
      <input
        type={field.inputType}
        value={String(draft)}
        disabled={disabled}
        onChange={(event) => onChange(field, event.target.value)}
      />
    </label>
  );
}

function TokenPanel({
  draftToken,
  setDraftToken,
  saveToken,
}: {
  draftToken: string;
  setDraftToken: (value: string) => void;
  saveToken: () => void;
}) {
  return (
    <Card className="hlos-token-card">
      <p className="prolabos-eyebrow">Connect</p>
      <SectionTitle>Enter API token</SectionTitle>
      <p className="prolabos-muted mt-2">
        The dashboard talks to {new URL(API_URL).host} and stores this token in local browser storage.
      </p>
      <div className="hlos-token-form">
        <label className="prolabos-field">
          <span>API token</span>
          <input
            className="prolabos-input"
            type="password"
            value={draftToken}
            onChange={(event) => setDraftToken(event.target.value)}
            onKeyDown={(event) => {
              if (event.key === "Enter") {
                saveToken();
              }
            }}
          />
        </label>
        <Button type="button" onClick={saveToken} disabled={!draftToken.trim()}>
          <span className="inline-flex items-center gap-2">
            <KeyRound size={16} />
            Connect
          </span>
        </Button>
      </div>
    </Card>
  );
}

function SummaryCard({ label, value, tone = "neutral" }: { label: string; value: number; tone?: "neutral" | "success" | "warning" }) {
  return (
    <Card className="hlos-summary-card">
      <span className="prolabos-muted">{label}</span>
      <strong>{value}</strong>
      <StatusPill tone={tone}>{label}</StatusPill>
    </Card>
  );
}

function ServiceCard({
  service,
  disabled,
  onOpenSettings,
  onSelectCategory,
  onToggle,
}: {
  service: ReturnType<typeof deriveServices>[number];
  disabled: boolean;
  onOpenSettings: (serviceID: string) => void;
  onSelectCategory: (category: string) => void;
  onToggle: (serviceID: string, enabled: boolean) => void;
}) {
  const visibleFields = [
    ["Domain", service.domain],
    ["Subdomain", service.subdomain],
    ["Custom domain", service.customDomain],
  ].filter(([, value]) => value);

  return (
    <Card className={`hlos-service-card${service.changed ? " hlos-service-card-changed" : ""}`}>
      <div className="hlos-service-card-header">
        <div className="hlos-service-identity">
          <ServiceIcon service={service} />
          <div>
            <h2>{service.id}</h2>
            {service.changed ? <p className="hlos-service-meta">Pending deploy</p> : null}
          </div>
        </div>
        <div className="hlos-service-actions">
          <button
            className="hlos-icon-button"
            type="button"
            title={`${service.id} settings`}
            aria-label={`Open ${service.id} settings`}
            onClick={() => onOpenSettings(service.id)}
          >
            <Settings size={16} />
          </button>
          <a
            className="hlos-icon-button"
            href={service.docsUrl}
            target="_blank"
            rel="noreferrer"
            title={`${service.id} documentation`}
            aria-label={`Open ${service.id} documentation`}
          >
            <BookOpen size={16} />
          </a>
        </div>
      </div>
      {service.description ? (
        <p className="hlos-service-description" title={service.description}>
          {service.description}
        </p>
      ) : null}
      {service.category ? (
        <button
          className="hlos-category-pill"
          type="button"
          style={categoryTagStyle(service.category)}
          title={`Filter by ${formatCategory(service.category)}`}
          onClick={() => onSelectCategory(service.category || "")}
        >
          {formatCategory(service.category)}
        </button>
      ) : null}
      <label className="hlos-toggle-row">
        <span>{service.enabled ? "Enabled" : "Disabled"}</span>
        <input
          type="checkbox"
          checked={service.enabled}
          disabled={disabled}
          onChange={(event) => onToggle(service.id, event.target.checked)}
        />
      </label>
      {visibleFields.length ? (
        <dl className="hlos-service-fields">
          {visibleFields.map(([label, value]) => (
            <div key={label}>
              <dt>{label}</dt>
              <dd>{value}</dd>
            </div>
          ))}
        </dl>
      ) : null}
    </Card>
  );
}

function ServiceIcon({ service }: { service: ReturnType<typeof deriveServices>[number] }) {
  const [iconFailed, setIconFailed] = useState(false);

  return (
    <div className="hlos-service-icon" aria-hidden="true">
      {iconFailed || service.virtualItem ? (
        <span>{service.id.slice(0, 2).toUpperCase()}</span>
      ) : (
        <img src={service.iconUrl} alt="" loading="lazy" onError={() => setIconFailed(true)} />
      )}
    </div>
  );
}

function InlineError({ error }: { error: Error }) {
  return (
    <Card className="hlos-inline-error">
      <AlertTriangle size={18} />
      <span>{error.message}</span>
    </Card>
  );
}

function ErrorCard({ error, clearToken }: { error: Error; clearToken: () => void }) {
  const isAuthError = error instanceof HlosDashApiError && error.status === 401;
  return (
    <Card className="hlos-status-card">
      <Server size={18} />
      <div>
        <SectionTitle>{isAuthError ? "Authentication failed" : "Unable to load settings"}</SectionTitle>
        <p className="prolabos-muted mt-2">{error.message}</p>
        {isAuthError ? (
          <div className="mt-4">
            <Button type="button" variant="secondary" onClick={clearToken}>
              Enter a different token
            </Button>
          </div>
        ) : null}
      </div>
    </Card>
  );
}

function StatusCard({ icon, title }: { icon: React.ReactNode; title: string }) {
  return (
    <Card className="hlos-status-card">
      {icon}
      <SectionTitle>{title}</SectionTitle>
    </Card>
  );
}

function formatCategory(category: string): string {
  return category
    .split("-")
    .filter(Boolean)
    .map((part) => part[0]?.toUpperCase() + part.slice(1))
    .join(" ");
}

function categoryTagStyle(category: string): React.CSSProperties {
  const colors = categoryTagColor(category);
  return {
    backgroundColor: colors.background,
    borderColor: colors.border,
    color: colors.text,
  };
}
