/* eslint no-eval: 0 */
import * as React from "react";
import { Box, Card, CardActions, CardContent, Typography } from "@mui/material";

import { MetricData } from "../models/MetricData.js";
import { useEffect, useState } from "react";
import { Line } from "react-chartjs-2";

interface OutlinedHistoryCardProps {
  object: MetricData;
}

const OutlinedHistoryCard: React.FunctionComponent<
  OutlinedHistoryCardProps
> = ({ object }) => {
  const [chartData, setChartData] = useState({});
  const [isLoading, setLoading] = useState(true);

  useEffect(() => {
    const datasets = {
      label: object.displayName,
      backgroundColor: eval("'rgb(255, 99, 132)'"),
      borderColor: eval("'rgb(255, 99, 132)'"),
      data: object.data,
      borderWidth: 2,
    };
    // console.log(datasets);
    const d = {
      labels: object.labels,
      datasets: [datasets],
    };

    // console.log(d);
    setLoading(false);
    setChartData(d);
  }, [object.data, object.displayName, object.labels]);

  const options = {
    responsive: true,
    plugins: {
      legend: {
        display: false,
        position: "top" as const,
      },
    },
  };
  var value = "";
  if (object.data) {
    value = "" + object.data[object.data.length - 1];
  } else {
    console.log(object.displayName, value);
  }

  if (object.displayName === "Sales") {
    const formatter = new Intl.NumberFormat("en-US", {
      style: "currency",
      currency: "USD",
      maximumFractionDigits: 0,
    });
    value = formatter.format(object.data[object.data.length - 1]);
  } else if (
    object.displayName === "Placed To Completion" ||
    object.displayName === "Modifier Count" ||
    object.displayName === "% of Items Modified" ||
    object.displayName === "Claimed To Completion" ||
    object.displayName === "Avg Item Count"
  ) {
    value = object.data[object.data.length - 1].toFixed(2);
  }

  return (
    <Box sx={{ minWidth: 275, maxWidth: 345 }}>
      <Card variant="outlined">
        <CardContent>
          <Typography variant="h5" color="text.secondary" gutterBottom>
            {object.displayName}
          </Typography>

          <Typography variant="h3">{value}</Typography>
          <Typography
            variant="h7"
            component="div"
            color="text.secondary"
            gutterBottom
          >
            Last Week
          </Typography>
        </CardContent>
        <CardActions>
          {isLoading ? (
            <div>Loading...</div>
          ) : (
            <Line data={chartData} options={options} />
          )}
        </CardActions>
      </Card>
    </Box>
  );
};

export default OutlinedHistoryCard;
