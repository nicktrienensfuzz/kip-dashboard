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
}

const OutlinedCard: React.FunctionComponent<OutlinedCardProps> = ({
  title,
  value,
}) => {
  return (
    <Box sx={{ minWidth: 210, maxWidth: 305, minHeight: 280, height: "200px" }}>
      <Card variant="outlined">
        <CardContent>
          <Typography variant="h5" color="text.secondary" gutterBottom>
            {title}
          </Typography>
          <Typography variant="h4" color="text.secondary" gutterBottom>
            {value}
          </Typography>
        </CardContent>
        <CardActions>
          <Button size="small">Explore</Button>
        </CardActions>
      </Card>
    </Box>
  );
};

export default OutlinedCard;
