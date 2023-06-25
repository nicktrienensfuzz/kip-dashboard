import { defineConfig } from "vite";
import eslint from "vite-plugin-eslint";
import react from "@vitejs/plugin-react";

export default defineConfig({
  base: "/",
  root: "./",
  server: {
    port: 9000,
  },
  test: {
    watch: false,
  },
  plugins: [
    react(),
    // this tells eslint that it should throw an error for related issues on build
    {
      ...eslint(),
      apply: "build",
    },
    {
      // this tells eslint to not fail during local development, but highlights issues
      ...eslint({
        failOnWarning: false,
        failOnError: false,
      }),
      apply: "serve",
      enforce: "post",
    },
  ],
});
