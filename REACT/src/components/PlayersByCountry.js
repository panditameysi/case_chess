import React, {  useState } from 'react'
import { getPlayersOfCountryByColumn } from '../service/ApiService';
import { addToList } from '../redux/slices/playersSlice';
import { useDispatch, useSelector } from 'react-redux';

const PlayersByCountry = () => {
    const [country, setCountry] = useState();
    const [column, setColumn] = useState();
    const [loading, setLoading] = useState(false);
    const dispatch = useDispatch();
    const data = useSelector((state) => state.players);
    console.log(data);

   
    const buttonHandler = async (e) => {
        setLoading(true);
        e.preventDefault();
        try {
            const data = await getPlayersOfCountryByColumn(country, column);
            data.map(element => {
                dispatch(addToList(element)); 
            });
        } catch (error) {
          console.error(error);
        }
        setLoading(false);

    }
  return (
    <>{
        loading ?<h1> Loading...</h1> :<div className='flex flex-col items-center'>
        <form className='space-y-5 mt-5'>
            <input onChange={(e) => {setCountry(e.target.value)}} type='text' placeholder='Country' className='bg-gray-200 p-5 w-96'/>
            <br/>
            <input onChange={(e) => {setColumn(e.target.value)}} type='text' placeholder='Column' className='bg-gray-200 p-5 w-96'/>
            <br/>
            <button className='submit-button w-80' onClick={buttonHandler}>Submit</button>
        </form>
        {data.map((player) => (
            <div className='flex flex-col bg-gray-300 m-10 w-1/2 p-10'>
                <p>Full Name : {player.firstName} {player.lastName}</p>
                <p>Country : {player.country}</p>
                <p>World Ranking : {player.currentWorldRanking}</p>
                <p>Total Matches : {player.totalMatchesPlayed}</p>
            </div>
        )
        )}
    </div>
    }
    </>
  )
}

export default PlayersByCountry