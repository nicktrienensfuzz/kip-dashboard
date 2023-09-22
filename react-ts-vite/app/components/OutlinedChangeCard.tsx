import * as React from "react";
import {
  Box,
  Card,
  CardActions,
  CardContent,
  Typography,
  Button,
  Stack,
  Divider,
} from "@mui/material";
import { TrackedChangeMetric } from "../models/MetricData.js";

interface OutlinedChangeCardProps {
  value: TrackedChangeMetric;
}

const OutlinedChangeCard: React.FunctionComponent<OutlinedChangeCardProps> = ({
  value,
}) => {
  const buildValue = (value: any, unit: String) => {
    if (unit == "%") {
      return (
        <Typography variant="h4" color="text.primary">
          {value.toFixed(2)}%
        </Typography>
      );
    } else if (unit == "Seconds") {
      return (
        <Stack>
          <Typography variant="h4" color="text.primary">
            {value.toFixed(2)}
          </Typography>
          <Typography fontSize={13} color="text.secondary">
            Seconds
          </Typography>
        </Stack>
      );
    } else {
      return (
        <Typography variant="h4" color="text.primary">
          {value}
        </Typography>
      );
    }
  };

  return (
    <Box sx={{ minWidth: 210, maxWidth: 305 }}>
      <Card variant="outlined" sx={{ minHeight: 180, height: "200px"}}>
        <CardContent>
          <Typography variant="h5" color="text.primary" gutterBottom>
            {value.displayName}
          </Typography>

          <Stack direction="row">
            <Stack>
              {buildValue(value.dataBefore, value.unit)}

              <Typography fontSize={13} color="text.secondary">
                {value.daysIntervalBefore.toFixed(2)} days before
              </Typography>
            </Stack>

            <Stack sx={{ marginLeft: "20px", marginRight: "20px" }}>
              <Divider orientation="vertical" />
            </Stack>
            <Stack>
              {buildValue(value.dataAfter, value.unit)}

              <Typography fontSize={15} color="text.secondary">
                {value.daysIntervalAfter.toFixed(2)} days after
              </Typography>
            </Stack>
          </Stack>
        </CardContent>

        {/* {referenceURL ? (
          <CardActions>
            <Button size="small" ><a href={referenceURL} target="_blank" >View</a></Button>
          </CardActions>
        ) : (
          <></>
        )} */}
      </Card>
    </Box>
  );
};

export default OutlinedChangeCard;
