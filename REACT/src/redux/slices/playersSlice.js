import { createSlice } from "@reduxjs/toolkit";

const initialList = [];

const playersSlice = createSlice({
  name: "players",
  initialState: initialList,
  reducers: {
    addToList: (state, action) => {
      state.push(action.payload);
    },
  },
});

export const { addToList } = playersSlice.actions;
export default playersSlice.reducer;