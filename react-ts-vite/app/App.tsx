import React, { useState } from "react";
import styled from "styled-components";
import { usePrimaryStore } from "./store";
import { selectCount, selectIncrementBy } from "./store/selectors";

import Card from "./components/Card";
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
  const [plainCount, setPlainCount] = useState(0);
  const incrementBy = usePrimaryStore(selectIncrementBy);
  const count = usePrimaryStore(selectCount);
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
        <Box component="main" sx={{ p: 3 }}>
          <Stack spacing={2} sx={{ margin: 3 }}>
            <StoreOrdersLineGraph name="Store Orders by Week" />
            <StoreOrdersBarGraph
              title="Store Orders per Week past 3 weeks"
              dataUrl="http://127.0.0.1:8080/locations.json"
            />
            <StoreOrdersBarGraph
              title="Store Orders per Week past 3 weeks"
              dataUrl="http://127.0.0.1:8080/locations2.json"
            />
            <Stack direction="row" spacing={2} sx={{ margin: 3 }}>
              <Card />
              <Card />
            </Stack>
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
