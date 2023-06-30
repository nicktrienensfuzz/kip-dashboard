import { Typography } from "@mui/material";
import Box from "@mui/material/Box";
import { DataGrid, GridColDef } from "@mui/x-data-grid";
import axios from "axios";
import React, { useState, useEffect } from "react";

const columns: GridColDef[] = [
  { field: "name", headerName: "Name", width: 250 },
  {
    field: "cost",
    headerName: "Cost",
    width: 90,
    editable: true,
  },
  {
    field: "modifierCount",
    headerName: "Modifiers",
    type: "number",
    width: 110,
    editable: true,
  },
  {
    field: "claimedToCompletion",
    headerName: "Claimed To Completion",
    type: "number",
    width: 170,
    editable: true,
  },
  {
    field: "placedToCompletion",
    headerName: "Placed To Completion",
    type: "number",
    width: 170,
    editable: true,
  },
];

export default function DataGridDemo() {
  const [chartData, setChartData] = useState([]);
  const [isLoading, setLoading] = useState(true);

  // This function will be only called once
  async function fetchData() {
    try {
      const response = await axios.get(
        "http://127.0.0.1:8080/itemMetrics.json"
      );
      let months = response.data;
      setChartData(months);
      setLoading(false);
    } catch (error) {
      alert(`Error fetching data: ${error}`);
    }
  }

  useEffect(() => {
    fetchData();
  }, []);

  return (
    <Box sx={{ width: "100%" }}>
      <Typography variant="h5" component="div" >Item Metrics</Typography>
      {isLoading ? (
        <div>Loading...</div>
      ) : (
        <DataGrid
          rows={chartData}
          columns={columns}
          // initialState={{
          //   pagination: {
          //     paginationModel: {
          //       pageSize: 45,
          //     },
          //   },
          // }}
          // pageSizeOptions={[5]}
          // checkboxSelection
          disableRowSelectionOnClick
        />
      )}
    </Box>
  );
}
