import { Typography } from "@mui/material";
import Box from "@mui/material/Box";
import { DataGrid, GridColDef } from "@mui/x-data-grid";

import axios from "axios";
import React, { useState, useEffect } from "react";

const columns: GridColDef[] = [
  { field: "name", headerName: "Name", width: 330 },
  {
    field: "cost",
    headerName: "Cost",
    width: 110,
    editable: false,
  },
  {
    field: "modifierCount",
    headerName: "Modifiers",
    type: "number",
    width: 110,
    editable: false,
  },
  {
    field: "isHot",
    headerName: "Heated?",
    type: "bool",
    width: 90,
    editable: false,
  },
  {
    field: "claimedToCompletion",
    headerName: "Claimed To Completion",
    type: "number",
    width: 170,
    editable: false,
  },
  {
    field: "placedToCompletion",
    headerName: "Placed To Completion",
    type: "number",
    width: 170,
    editable: false,
  },
];

export default function DataGridDemo() {
  const [chartData, setChartData] = useState([]);
  const [isLoading, setLoading] = useState(true);

  // This function will be only called once
  async function fetchData() {
    try {
      const response = await axios.get(
        import.meta.env.VITE_URL + "api/itemMetrics.json"
      );
      let months = response.data;
      console.log(months);
      setChartData(months);
      setLoading(false);
    } catch (error) {
      console.log(`Error fetching data: ${error}`);
    }
  }

  useEffect(() => {
    fetchData();
  }, []);

  return (
    <Box sx={{ width: "100%" }}>
      <Typography variant="h5" component="div">
        Item Metrics (averaged) 12 weeks
      </Typography>
      {isLoading ? (
        <div>Loading...</div>
      ) : (
        // <Box> hi </Box>
        <DataGrid
          rows={chartData}
          columns={columns}
          hideFooterPagination={true}
          disableRowSelectionOnClick
        />
      )}
    </Box>
  );
}
