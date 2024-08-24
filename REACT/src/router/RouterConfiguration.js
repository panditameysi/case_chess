import React from 'react';
import { BrowserRouter, Route, Routes } from "react-router-dom";
import NavBar from '../components/NavBar';
import Home from '../components/Home';
import AddMatch from '../components/AddMatch';
import PlayerPerformance from '../components/PlayerPerformance';
import PerformanceAboveAverage from '../components/PerformanceAboveAverage';

const RouterConfiguration = () => {
  return (
    <BrowserRouter>
      <NavBar/>
      <Routes>
          <Route path="/" element={<Home/>} />
          <Route path="/add" element={<AddMatch/>} />
          <Route path="/performance" element={<PlayerPerformance/>} />
          <Route path="/average" element={<PerformanceAboveAverage/>} />
      </Routes>
    </BrowserRouter>
  )
}

export default RouterConfiguration