import React, { useState } from "react";
import axios from "axios";
import {
  TextField,
  Button,
  Typography,
  Box,
  CircularProgress,
} from "@mui/material";
import styled from "styled-components";

function EmailForm() {
  const [email, setEmail] = useState("");
  const [isComplete, setComplete] = useState(false);
  const [isLoading, setLoading] = React.useState(false);
  const [didError, setDidError] = React.useState("");

  const handleEmailChange = (event) => {
    setEmail(event.target.value);
  };

  const handleSubmit = (event) => {
    event.preventDefault();
    setLoading(true);
    const data = { email, host: import.meta.env.VITE_SITE_URL };

    axios
      .post(import.meta.env.VITE_URL + "createSession", data)
      .then((response) => {
        console.log("Success:", response.data);
        setEmail(""); // Clear the form field after successful submission
        setLoading(false);
        setComplete(true);
      })
      .catch((error) => {
        console.error("Error:", error);
        setLoading(false);
        setDidError("fail");
      });
  };

  // Loading state view
  if (isLoading) {
    return (
      <Box
        display="flex"
        justifyContent="center"
        alignItems="center"
        minHeight="100vh"
      >
        <CircularProgress />
      </Box>
    );
  }
  if (didError.length > 3) {
    return (
      <Box
        display="flex"
        justifyContent="center"
        alignItems="center"
        minHeight="100vh"
      >
        <Typography variant="h2" sx={{ margin: 2 }}>
          Email Failed to Send!
        </Typography>
        <Typography variant="h4" sx={{ margin: 2 }}>
          {didError}
        </Typography>
      </Box>
    );
  }

  // Complete state view
  if (isComplete) {
    return (
      <Box
        display="flex"
        justifyContent="center"
        alignItems="center"
        minHeight="100vh"
      >
        <Typography variant="h3" sx={{ margin: 2 }}>
          Email sent!
        </Typography>
        <Typography variant="h5" sx={{ margin: 2 }}>
          You may close this window
        </Typography>
      </Box>
    );
  }

  return (
    <Box
      display="flex"
      flexDirection="column"
      justifyContent="center"
      alignItems="center"
      minHeight="100vh"
      textAlign="center"
      padding={2}
    >
      <form onSubmit={handleSubmit}>
        <Typography variant="h2" sx={{ margin: 2 }}>
          Login
        </Typography>
        <Typography variant="h5" sx={{ margin: 2 }}>
          An authenticated link will be sent to this address
        </Typography>
        <TextField
          label="Email"
          type="email"
          value={email}
          onChange={handleEmailChange}
          required
          sx={{ width: "500px", margin: 2 }}
        />
        <br />
        <Button
          variant="contained"
          color="primary"
          type="submit"
          sx={{ width: "500px", margin: 2 }}
        >
          Submit
        </Button>
      </form>
    </Box>
  );
}

export default EmailForm;

const Container = styled.div`
  font-family: "Roboto", sans-serif;
  background: #fafafa;
  color: #333333;
  padding: 18px 0;
  align: center;

  > b {
    font-weight: 600;
  }
`;
