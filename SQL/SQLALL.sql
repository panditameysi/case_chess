SHOW search_path;
SET search_path to chess,public;

CREATE TABLE Players (
	player_id SERIAL PRIMARY KEY ,
	first_name VARCHAR(50) NOT NULL,
	last_name VARCHAR(50) NOT NULL,
	country VARCHAR(50) NOT NULL,
	current_world_ranking INTEGER UNIQUE NOT NULL,
	total_matches_played INTEGER NOT NULL DEFAULT 0
);

INSERT INTO Players (first_name, last_name, country, current_world_ranking, total_matches_played)
VALUES 
('Magnus', 'Carlsen', 'Norway', 1, 100),
('Fabiano', 'Caruana', 'USA', 2, 95),
('Ding', 'Liren', 'China', 3, 90),
('Ian', 'Nepomniachtchi', 'Russia', 4, 85),
('Wesley', 'So', 'USA', 5, 80),
('Anish', 'Giri', 'Netherlands', 6, 78),
('Hikaru', 'Nakamura', 'USA', 7, 75),
('Viswanathan', 'Anand', 'India', 8, 120),
('Teimour', 'Radjabov', 'Azerbaijan', 9, 70),
('Levon', 'Aronian', 'Armenia', 10, 72);


SELECT * FROM chess.Players;

select * from chess.Players where country = 'USA' order by total_matches_played;

CREATE TABLE Matches (
	match_id SERIAL PRIMARY KEY,
	player1_id INT NOT NULL REFERENCES Players(player_id),
	player2_id INT NOT NULL REFERENCES Players(player_id),
	match_date DATE NOT NULL,
	match_level VARCHAR(20) NOT NULL CHECK (match_level IN ('International', 'National')),
	winner_id INT REFERENCES Players(player_id)
);

INSERT INTO Matches (player1_id, player2_id, match_date, match_level, winner_id)
VALUES 
(1, 2, '2024-08-01', 'International', 1),
(3, 4, '2024-08-02', 'International', 3),
(5, 6, '2024-08-03', 'National', 5),
(7, 8, '2024-08-04', 'International', 8),
(9, 10, '2024-08-05', 'National', 10),
(1, 3, '2024-08-06', 'International', 1),
(2, 4, '2024-08-07', 'National', 2),
(5, 7, '2024-08-08', 'International', 7),
(6, 8, '2024-08-09', 'National', 8),
(9, 1, '2024-08-10', 'International', 1);

SELECT * FROM chess.Matches;

CREATE TABLE Sponsors (
	sponsor_id SERIAL PRIMARY KEY,
	sponsor_name VARCHAR(100) UNIQUE NOT NULL,
	industry VARCHAR(50) NOT NULL,
	contact_email VARCHAR(100) NOT NULL,
	contact_phone VARCHAR(20) NOT NULL
);

INSERT INTO Sponsors (sponsor_name, industry, contact_email, contact_phone)
VALUES 
('TechChess', 'Technology', 'contact@techchess.com', '123-456-7890'),
('MoveMaster', 'Gaming', 'info@movemaster.com', '234-567-8901'),
('ChessKing', 'Sports', 'support@chessking.com', '345-678-9012'),
('SmartMoves', 'AI', 'hello@smartmoves.ai', '456-789-0123'),
('GrandmasterFinance', 'Finance', 'contact@grandmasterfinance.com', '567-890-1234');

SELECT * FROM Sponsors;

DROP TABLE Player_Sponsors;
CREATE TABLE Player_Sponsors(
	player_id INT NOT NULL REFERENCES Players(player_id), 
	sponsor_id INT NOT NULL REFERENCES Sponsors(sponsor_id),
	sponsorship_amount NUMERIC(10, 2) NOT NULL,
	contract_start_date DATE NOT NULL,
	contract_end_date DATE NOT NULL,
	Primary Key (player_id, sponsor_id)
);

INSERT INTO Player_Sponsors (player_id, sponsor_id, sponsorship_amount, contract_start_date, contract_end_date)
VALUES 
(1, 1, 500000.00, '2023-01-01', '2025-12-31'),
(2, 2, 300000.00, '2023-06-01', '2024-06-01'),
(3, 3, 400000.00, '2024-01-01', '2025-01-01'),
(4, 4, 350000.00, '2023-03-01', '2024-03-01'),
(5, 5, 450000.00, '2023-05-01', '2024-05-01'),
(6, 1, 250000.00, '2024-02-01', '2025-02-01'),
(7, 2, 200000.00, '2023-08-01', '2024-08-01'),
(8, 3, 600000.00, '2023-07-01', '2025-07-01'),
(9, 4, 150000.00, '2023-09-01', '2024-09-01'),
(10, 5, 300000.00, '2024-04-01', '2025-04-01');

SELECT * FROM Player_Sponsors;

-- 1 List the match details including the player names (both player1 and player2), match date, and match level for all International matches.
SELECT CONCAT(pt.first_name,' ',pt.last_name) as Player_1,
	CONCAT(pt2.first_name,' ',pt2.last_name) as Player_2,
	mt.match_date,
	mt.match_level
	FROM Matches mt
