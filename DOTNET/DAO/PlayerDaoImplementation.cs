using WebApplicationDemo.Models;
using Npgsql;
using System.Data;
using NpgsqlTypes;
using System.Text.RegularExpressions;
using Microsoft.Extensions.FileSystemGlobbing;
using System.Numerics;

namespace WebApplicationDemo.DAO
{
    public class PlayerDaoImplementation : IPlayerDao
    {
        NpgsqlConnection _connection;
        public PlayerDaoImplementation(NpgsqlConnection connection)
        {
            _connection = connection;
        }

        public async Task<List<Player>> GetPlayersByCountry(string country, string cname)
        {
            //Retrieve all players from a specific country, sorted by their current world ranking.The
            //accepts two parameters.
            Console.WriteLine("C"+country + " SC" + cname);
            List<Player> plist = new List<Player>();
            string query = @"select * from chess.Players where country ILIKE @country order by @cname";
            string errMessage = string.Empty;
            Player p = null;
            try
            {
                await _connection.OpenAsync();
                NpgsqlCommand command = new NpgsqlCommand(query, _connection);
                command.Parameters.AddWithValue("country", country);
                command.Parameters.AddWithValue("cname", cname);
                command.CommandType = CommandType.Text;
                NpgsqlDataReader reader = command.ExecuteReader();

                if (reader.HasRows)
                {
                    while (reader.Read())
                    {
                        p = new Player();
                        p.PlayerId = reader.GetInt32(0);
                        p.FirstName = reader.GetString(1);
                        p.LastName = reader.GetString(2);
                        p.Country = reader.GetString(3);
                        p.CurrentWorldRanking = reader.GetInt32(4);
                        p.TotalMatchesPlayed = reader.GetInt32(5);
                        plist.Add(p);
                    }
                }
                reader.Close();
            }
            catch (NpgsqlException e)
            {
                errMessage = e.Message;
                Console.WriteLine("------Exception-----:" + errMessage);
            }

            return plist;
        }

        public async Task<int> AddMatch(MatchItem match)
        {
            string query = @"insert into chess.Matches (player1_id, player2_id, match_date, match_level, winner_id) values (@player1, @player2, @date, @level, @winner);";
            string errMessage = string.Empty;
            try
            {
                await _connection.OpenAsync();
                NpgsqlCommand command = new NpgsqlCommand(query, _connection);
                command.Parameters.AddWithValue("@player1", match.Player1Id);
                command.Parameters.AddWithValue("@player2", match.Player2Id);
                command.Parameters.AddWithValue("@date", DateOnly.Parse( match.Date));
                command.Parameters.AddWithValue("@level", match.MatchLevel);
                command.Parameters.AddWithValue("@winner", match.WinnerId);
                command.CommandType = CommandType.Text;
                await command.ExecuteNonQueryAsync();
            }
            catch (NpgsqlException e)
            {
                errMessage = e.Message;
                Console.WriteLine("------Exception-----:" + errMessage);
                return 0;
            }
            return 1;
        }

        public async Task<List<PlayerPerformanceView>> GetPlayersPerformance()
        {
            List<PlayerPerformanceView> plist = new List<PlayerPerformanceView>();
            string query = @"SELECT * FROM chess.PlayerPerformance;";
            string errMessage = string.Empty;
            PlayerPerformanceView p = null;

            try
            {
                await _connection.OpenAsync();
                NpgsqlCommand command = new NpgsqlCommand(query, _connection);
                command.CommandType = CommandType.Text;
                NpgsqlDataReader reader = await command.ExecuteReaderAsync();

                if (reader.HasRows)
                {
                    while (reader.Read())
                    {
                        p = new PlayerPerformanceView();
                        p.PlayerId = (int)reader[0];
                        p.FullName = (string)reader[1];
                        p.WinPercentage = (decimal )reader[2];
                        p.TotalWon = (Int64)reader[3];
                        p.TotalMatchesPlayed = reader.GetInt32(4);
                        plist.Add(p);
                    }
                }
                reader.Close();
            }
            catch (NpgsqlException e)
            {
                errMessage = e.Message;
                Console.WriteLine("------Exception-----:" + errMessage);
            }

            return plist;
        }


        public async Task<List<PlayerPerformanceView>> GetPlayersPerformanceAboveAverage()
        {
            List<PlayerPerformanceView> plist = new List<PlayerPerformanceView>();
            string query = @"SELECT * FROM chess.PlayerPerformance WHERE total_won > (SELECT AVG(total_won) FROM chess.PlayerPerformance);";
            string errMessage = string.Empty;
            PlayerPerformanceView p = null;

            try
            {
                await _connection.OpenAsync();
                NpgsqlCommand command = new NpgsqlCommand(query, _connection);
                command.CommandType = CommandType.Text;
                NpgsqlDataReader reader = await command.ExecuteReaderAsync();

                if (reader.HasRows)
                {
                    while (reader.Read())
                    {
                        p = new PlayerPerformanceView();
                        p.PlayerId = (int)reader[0];
                        p.FullName = (string)reader[1];
                        p.WinPercentage = (decimal)reader[2];
                        p.TotalWon = (Int64)reader[3];
                        p.TotalMatchesPlayed = reader.GetInt32(4);
                        plist.Add(p);
                    }
                }
                reader.Close();
            }
            catch (NpgsqlException e)
            {
                errMessage = e.Message;
                Console.WriteLine("------Exception-----:" + errMessage);
            }

            return plist;
        }
    }
}
