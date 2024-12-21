

-- Table to store player details
CREATE TABLE Player (
    Player_Id SERIAL PRIMARY KEY,
    First_Name VARCHAR(50) NOT NULL, -- Maximum 50 characters for the first name
    Last_Name VARCHAR(50) NOT NULL,  -- Maximum 50 characters for the last name
    Age INTEGER,
    Title VARCHAR(10),               -- Maximum 10 characters (e.g., GM, IM, etc.)
    ELO_Rating INTEGER,
    CONSTRAINT Chk_ELO CHECK(ELO_Rating >= 0),
    CONSTRAINT Chk_Age CHECK(Age BETWEEN 0 AND 99),
    CONSTRAINT Chk_Title CHECK(Title IN ('GM', 'WGM', 'IM', 'WIM', 'FM', 'WFM', 'NM', 'CM', 'WCM', 'WNM') OR Title IS NULL)
);

-- Table to store player nationalities
CREATE TABLE Player_Nationality (
    Player_Id INTEGER,
    Nationality VARCHAR(50),         -- Maximum 50 characters for nationality
    PRIMARY KEY (Player_Id, Nationality),
    FOREIGN KEY (Player_Id) REFERENCES Player(Player_Id)
);

-- Table to store chess openings
CREATE TABLE Opening (
    Opening_Id SERIAL PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,      -- Maximum 100 characters for opening name
    ECO_Code VARCHAR(3),             -- ECO code is typically 2-3 characters
    Agressiveness BOOLEAN,
    CONSTRAINT Chk_ECO CHECK(LENGTH(ECO_Code) IN (2, 3))
);

-- Table to store club details
CREATE TABLE Club (
    Club_Id SERIAL PRIMARY KEY,
    Club_Name VARCHAR(100) UNIQUE,   -- Maximum 100 characters for club name
    Location VARCHAR(100)            -- Maximum 100 characters for location
);

-- Table to store styles associated with players
CREATE TABLE Player_Styles (
    Player_Id INTEGER,
    Opening_Id INTEGER,
    PRIMARY KEY (Player_Id, Opening_Id),
    FOREIGN KEY (Player_Id) REFERENCES Player(Player_Id) ON DELETE CASCADE,
    FOREIGN KEY (Opening_Id) REFERENCES Opening(Opening_Id) ON DELETE CASCADE
);

-- Table to store player-club associations
CREATE TABLE Club_Players (
    Club_Id INTEGER,
    Player_Id INTEGER,
    PRIMARY KEY (Club_Id, Player_Id),
    FOREIGN KEY (Club_Id) REFERENCES Club(Club_Id) ON DELETE CASCADE,
    FOREIGN KEY (Player_Id) REFERENCES Player(Player_Id) ON DELETE CASCADE
);

-- Table to store chess game details
CREATE TABLE Game (
    Game_Id SERIAL PRIMARY KEY,
    Game_Date TIMESTAMP,
    Round_number INTEGER,
    Player_white_Id INTEGER,
    Player_black_Id INTEGER,
    result VARCHAR(7) NOT NULL, -- Stores the game result
    Opening_Id INTEGER,
    CONSTRAINT Chk_result CHECK (result IN ('1-0', '0-1', '1/2-1/2')),
    FOREIGN KEY (Opening_Id) REFERENCES Opening(Opening_Id) ON DELETE SET NULL
);

-- Table to store players participating in games
CREATE TABLE Game_Players (
    Game_Id INTEGER,
    Player_Id INTEGER,
    PRIMARY KEY (Game_Id, Player_Id),
    FOREIGN KEY (Game_Id) REFERENCES Game(Game_Id) ON DELETE CASCADE,
    FOREIGN KEY (Player_Id) REFERENCES Player(Player_Id) ON DELETE CASCADE
);

-- Table to store tournament details
CREATE TABLE Tournament (
    Tournament_Id SERIAL PRIMARY KEY,
    Name VARCHAR(100) UNIQUE,        -- Maximum 100 characters for tournament name
    Location VARCHAR(100),           -- Maximum 100 characters for location
    Total_Round_Number INT NOT NULL, -- Number of rounds in the tournament
    Game_Date TIMESTAMP,
    Format VARCHAR(50),              -- Maximum 50 characters for tournament format
    Prize_Pool DECIMAL(15, 2)        -- Prize pool with 2 decimal places
);