JOIN Players pt ON mt.player1_id=pt.player_id
JOIN Players pt2 ON mt.player2_id=pt2.player_id
	WHERE mt.match_level LIKE 'International';

-- 2  Extend the contract end date of all sponsors associated with players from the USA by one year.
UPDATE Player_Sponsors SET contract_end_date=TO_DATE(CONCAT(date_part('year',contract_end_date)+1,'0',date_part('month',contract_end_date),'0',date_part('DAY',contract_end_date)),'YYYYMMDD')
	WHERE player_id in (SELECT p.player_id FROM Players p
	JOIN Player_Sponsors ps ON p.player_id=ps.player_id
	WHERE p.country = 'USA');

SELECT date_part('year',contract_end_date),date_part('month',contract_end_date),date_part('DAY',contract_end_date) FROM Players p
	JOIN Player_Sponsors ps ON p.player_id=ps.player_id
	WHERE p.country = 'USA';

-- 3 List all matches played in August 2024, sorted by the match date in ascending order.
SELECT * FROM Matches WHERE date_part('year',match_date)='2024' AND date_part('month',match_date) = 08 ORDER BY match_date;

--4 Calculate the average sponsorship amount provided by sponsors and display it along with the total number of sponsors. Dispaly with the title Average_Sponsorship  and Total_Sponsors.
SELECT AVG(sponsorship_amount) AS Average_Sponsorship, COUNT(DISTINCT sponsor_id) AS Total_Sponsors FROM Player_Sponsors;

-- 5 Show the sponsor names and the total sponsorship amounts they have provided across all players. Sort the result by the total amount in descending order.
SELECT s.sponsor_name, SUM(ps.sponsorship_amount) AS total_sponsorship_amount 
FROM player_sponsors ps JOIN sponsors s ON ps.sponsor_id = s.sponsor_id 
GROUP BY s.sponsor_name ORDER BY total_sponsorship_amount DESC;

SELECT * FROM Matches;
SELECT * FROM Players;

-- Phase 3
-- 1 Retrieve the names of players along with their total number of matches won, calculated as a percentage of their total matches played.Display the full_name along with  Win_Percentage rounded to 4 decimals
	SELECT CONCAT(p.first_name,' ',p.last_name) AS full_name,
	    ROUND((COUNT(m.winner_id) * 100.0) / p.total_matches_played,4) AS Win_Percentage
		FROM Players p
		LEFT JOIN Matches m ON p.player_id = m.winner_id
		GROUP BY p.player_id
		ORDER BY Win_Percentage DESC;

-- 2 Retrieve the match details for matches where the winner's current world ranking is among the top 5 players. Display the match date, winner's name, and the match level. 
	SELECT m.match_date, 
		CONCAT(p.first_name , ' ' , p.last_name) AS winners_full_name,
		m.match_level
		FROM Matches m
		JOIN Players p  
		ON m.winner_id = p.player_id
		WHERE p.current_world_ranking <6;

-- 3 Find the sponsors who are sponsoring the top 3 players based on their current world ranking. Display the sponsor name and the player's full name an their world ranking.
	SELECT s.sponsor_name,
		p.first_name || ' ' || p.last_name AS player_name,
	    p.current_world_ranking
		FROM Players p
		JOIN Player_Sponsors ps ON p.player_id=ps.player_id
		JOIN Sponsors s ON s.sponsor_id = ps.sponsor_id
		WHERE current_world_ranking<=3
		ORDER BY current_world_ranking;

-- 4  Create a query that retrieves the full names of all players along with a label indicating their performance in the tournament based on their match win percentage. The label should be:
-- "Excellent" if the player has won more than 75% of their matches.
-- "Good" if the player has won between 50% and 75% of their matches.
-- "Average" if the player has won between 25% and 50% of their matches.
-- "Needs Improvement" if the player has won less than 25% of their matches.
-- The query should also include the player's total number of matches played and total number of matches won. The calculation for the win percentage should be done using a subquery.
	
	SELECT CONCAT(p.first_name,' ',p.last_name) AS full_name,
		p.total_matches_played,
		COUNT(m.winner_id) as total_won,
		CASE 
			WHEN ((COUNT(m.winner_id) * 100.0) / p.total_matches_played )>75 THEN 'Excellent'
			WHEN ((COUNT(m.winner_id) * 100.0) / p.total_matches_played ) BETWEEN 75 and 50 THEN 'Good'
			WHEN ((COUNT(m.winner_id) * 100.0) / p.total_matches_played ) BETWEEN 50 and 25 THEN 'Average'
			WHEN ((COUNT(m.winner_id) * 100.0) / p.total_matches_played )<25 THEN 'Needs Improvement'
		END as Label
	FROM Players p
	LEFT JOIN Matches m ON p.player_id = m.winner_id
	GROUP BY p.player_id;

