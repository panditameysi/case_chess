using System.ComponentModel.DataAnnotations;
using System.Diagnostics.CodeAnalysis;
using System.Numerics;

namespace WebApplicationDemo.Models
{
    public class PlayerPerformanceView
    {

        public int PlayerId { get; set; }
        public string FullName { get; set; }
        public decimal WinPercentage { get; set; }
        public Int64 TotalWon { get; set; }
        public int TotalMatchesPlayed { get; set; }        

    }
}
