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
    axios.defaults.headers.common["Authorization"] = "Bearer " + jwtValue;
    setJwt(jwtValue);
  }, []);

  async function touchServer() {
    // console.log("send JWT");
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

  React.useEffect(() => {
    if (jwt !== null) {
      touchServer();
    }
  }, [jwt]);

  return (
    <>
      <AppBar component="nav" position="sticky">
        <Toolbar>
          <Typography variant="h4" component="div">
            Dashboard
          </Typography>
        </Toolbar>
      </AppBar>

      {jwt === null || isLoading ? (
        <EmailForm />
      ) : (
        <Container>
          <Box component="main" sx={{ p: 3, maxWidth: "990px" }}>
            <Stack spacing={6} sx={{ margin: 3 }}>
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
