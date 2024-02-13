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

  const convertSecondsToMinutesAndSeconds = (totalSeconds: number) => {
    const minutes = Math.floor(totalSeconds / 60);
    const remainingSeconds = totalSeconds % 60;
    const wholeSeconds = Math.floor(remainingSeconds);
    const fraction = remainingSeconds - wholeSeconds;
  //${fraction.toFixed(2).slice(1)}
    const formattedSeconds = `${String(wholeSeconds).padStart(2, '0')}`;

    return `${minutes}:${formattedSeconds}`;

    //return `${minutes}:${String(remainingSeconds.toFixed(2)).padStart(2, "0")}`;
  };

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
            {convertSecondsToMinutesAndSeconds(value)}
          </Typography>
          {/* <Typography fontSize={13} color="text.secondary">
            {value.toFixed(0)} Seconds
          </Typography> */}
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
    <Box sx={{ minWidth: 305, maxWidth: 305, width: 305 }}>
      <Card variant="outlined" sx={{ height: 220 }}>
        <CardContent>
          <Typography variant="h5" color="text.primary" gutterBottom>
            {value.displayName}
          </Typography>

          <Stack direction="row" sx={{ width: 290 }}>
            <Stack>
              {buildValue(value.dataBefore, value.unit)}

              <Typography fontSize={15} color="text.secondary">
                {value.daysIntervalBefore.toFixed(0)} days before
              </Typography>
            </Stack>

            <Stack sx={{ marginLeft: "20px", marginRight: "20px" }}>
              <Divider orientation="vertical" />
            </Stack>
            <Stack sx={{ alignContent: "right", textAlign: "right" }}>
              {buildValue(value.dataAfter, value.unit)}
              <Typography fontSize={15} color="text.secondary">
                {value.daysIntervalAfter.toFixed(0)} days after
              </Typography>
            </Stack>
          </Stack>
          {value.percentChange ? (
            <Stack
              direction="row"
              justifyContent="center"
              alignItems="center"
              sx={{ marginTop: "10px" }}
            >
              <Typography fontSize={19} color="text.secondary">
                Change:
              </Typography>
              <Typography
                fontSize={19}
                color="text.primary"
                sx={{ marginLeft: "10px" }}
              >
                {value.percentChange}
              </Typography>
            </Stack>
          ) : (
            <></>
          )}
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
