const { defineConfig } = require("cypress");

module.exports = defineConfig({
  defaultCommandTimeout: 10000,
  e2e: {
    baseUrl: "http://localhost:9000",
    supportFile: "cypress/support/e2e.ts",
  },
});
