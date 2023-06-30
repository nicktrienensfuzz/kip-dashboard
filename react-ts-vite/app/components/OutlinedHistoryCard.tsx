import * as React from "react";
import { Box, Card, CardActions, CardContent, Typography } from "@mui/material";

import { MetricData } from "../models/MetricData.js";
import { useEffect, useState } from "react";
import { Bar } from "react-chartjs-2";

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
      // backgroundColor: rgb(70, 200, 220),
      // borderColor: rgb(70, 200, 220),
      data: object.data,
      borderWidth: 2,
    };
    // console.log(datasets);
    const d = {
      labels: object.labels,
      dataSets: [datasets],
    };

    console.log(d);
    // setLoading(false);
    setChartData(d);
  }, []);

  const options = {
    responsive: true,
    plugins: {
      legend: {
        position: "top" as const,
      },
    },
  };

  return (
    <Box sx={{ minWidth: 275, maxWidth: 345 }}>
      <Card variant="outlined">
        <CardContent>
          <Typography variant="h4" color="text.secondary" gutterBottom>
            {object.displayName}
          </Typography>
          <Typography variant="h5" component="div"></Typography>
          <Typography variant="h3" color="text.secondary" gutterBottom>
            {object.data[0]}
          </Typography>
        </CardContent>
        <CardActions>
          {isLoading ? (
            <div>Loading...</div>
          ) : (
            <Bar data={chartData} options={options} />
          )}
        </CardActions>
      </Card>
    </Box>
  );
};

export default OutlinedHistoryCard;
