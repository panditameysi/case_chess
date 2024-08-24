import React from 'react'

const PlayerDataCard = ({player}) => {
  return (

    <div className='m-14 flex flex-col bg-blue-300 p-10 text-center rounded-2xl w-1/2'>
            <p className='text-sm'>Player ID : {player.playerId}</p>
            <h1 className='text-3xl font-bold'>{player.fullName}</h1>
            <h2 className='text-2xl'>Win Percentage : {player.winPercentage}%</h2>
            <p className='text-xl'>Total Won : {player.totalWon}</p>
            <p className='text-xl'>Total Matches Played : {player.totalMatchesPlayed}</p>
    </div>
  );
}

export default React.memo(PlayerDataCard);