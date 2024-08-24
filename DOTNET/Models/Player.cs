using System.ComponentModel.DataAnnotations;
using System.Diagnostics.CodeAnalysis;

namespace WebApplicationDemo.Models
{
    public class Player
    {

        public int PlayerId { get; set; }
        [Required, NotNull]
        public string FirstName { get; set; }
        [Required, NotNull]
        public string LastName { get; set; }
        [Required, NotNull]
        public string Country { get; set; }
        [Required, NotNull]
        public int CurrentWorldRanking { get; set; }
        [Required, NotNull]
        public int TotalMatchesPlayed { get; set; } = 0;

        

    }
}
