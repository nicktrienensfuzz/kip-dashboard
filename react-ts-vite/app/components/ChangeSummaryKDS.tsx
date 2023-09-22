import * as React from "react";
import { Stack, Typography } from "@mui/material";
import axios from "axios";
import { ChangeMetricResponse } from "../models/MetricData.js";
import OutlinedChangeCard from "./OutlinedChangeCard.js";

export default function ChangeSummaryKDS() {
  const [itemModicationData, setItemModicationData] =
    React.useState<ChangeMetricResponse>();

  const [isLoading, setLoading] = React.useState(true);

  // This function will be only called once
  async function fetchData() {
    try {
      const response = await axios.get(
        import.meta.env.VITE_URL + "api/change/makeInstructions.json"
      );
      console.log(response.data);
      setItemModicationData(response.data);
      // setChartData(response.data.list);
      setLoading(false);
    } catch (error) {
      console.log(`Error fetching data: ${error}`);
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
        <Stack sx={{ marginTop: 3 }}>
          <Typography variant="h4">
            {itemModicationData.change.description}
          </Typography>
          <Typography variant="h6" gutterBottom>
            {itemModicationData.change.expectations}
          </Typography>
          <Stack direction="row" spacing={2}>
            <OutlinedChangeCard value={itemModicationData.metrics[0]} />
            <OutlinedChangeCard value={itemModicationData.metrics[1]} />
            <OutlinedChangeCard value={itemModicationData.metrics[2]} />
          </Stack>
        </Stack>
      )}
    </>
  );
}
