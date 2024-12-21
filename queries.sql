-- Query 1: Create a tournament
SELECT simulate_tournament(
    'Open de Paris',     -- tournament_name
    'Paris',             -- tournament_location
    34,                   -- number_of_players
    9,                   -- number_of_rounds (must be odd)
    50000.00            -- prize_pool
);

-- Query 2: Display all games from the latest tournament 
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
    CASE 
        WHEN o.ECO_Code IS NOT NULL THEN o.ECO_Code || ' - ' || o.Name
        ELSE o.Name
    END as Opening_Name,
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

-- Query 3 : Retrieve all tournament rankings
WITH PlayerScores AS (
    SELECT 
        tp.Tournament_Id,
        tp.Player_Id,
        COALESCE(
            (SELECT COUNT(*) 
            FROM Game g
            WHERE g.Tournament_Id = tp.Tournament_Id
            AND ((g.Player_White_Id = tp.Player_Id AND g.Result = '1-0')
                OR (g.Player_Black_Id = tp.Player_Id AND g.Result = '0-1'))), 0
        ) as wins,
        COALESCE(
            (SELECT COUNT(*) 
            FROM Game g
            WHERE g.Tournament_Id = tp.Tournament_Id
            AND (g.Player_White_Id = tp.Player_Id OR g.Player_Black_Id = tp.Player_Id)
            AND g.Result = '1/2-1/2'), 0
        ) as draws,
        calculate_buchholz_score(tp.Tournament_Id, tp.Player_Id) as buchholz_score,
        calculate_performance_rating(tp.Tournament_Id, tp.Player_Id) as performance_rating
    FROM Tournament_Players tp
)
SELECT 
    t.Name AS "Tournament Name",
    tr.Player_Name AS "Player Name",
    p.ELO_Rating AS "ELO",
    ti.Title_Code AS "Title",
    c.Name AS "Country",
    tr.Rank AS "Rank",
    (ps.wins + ps.draws * 0.5)::DECIMAL(4,1) AS "Total Score",
    ps.buchholz_score::DECIMAL(4,1) AS "Buchholz Score",
    ROUND(ps.performance_rating::DECIMAL) AS "Performance Rating",
    tr.Prize_Money_Won AS "Prize Money"
FROM 
    Tournament_Ranking tr
JOIN 
    Tournament t ON tr.Tournament_Id = t.Tournament_Id
-- Join to get player information
JOIN Player p ON CONCAT(p.First_Name, ' ', p.Last_Name) = tr.Player_Name
-- Join to get scores and departage information
JOIN PlayerScores ps ON ps.Tournament_Id = tr.Tournament_Id 
    AND ps.Player_Id = p.Player_Id
-- Join to get title information
JOIN Title ti ON p.Title_Id = ti.Title_Id
-- Join to get country information
JOIN Player_Country pc ON p.Player_Id = pc.Player_Id
JOIN Country c ON pc.Country_Id = c.Country_Id
WHERE 
    tr.Rank IS NOT NULL -- Only include players with valid ranks
ORDER BY 
    t.Name ASC,         -- Order by tournament name
    tr.Rank ASC;        -- Within each tournament, order by rank