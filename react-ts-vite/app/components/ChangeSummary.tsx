import * as React from "react";
import { Stack, Typography } from "@mui/material";
import axios from "axios";
import OutlinedHistoryCard from "./OutlinedHistoryCard.js";
import { ChangeMetricResponse } from "../models/MetricData.js";
import OutlinedCard from "./OutlinedCard.js";

export default function ChangeSummary() {
  const [itemModicationData, setItemModicationData] =
    React.useState<ChangeMetricResponse>();

  const [isLoading, setLoading] = React.useState(true);

  // This function will be only called once
  async function fetchData() {
    try {
      const response = await axios.get(
        import.meta.env.VITE_URL + "api/change/itemModification.json"
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
          <Typography variant="h3" >Change Analysis</Typography>
          <Typography variant="h5" >
            {itemModicationData.change.description}
          </Typography>
          <Typography variant="h6" gutterBottom>
            {itemModicationData.change.expectations}
          </Typography>
          <Stack direction="row" spacing={2}>
            <OutlinedCard
              type="percent"
              value={itemModicationData.metrics[0].data}
              title={itemModicationData.metrics[0].displayName}
            />
            <OutlinedCard
              type="percent"
              value={itemModicationData.metrics[1].data}
              title={itemModicationData.metrics[1].displayName}
              referenceURL={itemModicationData.change.referenceURL}
            />
          </Stack>
        </Stack>
      )}
    </>
  );
}
