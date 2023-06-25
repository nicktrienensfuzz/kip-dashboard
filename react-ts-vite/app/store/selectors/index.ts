import { TPrimaryStore } from "../index";

export const selectCount = (state: TPrimaryStore) => {
  return state.count;
};

export const selectIncrementBy = (state: TPrimaryStore) => {
  return state.incrementBy;
};
