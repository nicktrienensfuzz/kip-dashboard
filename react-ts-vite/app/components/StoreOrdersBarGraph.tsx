/* eslint no-eval: 0 */
import axios from "axios";
import React, { useState, useEffect } from "react";
import { Bar } from "react-chartjs-2";
import { Typography } from "@mui/material";

interface StoreOrdersBarGraphProps {
  title: string;
  dataUrl: string;
}

const StoreOrdersBarGraph: React.FunctionComponent<
  StoreOrdersBarGraphProps
> = ({ title, dataUrl }) => {
  const [chartData, setChartData] = useState({});
  const [isLoading, setLoading] = useState(true);

  // This function will be only called once
  async function fetchData() {
    try {
      const response = await axios.get(dataUrl);
      let months = response.data.labels;

      const datasets = response.data.stores.map((store) => {
        return {
          label: store.name,
          backgroundColor: eval(store.backgroundColor),
          borderColor: eval(store.borderColor),
          data: store.data.map(Number),
          borderWidth: 2,
        };
      });

      // console.log(response.data);
      // console.log(dataset);

      setChartData({
        labels: months,
        datasets: datasets,
      });

      setLoading(false);
    } catch (error) {
      alert(`Error fetching data: ${error}`);
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
        {title}
      </Typography>
      {isLoading ? (
        <div>Loading...</div>
      ) : (
        <Bar data={chartData} options={options} />
      )}
    </div>
  );
};

export default StoreOrdersBarGraph;
