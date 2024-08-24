import { configureStore } from "@reduxjs/toolkit";
import playersSlice from "../slices/playersSlice";
export const store = configureStore({
    reducer: {
        players : playersSlice,
    }
})