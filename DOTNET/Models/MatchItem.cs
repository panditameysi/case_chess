using System.ComponentModel.DataAnnotations;
using System.Diagnostics.CodeAnalysis;

namespace WebApplicationDemo.Models
{
    public class MatchItem
    {

        public int Player1Id { get; set; }
        [Required, NotNull]
        public int Player2Id { get; set; }
        [Required, NotNull]

        public string Date { get; set; }
        public string MatchLevel { get; set; }
        [Required, NotNull]
        public int WinnerId { get; set; }
        

        

    }
}
