/// <reference types="vite/client" />

interface ImportMetaEnv {
  readonly HLOS_DASH_API_URL?: string;
}

interface ImportMeta {
  readonly env: ImportMetaEnv;
}
