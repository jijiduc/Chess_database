-- Step 1: Create a Tournament
INSERT INTO Tournament (Name, Location, Total_Round_Number, Game_Date, Format, Prize_Pool)
VALUES ('Random Chess Championship', 'Online', 7, CURRENT_TIMESTAMP, 'Swiss', 10000.00)
RETURNING Tournament_Id;

-- Step 2: Randomly Select Players
WITH RandomPlayers AS (
    SELECT Player_Id
    FROM Player
    ORDER BY RANDOM()
    LIMIT (SELECT FLOOR(RANDOM() * 12) + 6) -- Random number of players (between 6 and 12)
)
-- Step 3: Insert Players into the Tournament Players Table
INSERT INTO Tournament_Players (Tournament_Id, Player_Id)
SELECT t.Tournament_Id, rp.Player_Id
FROM RandomPlayers rp, 
     (SELECT Tournament_Id FROM Tournament ORDER BY Tournament_Id DESC LIMIT 1) t;

-- Step 4: Pair Players for a Round
WITH PairedPlayers AS (
    SELECT 
        ROW_NUMBER() OVER (ORDER BY RANDOM()) AS Pair_Number, -- Randomized pairing
        Player_Id
    FROM 
        Tournament_Players
    WHERE 
        Tournament_Id = :tournament_id -- Replace with the Tournament_Id output received from step 3
)
SELECT 
    p1.Player_Id AS Player1,
    p2.Player_Id AS Player2
FROM 
    PairedPlayers p1
LEFT JOIN 
    PairedPlayers p2
ON 
    p1.Pair_Number = p2.Pair_Number - 1
WHERE 
    p1.Pair_Number % 2 = 1;

-- Step 5: Insert Pairings into Games Table
INSERT INTO Game (Game_Date, Result, Opening_Id)
SELECT 
    CURRENT_TIMESTAMP,  -- Game date
    RANDOM(result_enum),               -- Result (to be updated after the game)
    (SELECT Opening_Id FROM Opening ORDER BY RANDOM() LIMIT 1) -- Random Opening
RETURNING Game_Id;

-- Step 6: Associate Players with Games
WITH PairedPlayers AS (
    SELECT 
        ROW_NUMBER() OVER (ORDER BY RANDOM()) AS Pair_Number,
        Player_Id
    FROM 
        Tournament_Players
    WHERE 
        Tournament_Id = :tournament_id
)
INSERT INTO Game_Players (Game_Id, Player_Id)
SELECT 
    g.Game_Id,
    p.Player_Id
FROM 
    (SELECT Game_Id FROM Game ORDER BY Game_Id DESC LIMIT 1) g,
    PairedPlayers p
WHERE 
    Pair_Number IN (SELECT Pair_Number FROM PairedPlayers WHERE Pair_Number % 2 IN (1, 2));
