import { create } from "zustand";
import { persist, createJSONStorage } from "zustand/middleware";

export type TPrimaryStore = {
  count: number;
  incrementBy: (value: number) => void;
};

/* PrimaryStore is an example store that demonstates a typed store in zustand.
 *
 * Depending on the structure of your application, you may need multiple stores.
 * */
export const usePrimaryStore = create<TPrimaryStore>()(
  persist(
    (set, get) => ({
      count: 0,
      incrementBy: (byValue: number) => {
        set((state) => ({
          count: state.count + byValue,
        }));
      },
    }),
    {
      name: "primary-storage",
      // you may also use sessionStorage, indexedDB, etc. refer to zustand documentation
      storage: createJSONStorage(() => localStorage),
    }
  )
);
