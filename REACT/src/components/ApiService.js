import axios from "axios";
const URL = `http://localhost:5046/chess/`;

async function getPlayersPerformance() {
  let data = null;

  try {
    let response = await axios.get(URL + "GetPlayersPerformance");
    if (response.status === 200) {
      data = await response.data;
      console.log(data);
    }
  } catch (error) {
    return JSON.stringify(error);
  }
  return data;
}

async function GetPlayersPerformanceAboveAverage() {
    let data = null;
  
    try {
      let response = await axios.get(URL + "GetPlayersPerformanceAboveAverage");
      if (response.status === 200) {
        data = await response.data;
        console.log(data);
      }
    } catch (error) {
      return JSON.stringify(error);
    }
    return data;
  }

async function postMatch(match){
    let data = null;
    try{

        fetch(URL + "AddNewMatch?player1_id="+match.player1+"&player2_id="+match.player2+"&match_date="+match.date+"&match_level="+match.level+"&winner_id="+match.winner,{
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(match)
        })
        .then((response) => response.json())
        .then((data) => {
            console.log(data);
            return data
        })
        .catch((error) => {
            console.log(error);
            return error
        })
    } catch (error) {
        return JSON.stringify(error);
    }
    return [data];
}

export {getPlayersPerformance,postMatch,GetPlayersPerformanceAboveAverage}