-- Table to store ranking details in tournaments
CREATE TABLE Tournament_Ranking (
    Tournament_Id INTEGER,
    Rank INT,                        -- Rank of the player in the tournament
    Player_Name VARCHAR(50),         -- Maximum 50 characters for player name
    Prize_Money_Won DECIMAL(15, 2),  -- Prize money with 2 decimal places
    PRIMARY KEY (Tournament_Id, Rank),
    FOREIGN KEY (Tournament_Id) REFERENCES Tournament(Tournament_Id)
);

-- Create Tournament_Players Table
CREATE TABLE Tournament_Players (
    Tournament_Id INTEGER NOT NULL,
    Player_Id INTEGER NOT NULL,
    PRIMARY KEY (Tournament_Id, Player_Id),
    FOREIGN KEY (Tournament_Id) REFERENCES Tournament(Tournament_Id) ON DELETE CASCADE,
    FOREIGN KEY (Player_Id) REFERENCES Player(Player_Id) ON DELETE CASCADE
);

-- Function to calculate win probability with increased ELO weight
CREATE OR REPLACE FUNCTION calculate_win_probability(white_elo INTEGER, black_elo INTEGER) 
RETURNS NUMERIC AS $$
DECLARE
    elo_difference NUMERIC;
    win_probability NUMERIC;
    elo_weight NUMERIC := 2.0; -- Amplification factor for ELO difference
BEGIN
    -- Calculate ELO difference
    elo_difference := white_elo - black_elo;
    
    -- Modified ELO probability calculation with increased weight
    -- By multiplying the ELO difference by elo_weight, we make the rating difference
    -- have a stronger impact on the probability
    win_probability := 1 / (1 + POWER(10, (-elo_difference * elo_weight) / 400.0));
    
    RETURN win_probability;
END;
$$ LANGUAGE plpgsql;

-- Function to generate game result with reduced randomness
CREATE OR REPLACE FUNCTION generate_game_result(
    white_player_id INTEGER, 
    black_player_id INTEGER
) RETURNS VARCHAR(7) AS $$
DECLARE
    white_elo INTEGER;
    black_elo INTEGER;
    win_probability NUMERIC;
    random_factor NUMERIC;
    adjusted_probability NUMERIC;
    result VARCHAR(7);
    random_weight NUMERIC := 0.2; -- Weight for random factor (20% influence)
BEGIN
    -- Retrieve ELO ratings for both players with default of 1500 if null
    SELECT COALESCE(ELO_Rating, 1500) INTO white_elo 
    FROM Player 
    WHERE Player_Id = white_player_id;
    
    SELECT COALESCE(ELO_Rating, 1500) INTO black_elo 
    FROM Player 
    WHERE Player_Id = black_player_id;
    
    -- Calculate base win probability for white player
    win_probability := calculate_win_probability(white_elo, black_elo);
    
    -- Generate random factor with reduced influence
    random_factor := RANDOM();
    
    -- Combine ELO-based probability with reduced random factor
    -- Formula: (ELO_weight * win_probability + random_weight * random_factor) / (ELO_weight + random_weight)
    -- This ensures that ELO has 80% influence while randomness only has 20%
    adjusted_probability := (win_probability * (1 - random_weight) + random_factor * random_weight);
    
    -- Adjusted thresholds for more decisive results
    -- Draw probability is reduced to 10% of the original window
    IF adjusted_probability > 0.55 THEN
        -- White wins (higher threshold for more ELO-based decisions)
        result := '1-0';
    ELSIF adjusted_probability < 0.45 THEN
        -- Black wins (lower threshold for more ELO-based decisions)
        result := '0-1';
    ELSE
        -- Draw (narrower window makes draws less common)
        result := '1/2-1/2';
    END IF;
    
    RETURN result;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION create_tournament(
    tournament_name VARCHAR(100), 
    tournament_location VARCHAR(100), 
    total_rounds INT, 
    tournament_format VARCHAR(50), 
    total_prize_pool DECIMAL(15,2)
) RETURNS INTEGER AS $$
DECLARE
    new_tournament_id INTEGER;
    min_players INTEGER;
    max_players CONSTANT INTEGER := 12;
    selected_players_count INTEGER;
    adjusted_player_count INTEGER;
