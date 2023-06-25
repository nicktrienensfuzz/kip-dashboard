import React from "react";
import { createRoot } from "react-dom/client";
import App from "./App";

export const init = () => {
  const targetElement = document.getElementById("render-target");
  const root = createRoot(targetElement as Element);
  root.render(<App />);
};
