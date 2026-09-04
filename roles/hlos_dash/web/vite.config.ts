import tailwindcss from "@tailwindcss/vite";
import react from "@vitejs/plugin-react";
import { defineConfig, loadEnv } from "vite";

export default defineConfig(({ mode }) => {
  const env = loadEnv(mode, process.cwd(), "");
  const hlosDashApiUrl =
    env.HLOS_DASH_API_URL?.trim() || (mode === "development" ? "http://127.0.0.1:8081" : "");

  return {
    define: {
      "import.meta.env.HLOS_DASH_API_URL": JSON.stringify(hlosDashApiUrl),
    },
    plugins: [react(), tailwindcss()],
  };
});
