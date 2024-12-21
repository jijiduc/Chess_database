-- Query 1: Create a tournament with new parameters
SELECT simulate_tournament(
    'Open de Paris',     -- tournament_name
    'Paris',             -- tournament_location
    8,                   -- number_of_players
    3,                   -- number_of_rounds (must be odd)
    50000.00            -- prize_pool
);

-- Query 2: Display games from the latest tournament with player countries
WITH LastTournament AS (
    SELECT Tournament_Id 
    FROM Tournament 
    ORDER BY Game_Date DESC 
    LIMIT 1
)
SELECT 
    t.Name as Tournament_Name,
    g.Round_Number || '.' || g.Round_Game_Number as Game_Number,
    g.Game_Date,
    pw.First_Name || ' ' || pw.Last_Name as White_Player,
    cw.Name as White_Player_Country,
    pb.First_Name || ' ' || pb.Last_Name as Black_Player,
    cb.Name as Black_Player_Country,
    o.Name as Opening_Name,
    g.result
FROM Tournament t
JOIN Game g ON g.Game_Id IN (
    SELECT DISTINCT gp.Game_Id
    FROM Tournament_Players tp
    JOIN Game_Players gp ON tp.Player_Id = gp.Player_Id
    WHERE tp.Tournament_Id = t.Tournament_Id
)
JOIN Player pw ON g.Player_white_Id = pw.Player_Id
JOIN Player pb ON g.Player_black_Id = pb.Player_Id
JOIN Opening o ON g.Opening_Id = o.Opening_Id
-- Add country information for white player
JOIN Player_Country pcw ON pw.Player_Id = pcw.Player_Id
JOIN Country cw ON pcw.Country_Id = cw.Country_Id
-- Add country information for black player
JOIN Player_Country pcb ON pb.Player_Id = pcb.Player_Id
JOIN Country cb ON pcb.Country_Id = cb.Country_Id
WHERE t.Tournament_Id = (SELECT Tournament_Id FROM LastTournament)
ORDER BY g.Round_Number, g.Round_Game_Number;

-- Query 3: Retrieve tournament rankings with player countries
SELECT 
    t.Name AS "Tournament Name",
    tr.Player_Name AS "Player Name",
    c.Name AS "Country",
    tr.Rank AS "Rank",
    tr.Prize_Money_Won AS "Prize Money"
FROM 
    Tournament_Ranking tr
JOIN 
    Tournament t ON tr.Tournament_Id = t.Tournament_Id
-- Join to get player information
JOIN Player p ON CONCAT(p.First_Name, ' ', p.Last_Name) = tr.Player_Name
-- Join to get country information
JOIN Player_Country pc ON p.Player_Id = pc.Player_Id
JOIN Country c ON pc.Country_Id = c.Country_Id
WHERE 
    tr.Rank IS NOT NULL -- Only include players with valid ranks
ORDER BY 
    t.Name ASC, -- Order by tournament name
    tr.Rank ASC; -- Within each tournament, order by rank