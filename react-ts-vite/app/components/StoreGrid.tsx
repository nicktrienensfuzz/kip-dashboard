import { Stack, Typography } from "@mui/material";
import Box from "@mui/material/Box";
import { DataGrid, GridColDef } from "@mui/x-data-grid";

import axios from "axios";
import React, { useState, useEffect } from "react";

const columns: GridColDef[] = [
  {
    field: "title",
    headerName: "Name",
    width: 150,
    renderCell: (cellValues) => {
      console.log(cellValues);
      return (
        <Stack spacing={0}>
            <Typography fontSize={17} component="div">{cellValues.value}</Typography>
            <Typography fontSize={13} component="div">{cellValues.row.storeCode}</Typography>
        </Stack>
      );
    },
  },
  { field: "regionId", headerName: "Region", width: 150 },
  {
    field: "totalOrders",
    headerName: "All Orders",
    type: "number",
    width: 80,
    editable: false,
  },
  {
    field: "weeklyAverage",
    headerName: "Weekly Average",
    type: "number",
    width: 130,
    editable: false,
  },
  {
    field: "totalOrdersAOV",
    headerName: "AOV",
    type: "String",
    width: 70,
    editable: false,
  },
  {
    field: "2MonthOrders",
    headerName: "Last 2 months",
    type: "number",
    width: 120,
    editable: false,
  },
  {
    field: "2MonthWeeklyAverage",
    headerName: "2m Weekly Avg",
    type: "number",
    width: 150,
    editable: false,
  },
  {
    field: "2MonthOrdersAOV",
    headerName: "2m AVO",
    type: "number",
    width: 100,
    editable: false,
  },
];

export default function DataGridDemo() {
  const [chartData, setChartData] = useState([]);
  const [isLoading, setLoading] = useState(true);

  // This function will be only called once
  async function fetchData() {
    try {
      const headers = {
        Accept: "application/json",
        "Content-Type": "application/json",
      };

      const response = await axios.get(
        import.meta.env.VITE_URL + "api/locations/list",
        { headers }
      );
      let months = response.data;
      console.log(typeof months);
      console.log(response.headers["content-type"]);
      if (response.headers["content-type"] === "application/json") {
        setChartData(months);
        setLoading(false);
      }
      console.log(months);
    } catch (error) {
      console.log(`Error fetching data: ${error}`);
    }
  }

  useEffect(() => {
    fetchData();
  }, []);

  return (
    <Box sx={{ widthm: "100%", maxWidth: "980px" }}>
      <Typography variant="h5" component="div">
        Store Orders
      </Typography>
      {isLoading ? (
        <div>Loading...</div>
      ) : (
        // <Box> hi </Box>
        <DataGrid
          getRowHeight={() => "auto"}
          rows={chartData}
          columns={columns}
          hideFooterPagination={true}
          disableRowSelectionOnClick
        />
      )}
    </Box>
  );
}
