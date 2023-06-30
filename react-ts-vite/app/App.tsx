import React from "react";
import styled from "styled-components";

import DataGridDemo from "./components/DataGridDemo";
import StoreOrdersBarGraph from "./components/StoreOrdersBarGraph";
import StoreOrdersLineGraph from "./components/StoreOrdersLineGraph";
import { Box, Typography, Stack, AppBar, Toolbar } from "@mui/material";

import {
  Chart as ChartJS,
  CategoryScale,
  LinearScale,
  PointElement,
  LineElement,
  BarElement,
  Title,
  Tooltip,
  Legend,
} from "chart.js";
import OrderSummary from "./components/OrderSummary";

ChartJS.register(
  CategoryScale,
  LinearScale,
  PointElement,
  LineElement,
  BarElement,
  Title,
  Tooltip,
  Legend
);

export default function App() {
  return (
    <>
      <AppBar component="nav" position="sticky">
        <Toolbar>
          <Typography variant="h4" component="div">
            Dashboard
          </Typography>
        </Toolbar>
      </AppBar>

      <Container>
        <Box component="main" sx={{ p: 3, maxWidth: "990px" }}>
          <Stack spacing={6} sx={{ margin: 3 }}>
            <OrderSummary />
            <StoreOrdersLineGraph title="Store Orders by Week" />

            <StoreOrdersBarGraph
              title="Store Orders per Week past 3 weeks"
              dataUrl="http://127.0.0.1:8080/locations2.json"
            />
            <DataGridDemo />
          </Stack>
        </Box>
      </Container>
    </>
  );
}

const Container = styled.div`
  font-family: "Roboto", sans-serif;
  background: #fafafa;
  color: #333333;
  padding: 18px 0;

  > b {
    font-weight: 600;
  }
`;
