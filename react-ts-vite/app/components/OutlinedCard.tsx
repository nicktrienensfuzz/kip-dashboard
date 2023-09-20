import * as React from "react";
import {
  Box,
  Card,
  CardActions,
  CardContent,
  Typography,
  Button,
} from "@mui/material";

interface OutlinedCardProps {
  title: string;
  value: string;
  type: string;
  referenceURL: string|null;
}

const OutlinedCard: React.FunctionComponent<OutlinedCardProps> = ({
  title,
  value,
  type,
  referenceURL
}) => {
  return (
    <Box sx={{ minWidth: 210, maxWidth: 305, minHeight: 280, height: "200px" }}>
      <Card variant="outlined">
        <CardContent>
          <Typography variant="h5" color="text.secondary" gutterBottom>
            {title}
          </Typography>
          {type === "percent" ? (
            <Typography variant="h4" color="text.secondary" gutterBottom>
              {value.toFixed(2)}%
            </Typography>
          ) : (
            <Typography variant="h4" color="text.secondary" gutterBottom>
              {value}
            </Typography>
          )}
        </CardContent>
        {referenceURL ? (
          <CardActions>
            <Button size="small" ><a href={referenceURL} target="_blank" >View</a></Button>
          </CardActions>
        ) : (
          <></>
        )}
      </Card>
    </Box>
  );
};

export default OutlinedCard;
