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
    <Box sx={{ minWidth: 275, maxWidth: 345 }}>
      <Card variant="outlined">
        <CardContent>
          <Typography variant="h4" color="text.secondary" gutterBottom>
            {title}
          </Typography>
          <Typography variant="h5" component="div"></Typography>
          <Typography variant="h3" color="text.secondary" gutterBottom>
            {value}
          </Typography>
        </CardContent>
        <CardActions>
          <Button size="small">Learn More</Button>
        </CardActions>
      </Card>
    </Box>
  );
};

export default OutlinedCard;
