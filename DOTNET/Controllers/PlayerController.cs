using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using WebApplicationDemo.DAO;
using WebApplicationDemo.Models;

namespace WebApplicationDemo.Controllers
{
    [Route("chess/")]
    [ApiController]
    public class PlayerController : ControllerBase
    {
        private readonly IPlayerDao _playerDao;

        public PlayerController(IPlayerDao playerDao)
        {
            _playerDao = playerDao;
        }


        [HttpGet("GetPlayersPerformance", Name = "GetPlayersPerformance")]
        public async Task<ActionResult<List<PlayerPerformanceView>>> GetPlayersPerformance()
        {
            var pFound = await _playerDao.GetPlayersPerformance();
            if (pFound == null)
            {
                return NotFound();
            }
            return Ok(pFound);
        }

        [HttpGet("GetPlayersPerformanceAboveAverage", Name = "GetPlayersPerformanceAboveAverage")]
        public async Task<ActionResult<List<PlayerPerformanceView>>> GetPlayersPerformanceAboveAverage()
        {
            var pFound = await _playerDao.GetPlayersPerformanceAboveAverage();
            if (pFound == null)
            {
                return NotFound();
            }
            return Ok(pFound);
        }

        [HttpGet("GetPlayersOfCountryByColumn", Name = "GetPlayersOfCountryByColumn")]
        public async Task<ActionResult<List<Player>>> GetPlayersOfCountryByColumn( string country,string cname)
        {
            var pFound = await _playerDao.GetPlayersByCountry(country, cname);
            if (pFound == null)
            {
                return NotFound();
            }
            return Ok(pFound);
        }

        [HttpPost("AddNewMatch", Name = "AddNewMatch")]
        public async Task<ActionResult<int>> AddNewMatch(int player1_id,int player2_id,string match_date,string match_level,int winner_id)
        {
            MatchItem matchItem = new MatchItem() { 
                Player1Id = player1_id,
                Player2Id = player2_id,
                MatchLevel = match_level,
                WinnerId = winner_id,
                Date = match_date,
            };
            var pFound = await _playerDao.AddMatch(matchItem);
            if (pFound == 0)
            {
                return NotFound();
            }
            return Ok(pFound);
        }
    }
}
