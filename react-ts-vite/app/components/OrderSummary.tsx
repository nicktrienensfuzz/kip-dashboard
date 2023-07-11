import * as React from "react";
import { Stack, Typography } from "@mui/material";
import axios from "axios";
import OutlinedHistoryCard from "./OutlinedHistoryCard.js";
import { MetricData } from "../models/MetricData.js";

export default function OrderSummary() {
  const [metricData, setMetricData] = React.useState(Array<MetricData>);
  const [itemData, setItemData] = React.useState(Array<MetricData>);
  const [itemModicationData, setItemModicationData] =
    React.useState<MetricData>();

  const [isLoading, setLoading] = React.useState(true);

  // This function will be only called once
  async function fetchData() {
    try {
      const response = await axios.get(
        import.meta.env.VITE_URL + "api/orderSalesTrend.json"
      );
      setMetricData(response.data.grouped);

      const responseItems = await axios.get(
        import.meta.env.VITE_URL + "api/itemSalesTrend.json"
      );
      setItemData(responseItems.data.grouped);

      const responseItemMod = await axios.get(
        import.meta.env.VITE_URL + "api/itemModification.json"
      );
      console.log(responseItemMod.data);
      setItemModicationData(responseItemMod.data);

      // setChartData(response.data.list);
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
          <Typography variant="h4" gutterBottom>
            Orders Overview By Weeks
          </Typography>
          <Stack direction="row" spacing={2}>
            <OutlinedHistoryCard object={metricData[0]} />
            <OutlinedHistoryCard object={metricData[2]} />
            <OutlinedHistoryCard object={metricData[4]} />
          </Stack>
          <br />
          <br />
          <br />
          <Stack direction="row" spacing={2}>
            <OutlinedHistoryCard object={metricData[5]} />
            <OutlinedHistoryCard object={metricData[3]} />
            <OutlinedHistoryCard object={metricData[1]} />
          </Stack>
          <br />
          <br />
          <br />
          <Typography variant="h5" gutterBottom>
            Items Overview By Weeks
          </Typography>
          <Stack direction="row" spacing={2}>
            {/* <OutlinedHistoryCard object={itemData[0]} /> */}
            <OutlinedHistoryCard object={itemData[2]} />
            <OutlinedHistoryCard object={itemData[1]} />
            <OutlinedHistoryCard object={itemModicationData} />
          </Stack>
        </Stack>
      )}
    </>
  );
}
