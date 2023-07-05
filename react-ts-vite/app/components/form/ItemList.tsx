import React, { useState } from "react";
import TextField from "@mui/material/TextField";
import Button from "@mui/material/Button";
import List from "@mui/material/List";
import ListItem from "@mui/material/ListItem";
import ListItemText from "@mui/material/ListItemText";
import IconButton from "@mui/material/IconButton";
import DeleteIcon from "@mui/icons-material/Delete";
import AddIcon from "@mui/icons-material/Add";
import {
  Box,
  FormControl,
  Input,
  InputAdornment,
  InputLabel,
  Typography,
} from "@mui/material";

const ItemList = ({ label, list, setList }) => {
  const [item, setItem] = useState("");

  const handleInputChange = (e) => {
    setItem(e.target.value);
  };

  const handleAddClick = (e) => {
    e.preventDefault(); // Prevent form from actually submitting
    if (item.trim() !== "") {
      // Prevent adding empty items
      setList((prevItems) => [...prevItems, item]);
      setItem("");
    }
  };
  const handleRemoveClick = (index) => {
    setList((prevItems) => {
      const newItems = [...prevItems];
      newItems.splice(index, 1);
      return newItems;
    });
  };

  return (
    <div>
      <Typography variant="h5">{label}</Typography>
      <Box>
        <FormControl variant="outlined" sx={{ width: "500px" }}>
          <InputLabel htmlFor="input-with-icon-adornment"> </InputLabel>
          <Input
            value={item}
            size="small"
            onChange={handleInputChange}
            id="input-with-icon-adornment"
            startAdornment={
              <InputAdornment position="start">
                <AddIcon />
              </InputAdornment>
            }
          />
        </FormControl>

        <Button
          variant="contained"
          color="primary"
          size="small"
          onClick={handleAddClick}
          sx={{ marginTop: "12px", marginLeft: "10px" }}
        >
          Add
        </Button>
      </Box>
      <List>
        {list.map((item, index) => (
          <ListItem key={index} sx={{ width: "500px" }}>
            <IconButton
              edge="start"
              aria-label="delete"
              onClick={() => handleRemoveClick(index)}
            >
              <DeleteIcon />
            </IconButton>
            <ListItemText primary={`${index + 1}. ${item}`} />
          </ListItem>
        ))}
      </List>
    </div>
  );
};

export default ItemList;