BEGIN
    -- Set minimum players to be equal to number of rounds
    min_players := total_rounds;

    -- Validate input parameters
    IF total_rounds < 3 OR total_rounds > 10 THEN
        RAISE EXCEPTION 'Tournament rounds must be between 3 and 10';
    END IF;

    -- Validate that min_players doesn't exceed max_players
    IF min_players > max_players THEN
        RAISE EXCEPTION 'Number of rounds (%) exceeds maximum allowed players (%). Please reduce the number of rounds.', min_players, max_players;
    END IF;

    -- Ensure unique tournament name
    IF EXISTS (SELECT 1 FROM Tournament WHERE Name = tournament_name) THEN
        RAISE EXCEPTION 'Tournament name must be unique';
    END IF;

    -- Create the tournament
    INSERT INTO Tournament (
        Name, 
        Location, 
        Total_Round_Number, 
        Game_Date, 
        Format, 
        Prize_Pool
    )
    VALUES (
        tournament_name, 
        tournament_location, 
        total_rounds, 
        CURRENT_TIMESTAMP, 
        tournament_format, 
        total_prize_pool
    )
    RETURNING Tournament_Id INTO new_tournament_id;

    -- Count available players
    SELECT COUNT(*) INTO selected_players_count
    FROM Player
    WHERE ELO_Rating IS NOT NULL;

    -- Ensure we have enough players
    IF selected_players_count < min_players THEN
        -- Clean up the created tournament
        DELETE FROM Tournament WHERE Tournament_Id = new_tournament_id;
        RAISE EXCEPTION 'Not enough players with ELO ratings to create tournament. Need at least % players, but only have %.', 
                       min_players, selected_players_count;
    END IF;

    -- Calculate number of players to select
    -- First ensure it's at least min_players
    -- Then ensure it's no more than max_players
    -- Finally ensure it's even by rounding up to next even number
    adjusted_player_count := LEAST(
        max_players,
        GREATEST(
            min_players,
            -- Generate a random number between min_players and max_players
            (SELECT FLOOR(RANDOM() * (max_players - min_players + 1)) + min_players)
        )
    );
    -- Make sure it's even by rounding up if odd
    adjusted_player_count := adjusted_player_count + (adjusted_player_count % 2);

    -- Randomly select players
    WITH RandomPlayers AS (
        SELECT Player_Id
        FROM Player
        WHERE ELO_Rating IS NOT NULL
        ORDER BY RANDOM()
        LIMIT adjusted_player_count
    )
    -- Insert selected players into the tournament
    INSERT INTO Tournament_Players (Tournament_Id, Player_Id)
    SELECT new_tournament_id, Player_Id
    FROM RandomPlayers;

    -- Get the final count of selected players
    GET DIAGNOSTICS selected_players_count = ROW_COUNT;

    -- Validate final player count
    IF selected_players_count < min_players OR selected_players_count % 2 != 0 THEN
        -- Clean up the created tournament
        DELETE FROM Tournament WHERE Tournament_Id = new_tournament_id;
        RAISE EXCEPTION 'Failed to select appropriate number of players. Selected: %. Needed: even number >= %', 
                       selected_players_count, min_players;
    END IF;

    RETURN new_tournament_id;
END;
$$ LANGUAGE plpgsql;

