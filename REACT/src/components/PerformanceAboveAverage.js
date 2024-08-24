import React, { useState,useEffect } from 'react'
import { getPlayersPerformanceAboveAverage } from '../service/ApiService'
import PlayerDataCard from './cards/PlayerDataCard';

const PerformanceAboveAverage = () => {
    const [players, setPlayers] = useState([]);
    useEffect(() => {
      getPlayersPerformanceAboveAverage()
          .then((data) => {
            setPlayers(data);
          })
          .catch((err) => {
            console.log(err);
          });
    }, [])

  return (
    <div className='text-center w-full flex flex-col items-center'>
      <h1 className='text-3xl mt-10'>Players Performance Above Average</h1>
      {players.map((player) => (
        <PlayerDataCard player={player} key={player.playerId} />
      ))}
    </div>
  )
}

export default PerformanceAboveAverage;