/* eslint no-eval: 0 */
import axios from "axios";
import React, { useState, useEffect } from "react";
import { Line } from "react-chartjs-2";
import { Typography } from "@mui/material";

interface StoreOrdersLineGraphProps {
  title: string;
}

const StoreOrdersLineGraph: React.FunctionComponent<
  StoreOrdersLineGraphProps
> = ({ name }) => {
  const [chartData, setChartData] = useState({});
  const [isLoading, setLoading] = useState(true);

  // This function will be only called once
  async function fetchData() {
    try {
      const response = await axios.get(
        "http://127.0.0.1:8080/allLocationsOrdersByDay.json"
      );
      let months = response.data.labels;
      let dataset = response.data.stores[0].data;

      const datasets = response.data.stores.map((store) => {
        return {
          label: store.name,
          backgroundColor: eval(store.backgroundColor),
          borderColor: eval(store.borderColor),
          data: store.data.map(Number),
          borderWidth: 2,
        };
      });
      setChartData({
        labels: months,
        datasets: datasets,
      });

      setLoading(false);
    } catch (error) {
      console.error(`Error fetching data: ${error}`);
    }
  }

  const options = {
    responsive: true,
    plugins: {
      legend: {
        position: "top" as const,
      },
    },
  };

  useEffect(() => {
    fetchData();
  }, []);

  return (
    <div>
      <Typography variant="h5" component="div">
        {name}
      </Typography>
      {isLoading ? (
        <div>Loading...</div>
      ) : (
        //<Box sx={{ minWidth: 500, maxWidth: 800, margin: 5 }}>
        <Line data={chartData} options={options} />
        //</Box>
      )}
    </div>
  );
};

export default StoreOrdersLineGraph;