-- Function to pair players for round (fixed version)
CREATE OR REPLACE FUNCTION pair_players_for_round(
    input_tournament_id INTEGER, 
    current_round INTEGER
) RETURNS TABLE(white_player_id INTEGER, black_player_id INTEGER, selected_opening_id INTEGER) AS $$
BEGIN
    RETURN QUERY
    WITH PlayerStandings AS (
        SELECT 
            tp.Player_Id, 
            COALESCE(
                (SELECT COUNT(*) 
                 FROM Game g
                 JOIN Game_Players gp ON g.Game_Id = gp.Game_Id
                 WHERE gp.Player_Id = tp.Player_Id 
                   AND g.Game_Id IN (
                       SELECT DISTINCT g2.Game_Id 
                       FROM Game g2
                       JOIN Game_Players gp2 ON g2.Game_Id = gp2.Game_Id
                       JOIN Tournament_Players tp2 ON gp2.Player_Id = tp2.Player_Id
                       WHERE tp2.Tournament_Id = input_tournament_id
                   )
                   AND ((g.Player_white_Id = tp.Player_Id AND g.result = '1-0')
                    OR (g.Player_black_Id = tp.Player_Id AND g.result = '0-1'))), 0) as wins,
            COALESCE(
                (SELECT COUNT(*) 
                 FROM Game g
                 JOIN Game_Players gp ON g.Game_Id = gp.Game_Id
                 WHERE gp.Player_Id = tp.Player_Id 
                   AND g.Game_Id IN (
                       SELECT DISTINCT g2.Game_Id 
                       FROM Game g2
                       JOIN Game_Players gp2 ON g2.Game_Id = gp2.Game_Id
                       JOIN Tournament_Players tp2 ON gp2.Player_Id = tp2.Player_Id
                       WHERE tp2.Tournament_Id = input_tournament_id
                   )
                   AND g.result = '1/2-1/2'), 0) as draws
        FROM Tournament_Players tp
        WHERE tp.Tournament_Id = input_tournament_id
    ),
    RankedPlayers AS (
        SELECT 
            Player_Id, 
            (wins * 1.0 + draws * 0.5) as score,
            wins,
            draws,
            ROW_NUMBER() OVER (ORDER BY (wins * 1.0 + draws * 0.5) DESC, Player_Id) as ranking
        FROM PlayerStandings
    ),
    PotentialPairings AS (
        SELECT 
            r1.Player_Id as white_player,
            r2.Player_Id as black_player,
            (SELECT o.Opening_Id FROM Opening o ORDER BY RANDOM() LIMIT 1) as opening,
            ROW_NUMBER() OVER () as pair_number
        FROM RankedPlayers r1
        JOIN RankedPlayers r2 ON r1.ranking < r2.ranking
        WHERE MOD(r1.ranking, 2) = 1 
          AND r2.ranking = r1.ranking + 1
          AND NOT EXISTS (
              SELECT 1 
              FROM Game g
              WHERE (g.Player_white_Id = r1.Player_Id AND g.Player_black_Id = r2.Player_Id)
                 OR (g.Player_white_Id = r2.Player_Id AND g.Player_black_Id = r1.Player_Id)
                 AND g.Game_Id IN (
                     SELECT DISTINCT g2.Game_Id 
                     FROM Game g2
                     JOIN Game_Players gp2 ON g2.Game_Id = gp2.Game_Id
                     JOIN Tournament_Players tp2 ON gp2.Player_Id = tp2.Player_Id
                     WHERE tp2.Tournament_Id = input_tournament_id
                 )
          )
    )
    SELECT 
        white_player,
        black_player,
        opening
    FROM PotentialPairings;
END;
$$ LANGUAGE plpgsql;

-- Updated create_tournament_games_with_results function
CREATE OR REPLACE FUNCTION create_tournament_games_with_results(
    input_tournament_id INTEGER,
    current_round INTEGER
) RETURNS VOID AS $$
DECLARE
    pair_record RECORD;
    game_result VARCHAR(7);
    new_game_id INTEGER;
BEGIN
    -- Validate tournament exists
    IF NOT EXISTS (SELECT 1 FROM Tournament WHERE Tournament_Id = input_tournament_id) THEN
        RAISE EXCEPTION 'Tournament with ID % does not exist', input_tournament_id;
    END IF;

    -- Create games for paired players
    FOR pair_record IN 
        SELECT * FROM pair_players_for_round(input_tournament_id, current_round)
    LOOP
        -- Generate game result based on ELO ratings
        game_result := generate_game_result(
            pair_record.white_player_id,
            pair_record.black_player_id
        );
        
        -- Insert game with ELO-weighted result
        INSERT INTO Game (
            Game_Date, 
            Player_white_Id, 
            Player_black_Id, 
            Result, 
            Opening_Id
        ) VALUES (
            CURRENT_TIMESTAMP, 
            pair_record.white_player_id, 
            pair_record.black_player_id, 
            game_result,
            pair_record.selected_opening_id
        ) RETURNING Game_Id INTO new_game_id;

        -- Insert players into Game_Players table
        INSERT INTO Game_Players (Game_Id, Player_Id)
        VALUES 
            (new_game_id, pair_record.white_player_id),
            (new_game_id, pair_record.black_player_id);
    END LOOP;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION finalize_tournament_rankings(input_tournament_id INTEGER) RETURNS VOID AS $$
DECLARE
    total_prize_pool DECIMAL(15,2);
    total_players INTEGER;
    base_factor DECIMAL;
    sum_of_factors DECIMAL;
