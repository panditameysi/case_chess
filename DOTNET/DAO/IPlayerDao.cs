using Microsoft.AspNetCore.Http.HttpResults;
using System.Text.RegularExpressions;
using System;
using WebApplicationDemo.Models;
using System.Globalization;
using static System.Collections.Specialized.BitVector32;
using Microsoft.Extensions.FileSystemGlobbing;
using static System.Runtime.InteropServices.JavaScript.JSType;
using System.Numerics;

namespace WebApplicationDemo.DAO
{
    public interface IPlayerDao
    {

        Task<int> AddMatch(MatchItem match);

        Task<List<PlayerPerformanceView>> GetPlayersPerformance();

        Task<List<PlayerPerformanceView>> GetPlayersPerformanceAboveAverage();

        Task<List<Player>> GetPlayersByCountry(string country, string sortByColumn);
    }
}
