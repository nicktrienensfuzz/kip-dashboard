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
