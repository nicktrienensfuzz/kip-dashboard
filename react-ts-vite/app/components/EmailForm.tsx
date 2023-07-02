import React, { useState } from "react";
import axios from "axios";
import { TextField, Button, Typography } from "@mui/material";
import styled from "styled-components";

function EmailForm() {
  const [email, setEmail] = useState("nick.trienens@monstar-lab.com");

  const handleEmailChange = (event) => {
    setEmail(event.target.value);
  };

  const handleSubmit = (event) => {
    event.preventDefault();

    const data = { email, host: import.meta.env.VITE_SITE_URL };

    axios
      .post(import.meta.env.VITE_URL + "createSession", data)
      .then((response) => {
        console.log("Success:", response.data);
        setEmail(""); // Clear the form field after successful submission
      })
      .catch((error) => {
        console.error("Error:", error);
      });
  };

  return (
    <Container>
      <form onSubmit={handleSubmit}>
        <Typography variant="h2" sx={{ margin: 2 }}>
          Login
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
    </Container>
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
