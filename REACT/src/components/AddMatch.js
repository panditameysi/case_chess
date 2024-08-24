import React, { useState } from 'react';
import { ToastContainer, toast } from 'react-toastify';
import 'react-toastify/dist/ReactToastify.css';
import {postMatch} from "../service/ApiService";

const AddMatch = () => {
  const [player1,setPlayer1] = useState(null);
  const [player2,setPlayer2] = useState(null);
  const [date,setDate] = useState(null);
  const [level,setLevel] = useState(null);
  const [winner,setWinner] = useState(null);

  const handleSubmit = (e) => {
    e.preventDefault();
    // console.log(player1,player2,date,level,winner);
    if(!player1 || !player2 || !date || !level || !winner){
      notify("All fields are required");
    }
    else{
      let data = {
        player1:parseInt(player1),
        player2:parseInt(player2),
        date,
        level,
        winner:parseInt(winner)
      }
      let res = postMatch(data)
        .then((data) => {
          // console.log(data);
          notify(data);
        })
        .catch((err) => {
          // console.log(err);
          notify(err);
        })
        notify("Match added successfully");
    }
  }

  const notify = (text) => toast(text);

  return (
    <div className='flex flex-col w-full justify-center items-center'>
        <h1 className='text-4xl mb-10'>Add Match</h1>
        <form className='space-y-5 '>
            <input onChange={(e) => setPlayer1(e.target.value)} type='text' placeholder='player1_id' className='bg-gray-200 p-5 w-96'/>
            <br/>
            <input onChange={(e) => setPlayer2(e.target.value)} type='text' placeholder='player2_id' className='bg-gray-200 p-5 w-96'/>
            <br/>
            <input onChange={(e) => setDate(e.target.value)} type='text' placeholder='match_date' className='bg-gray-200 p-5 w-96'/>
            <br/>
            <input onChange={(e) => setLevel(e.target.value)} type='text' placeholder='match_level' className='bg-gray-200 p-5 w-96'/>
            <br/>
            <input onChange={(e) => setWinner(e.target.value)} type='text' placeholder='winner_id' className='bg-gray-200 p-5 w-96'/>
            <br/>
            <button className='submit-button w-80' onClick={handleSubmit}>Submit</button>
        </form>
        <ToastContainer />
    </div>
  )
}

export default AddMatch