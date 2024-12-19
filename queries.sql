-- number 1 : créer un tournoi
SELECT simulate_tournament('Summer ELO Chess Tournament', 'Online', 7, 10000.00);
-- number 2 : voir un tournoi
WITH LastTournament AS (
    SELECT Tournament_Id 
    FROM Tournament 
    ORDER BY Game_Date DESC 
    LIMIT 1
)
SELECT 
    t.Name as Tournament_Name,
    g.Game_Date,
    pw.First_Name || ' ' || pw.Last_Name as White_Player,
    pb.First_Name || ' ' || pb.Last_Name as Black_Player,
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
WHERE t.Tournament_Id = (SELECT Tournament_Id FROM LastTournament)
ORDER BY g.Game_Date;

--Number 3 :  Retrieve the players (by rank) for each tournament along with their prize money and tournament name
SELECT 
    t.Name AS "Tournament Name",
    tr.Player_Name AS "Player Name",
    tr.Rank AS "Rank",
    tr.Prize_Money_Won AS "Prize Money"
FROM 
    Tournament_Ranking tr
JOIN 
    Tournament t ON tr.Tournament_Id = t.Tournament_Id
WHERE 
    tr.Rank IS NOT NULL -- Only include players with valid ranks
ORDER BY 
    t.Name ASC, -- Order by tournament name
    tr.Rank ASC; -- Within each tournament, order by rank