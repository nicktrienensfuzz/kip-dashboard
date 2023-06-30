import * as React from "react";
import { Stack } from "@mui/material";
import axios from "axios";
import OutlinedCard from "./OutlinedCard.tsx";
import OutlinedHistoryCard from "./OutlinedHistoryCard.js";
import { DataPoint, MetricData } from "../models/MetricData.js";

export default function OrderSummary() {
  const [chartData, setChartData] = React.useState(Array<DataPoint>);
  const [metricData, setMetricData] = React.useState(Array<MetricData>);
  const [isLoading, setLoading] = React.useState(true);

  // This function will be only called once
  async function fetchData() {
    try {
      const response = await axios.get(
        "http://127.0.0.1:8080/orderSalesTrend.json"
      );
      let months = response.data.list;

      setMetricData(response.data.grouped);
      setChartData(months);
      setLoading(false);
    } catch (error) {
      alert(`Error fetching data: ${error}`);
    }
  }

  React.useEffect(() => {
    fetchData();
  }, []);

  return (
    <>
      {isLoading ? (
        <div>Loading...</div>
      ) : (
        <Stack>
          <Stack direction="row" spacing={2} sx={{ margin: 3 }}>
            <OutlinedCard title="Sales" value={chartData[3].sales} />
            <OutlinedCard title="Orders" value={chartData[3].orderCount} />
            <OutlinedCard title="Items Made" value={chartData[3].itemCount} />
          </Stack>
          <Stack direction="row" spacing={2} sx={{ margin: 3 }}>
            <OutlinedHistoryCard object={metricData[0]} />
            <OutlinedHistoryCard object={metricData[1]} />
            <OutlinedHistoryCard object={metricData[2]} />
          </Stack>
        </Stack>
      )}
    </>
  );
}
