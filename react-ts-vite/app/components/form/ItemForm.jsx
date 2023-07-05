import React, { useState } from "react";
import Button from "@mui/material/Button";
import TextField from "@mui/material/TextField";
import Box from "@mui/material/Box";
import axios from "axios";
import ItemList from "./ItemList"; // Assuming that ItemList is in the same directory

const ItemForm = () => {
  const [title, setTitle] = useState("");
  const [description, setDescription] = useState("");
  const [userStories, setUserStories] = useState([]);
  const [acceptanceCriteria, setAcceptanceCriteria] = useState([]);
  const [metrics, setMetrics] = useState([]);

  const handleSubmit = () => {
    const data = {
      title,
      description,
      userStories,
      acceptanceCriteria,
      metrics,
    };
    console.log(data);

    axios
      .post("/api/submit", data) // Change '/api/submit' to your actual API endpoint
      .then((response) => {
        console.log(response);
      })
      .catch((error) => {
        console.log(error);
      });
  };

  return (
    <Box sx={{ padding: "20px" }}>
      <TextField
        label="Title"
        value={title}
        onChange={(e) => setTitle(e.target.value)}
        variant="outlined"
        fullWidth
        sx={{ marginBottom: "20px" }}
      />
      <br />
      <TextField
        label="Description"
        value={description}
        onChange={(e) => setDescription(e.target.value)}
        multiline
        rows={4}
        variant="outlined"
        fullWidth
        sx={{ marginBottom: "20px" }}
      />
      <br />
      <ItemList
        label="User Stories"
        list={userStories}
        setList={setUserStories}
        sx={{ marginBottom: "20px" }}
      />
      <br />
      <ItemList
        label="Acceptance Criteria"
        list={acceptanceCriteria}
        setList={setAcceptanceCriteria}
        sx={{ marginBottom: "20px" }}
      />
      <br />
      <ItemList
        label="Metrics"
        list={metrics}
        setList={setMetrics}
        sx={{ marginBottom: "20px" }}
      />
      <br />
      <Button variant="contained" color="primary" onClick={handleSubmit}>
        Submit
      </Button>
    </Box>
  );
};

export default ItemForm;