BEGIN
    -- Validate tournament exists
    IF NOT EXISTS (SELECT 1 FROM Tournament WHERE Tournament_Id = input_tournament_id) THEN
        RAISE EXCEPTION 'Tournament with ID % does not exist', input_tournament_id;
    END IF;

    -- Get total prize pool
    SELECT Prize_Pool INTO total_prize_pool 
    FROM Tournament 
    WHERE Tournament_Id = input_tournament_id;

    -- Get total number of players
    SELECT COUNT(*) INTO total_players
    FROM Tournament_Players
    WHERE Tournament_Id = input_tournament_id;

    -- Calculate base factor for geometric progression (0.75 provides a good distribution)
    base_factor := 0.75;
    
    -- Calculate sum of geometric progression factors for normalization
    -- Sum = 1 + r + r^2 + r^3 + ... + r^(n-1) where r is base_factor and n is total_players
    SELECT SUM(POWER(base_factor, generate_series::DECIMAL - 1))
    INTO sum_of_factors
    FROM generate_series(1, total_players);

    -- Clear any existing rankings for this tournament
    DELETE FROM Tournament_Ranking 
    WHERE Tournament_Id = input_tournament_id;

    -- Calculate final rankings based on performance
    WITH PlayerStandings AS (
        SELECT 
            tp.Player_Id, 
            p.First_Name || ' ' || p.Last_Name as Player_Name,
            COALESCE(
                (SELECT COUNT(*) 
                 FROM Tournament_Players tp_inner
                 JOIN Game_Players gp ON tp_inner.Player_Id = gp.Player_Id
                 JOIN Game g ON gp.Game_Id = g.Game_Id
                 WHERE tp_inner.Player_Id = tp.Player_Id 
                   AND tp_inner.Tournament_Id = input_tournament_id
                   AND ((g.Player_white_Id = tp.Player_Id AND g.result = '1-0')
                    OR (g.Player_black_Id = tp.Player_Id AND g.result = '0-1'))), 0) as wins,
            COALESCE(
                (SELECT COUNT(*) 
                 FROM Tournament_Players tp_inner
                 JOIN Game_Players gp ON tp_inner.Player_Id = gp.Player_Id
                 JOIN Game g ON gp.Game_Id = g.Game_Id
                 WHERE tp_inner.Player_Id = tp.Player_Id 
                   AND tp_inner.Tournament_Id = input_tournament_id
                   AND g.result = '1/2-1/2'), 0) as draws
        FROM Tournament_Players tp
        JOIN Player p ON tp.Player_Id = p.Player_Id
        WHERE tp.Tournament_Id = input_tournament_id
    ),
    RankedPlayers AS (
        SELECT 
            Player_Id, 
            Player_Name,
            (wins * 1.0 + draws * 0.5) as total_score,
            ROW_NUMBER() OVER (
                ORDER BY 
                    (wins * 1.0 + draws * 0.5) DESC, 
                    Player_Id
            ) as tournament_rank
        FROM PlayerStandings
    )
    -- Insert rankings with progressive prize money distribution
    INSERT INTO Tournament_Ranking (
        Tournament_Id, 
        Rank, 
        Player_Name, 
        Prize_Money_Won
    )
    SELECT 
        input_tournament_id, 
        tournament_rank, 
        Player_Name,
        ROUND(
            (total_prize_pool * POWER(base_factor, tournament_rank::DECIMAL - 1)) / sum_of_factors,
            2
        ) as Prize_Money_Won
    FROM RankedPlayers
    ORDER BY tournament_rank;
END;
$$ LANGUAGE plpgsql;

-- Simulate entire tournament
CREATE OR REPLACE FUNCTION simulate_tournament(
    tournament_name VARCHAR(100),
    tournament_location VARCHAR(100),
    total_rounds INTEGER,
    prize_pool DECIMAL(15,2)
) RETURNS INTEGER AS $$
DECLARE
    tournament_id INTEGER;
    round_number INTEGER;
BEGIN
    -- Create tournament with input parameters
    tournament_id := create_tournament(
        tournament_name, 
        tournament_location, 
        total_rounds, 
        'Swiss', 
        prize_pool
    );
    
    -- Simulate each round
    FOR round_number IN 1..total_rounds LOOP
        -- Create and play games for the round
        PERFORM create_tournament_games_with_results(tournament_id, round_number);
    END LOOP;
    
    -- Finalize tournament rankings
    PERFORM finalize_tournament_rankings(tournament_id);
    
    RETURN tournament_id;
END;
$$ LANGUAGE plpgsql;

-- Index creation
CREATE INDEX idx_player
ON Player(ELO_Rating);  -- Added semicolon

CREATE INDEX idx_tournament
ON Tournament(Tournament_Id);  -- Added semicolon

CREATE INDEX idx_game
ON Game_Players(Player_Id,Game_Id);  -- Added semicolon