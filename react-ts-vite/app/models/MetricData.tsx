export interface DataPoint {
  sales: string;
  id: string;
  itemCount: number;
  name: string;
  displayName: string;
  orderCount: number;
}

export interface MetricData {
  data: number[];
  labels: string[];
  name: string;
  displayName: string;
}

export interface ChangeMetricResponse {
  change: TrackableChange;
  metrics: TrackedChangeMetric[];
}

export interface TrackedChangeMetric {
  dataAfter: number;
  dataBefore: number;
  dateRangeAfter: string[];
  dateRangeBefore: string[];
  daysIntervalAfter: number;
  daysIntervalBefore: number;
  displayName: string;
  unit: string;
}

export interface SingleMetric {
  displayName: string;
  data: any;
  debugDescription?: string;
}

/**
 Documentation
 `TrackableChange` interface describes changes to objects.
 */
export interface TrackableChange {
  /** Date of the change */
  date: Date;
  /** Name of the thing that was changed */
  name: String;
  /** Description of the change */
  description: String;
  /** Expectation from the change */
  expectations: String;
  /** URL reference for more information on the change. */
  referenceURL?: String;
}