-- 5 Retrieve the names of players who have never won a match (i.e., they have participated in matches but are not listed as a winner in any match). Display their full name and current world ranking.
	SELECT CONCAT(p.first_name , ' ' , p.last_name) AS full_name,
		p.current_world_ranking
		FROM Matches m
		RIGHT JOIN Players p  
		ON m.winner_id = p.player_id
		WHERE m.winner_id IS NULL
		ORDER BY p.current_world_ranking;

--PHASE 4
-- 1 Create a view named PlayerRankings that lists all players with their full name (first name and last name combined), country, and current world ranking, sorted by their world ranking in ascending order.
CREATE VIEW PlayerRankings AS 
	SELECT CONCAT(first_name,' ',last_name) AS full_name,
	country,
	current_world_ranking
	FROM Players
		ORDER BY current_world_ranking;

SELECT * FROM PlayerRankings;

-- 2 Create a view named MatchResults that shows the details of each match, including the match date, the names of the players (both player1 and player2), and the name of the winner. If the match is yet to be completed, the winner should be displayed as 'TBD'.
CREATE VIEW MatchResults AS 
	SELECT m.match_date, 
		CONCAT(p1.first_name,' ',p1.last_name) as Player_1,
		CONCAT(p2.first_name,' ',p2.last_name) as Player_2,
		COALESCE(CONCAT(w.first_name,' ',w.last_name),'TBD') as Winner
		FROM Matches m
		JOIN Players p1 ON p1.player_id = m.player1_id
		JOIN Players p2 ON p2.player_id = m.player2_id
		JOIN Players w ON w.player_id = m.winner_id
		;

SELECT * FROM MatchResults;
-- 3  Create a view named SponsorSummary that shows each sponsor's name, the total number of players they sponsor, and the total amount of sponsorship provided by them.
CREATE VIEW SponsorSummary AS
	SELECT s.sponsor_name, COUNT(ps.player_id) AS Players_sponsored,SUM(sponsorship_amount) as Total_amount FROM Player_Sponsors ps
	JOIN Sponsors s ON ps.sponsor_id=s.sponsor_id
	GROUP BY s.sponsor_id;

SELECT * FROM SponsorSummary;
DROP VIEW SponsorSummary;

-- 4 Create a view named ActiveSponsorships that lists the active sponsorships (where the contract end date is in the future). The view should include the player’s full name, sponsor name, and sponsorship amount. Ensure the view allows updates to the sponsorship amount.
CREATE VIEW ActiveSponsorships AS
SELECT CONCAT(p.first_name,' ',p.last_name) as Player_Full_Name,
    s.sponsor_name,
    ps.sponsorship_amount,
	ps.contract_end_date
FROM Player_Sponsors ps
JOIN Players p ON ps.player_id=p.player_id
JOIN Sponsors s ON s.sponsor_id=ps.sponsor_id
WHERE ps.contract_end_date > CURRENT_DATE;

SELECT * FROM ActiveSponsorships;
DROP VIEW ActiveSponsorships;


-- 5 
DROP VIEW PlayerPerformanceSummary;
CREATE VIEW PlayerPerformanceSummary AS
SELECT 
    CONCAT(p.first_name,' ',p.last_name) AS Player_Name,
    p.total_matches_played AS Total_Matches_Played,
    COUNT(m.winner_id) AS Total_Wins,
    ROUND((COUNT(m.winner_id) * 100.0) / p.total_matches_played, 4) AS Win_Percentage,
    CASE 
        WHEN National > International THEN 'National'
        WHEN International > National THEN 'International'
        WHEN National = International THEN 'Balanced'
        ELSE 'No Winnning Daeta'
    END AS Best_Match_Level
FROM Players p
LEFT JOIN Matches m ON p.player_id = m.winner_id
LEFT JOIN (
    SELECT 
        winner_id,
        COUNT(CASE WHEN match_level = 'National' THEN 1 END) AS National,
        COUNT(CASE WHEN match_level = 'International' THEN 1 END) AS International
    FROM Matches
    GROUP BY winner_id
) mt 
	ON p.player_id = mt.winner_id
GROUP BY p.player_id, p.first_name, p.last_name, p.total_matches_played, National, International
ORDER BY Win_Percentage DESC;

SELECT *  FROM PlayerPerformanceSummary;

SELECT * FROM Players;




SELECT p.player_id,
	CONCAT(p.first_name,' ',p.last_name) AS full_name,
	    ROUND((COUNT(m.winner_id) * 100.0) / p.total_matches_played,4) AS Win_Percentage,
		COUNT(m.winner_id) As Total_Won,
		p.total_matches_played
		FROM Players p
		LEFT JOIN Matches m ON p.player_id = m.winner_id
		GROUP BY p.player_id
);

SELECT p.player_id,
	CONCAT(p.first_name,' ',p.last_name) AS full_name,
	    ROUND((COUNT(m.winner_id) * 100.0) / p.total_matches_played,4) AS Win_Percentage,
		COUNT(m.winner_id) As Total_Won,
		p.total_matches_played
		FROM Players p
		LEFT JOIN Matches m ON p.player_id = m.winner_id
		GROUP BY p.player_id
	;