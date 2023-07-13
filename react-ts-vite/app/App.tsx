import React, { useState } from "react";
import styled from "styled-components";

// import DataGridDemo from "./components/DataGridDemo";
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
import EmailForm from "./components/EmailForm";
import axios from "axios";
import ItemForm from "./components/form/ItemForm";
import {
  Route,
  createBrowserRouter,
  createRoutesFromElements,
  RouterProvider,
} from "react-router-dom";

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
  const [jwt, setJwt] = useState(null);
  const [isLoading, setLoading] = React.useState(true);

  React.useEffect(() => {
    const params = new URLSearchParams(window.location.search);
    const jwtValue = params.get("token");
    if (jwtValue) {
      axios.defaults.headers.common["Authorization"] = "Bearer " + jwtValue;
      setJwt(jwtValue);
    }
  }, []);

  React.useEffect(() => {
    async function touchServer() {
      console.log("send JWT");
      try {
        const response = await axios.get(
          import.meta.env.VITE_URL + "auth/" + jwt
        );
        console.log("sent JWT");
        // setChartData(response.data.list);
        setLoading(false);
      } catch (error) {
        // console.log(error);
        alert(`Error fetching data: ${error}`);
      }
    }

    if (jwt !== null) {
      touchServer();
    }
  }, [jwt]);

  const router = createBrowserRouter(
    createRoutesFromElements(
      <Route path="/" element={<ItemForm />}>
        <Route path="/graph" index element={<StoreOrdersLineGraph />} />
        <Route path="/prd" index element={<ItemForm />} />
      </Route>
    )
  );

  return (
    <>
      <AppBar component="nav" position="sticky">
        <Toolbar>
          <Typography variant="h4" component="div">
            MTO Dashboard
          </Typography>
        </Toolbar>
      </AppBar>
      {/* <RouterProvider router={router} /> */}

      {jwt === null || isLoading ? (
        <EmailForm />
      ) : (
        <Container>
          <Box component="main" sx={{ p: 2, maxWidth: "1050px" }}>
            <Stack spacing={6} sx={{ margin: 2 }}>
              <OrderSummary />
              <StoreOrdersLineGraph title="Store Orders by Week" />

              <StoreOrdersBarGraph
                title="Store Orders per Week past 4 weeks"
                dataUrl={import.meta.env.VITE_URL + "api/locations2.json"}
              />
              {/* <DataGridDemo /> */}
            </Stack>
          </Box>
        </Container>
      )}
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
