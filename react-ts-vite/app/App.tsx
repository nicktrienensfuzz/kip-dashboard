import React, { useState } from "react";
import styled from "styled-components";

import StoreOrdersLineGraph from "./components/StoreOrdersLineGraph";
import {
  Box,
  Typography,
  Stack,
  AppBar,
  Toolbar,
  IconButton,
  Menu,
  MenuItem,
  Button,
} from "@mui/material";

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
import { AccountCircle, DownloadOutlined } from "@mui/icons-material";
import DataGridDemo from "./components/DataGridDemo";
import StoreGrid from "./components/StoreGrid";

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
  const [anchorEl, setAnchorEl] = React.useState<null | HTMLElement>(null);

  const storeToken = (token: string) => {
    try {
      localStorage.setItem("myToken", token);
      console.log("Token saved to local storage.");
    } catch (error) {
      console.log("Failed to save the token to local storage.", error);
    }
  };

  const checkToken = (): string | undefined => {
    try {
      const token = localStorage.getItem("myToken");
      if (token) {
        console.log("Token found: ", token);
        return token;
      } else {
        console.log("Token not found.");
        return undefined;
      }
    } catch (error) {
      console.log("Failed to retrieve the token.", error);
      return undefined;
    }
  };

  const handleMenu = (event: React.MouseEvent<HTMLElement>) => {
    setAnchorEl(event.currentTarget);
  };

  const handleSignOut = (event: React.ChangeEvent<HTMLInputElement>) => {
    setJwt("");
    localStorage.removeItem("myToken");
    axios.defaults.headers.common["Authorization"] = null;
    window.open = import.meta.env.VITE_URL;
  };

  const handleClose = () => {
    setAnchorEl(null);
  };

  React.useEffect(() => {
    const params = new URLSearchParams(window.location.search);
    const jwtValue = params.get("token");
    if (jwtValue) {
      axios.defaults.headers.common["Authorization"] = "Bearer " + jwtValue;
      setJwt(jwtValue);
      storeToken(jwtValue);
    } else {
      let token = checkToken();
      if (token) {
        console.log("Token retrieved: ", token);
        axios.defaults.headers.common["Authorization"] = "Bearer " + token;
        setJwt(token);
      }
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
    console.log("Token effect: ", jwt);

    if (jwt !== null) {
      touchServer();
    }
  }, [jwt]);

  const router = createBrowserRouter(
    createRoutesFromElements(
      <Route>
        <Route path="/index.html" index element={<StoreOrdersLineGraph />} />
        <Route path="/prd" element={<ItemForm />} />
      </Route>
    )
  );
  // https://lzvt632jzi.execute-api.us-west-2.amazonaws.com/api/itemMetrics.json
  const params = new URLSearchParams(window.location.search);
  const jwtValue = params.get("token");
  let url = "";
  if (jwtValue) {
    url = import.meta.env.VITE_URL + "api/download?url=" + window.location;
  } else {
    url =
      import.meta.env.VITE_URL +
      "api/download?url=https://zendat.s3.us-west-2.amazonaws.com/index.html?token=" +
      jwt;
  }

  var today = new Date();
  const date =
    today.getFullYear() + "-" + (today.getMonth() + 1) + "-" + today.getDate();

  return (
    <>
      <AppBar component="nav" position="sticky">
        <Toolbar>
          <Typography variant="h4" component="div">
            MTO Dashboard
          </Typography>
          {jwt && (
            <>
              <Typography
                variant="h4"
                component="div"
                sx={{ flexGrow: 1, marginLeft: "20px" }}
              >
                {date}
              </Typography>
              <IconButton aria-controls="menu-appbar" component="label">
                <a href={url} download>
                  <DownloadOutlined htmlColor="#ffffff" />
                </a>
              </IconButton>

              <IconButton
                size="large"
                aria-label="account of current user"
                aria-controls="menu-appbar"
                aria-haspopup="true"
                onClick={handleMenu}
                color="inherit"
              >
                <AccountCircle />
              </IconButton>
              <Menu
                id="menu-appbar"
                anchorEl={anchorEl}
                anchorOrigin={{
                  vertical: "top",
                  horizontal: "right",
                }}
                keepMounted
                transformOrigin={{
                  vertical: "top",
                  horizontal: "right",
                }}
                open={Boolean(anchorEl)}
                onClose={handleClose}
              >
                <MenuItem onClick={handleSignOut}>Sign Out</MenuItem>
              </Menu>
            </>
          )}
        </Toolbar>
      </AppBar>
      {/* <RouterProvider router={router} /> */}
      {/* <ItemForm /> */}

      {jwt === null || isLoading ? (
        <EmailForm />
      ) : (
        <Container>
          <Box component="main" sx={{ p: 2, maxWidth: "1050px" }}>
            <Stack spacing={6} sx={{ margin: 2 }}>
              <OrderSummary />
              <StoreOrdersLineGraph title="Store Orders by Week" />
              {/* <StoreOrdersBarGraph
                title="Store Orders per Week past 4 weeks"
                dataUrl={import.meta.env.VITE_URL + "api/locations2.json"}
              /> */}
              <StoreGrid />
              <DataGridDemo />
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
