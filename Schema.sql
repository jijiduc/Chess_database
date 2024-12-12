-- Table to store player details
CREATE TABLE Player (
    Player_Id SERIAL PRIMARY KEY,
    First_Name VARCHAR NOT NULL,
    Last_Name VARCHAR NOT NULL,
    Age INTEGER,
    Title VARCHAR,
    ELO_Rating INTEGER,
    CONSTRAINT Chk_ELO CHECK(ELO_Rating >= 0),
    CONSTRAINT Chk_Age CHECK(Age BETWEEN 0 AND 99),
    CONSTRAINT Chk_Title CHECK(Title IN ('GM', 'WGM', 'IM', 'WIM', 'FM', 'WFM', 'NM', 'CM', 'WCM', 'WNM') OR Title IS NULL)
);

-- Table to store nationality for players
CREATE TABLE Player_Nationality (
    Player_Id INTEGER,
    Nationality VARCHAR,
    PRIMARY KEY (Player_Id, Nationality),
    FOREIGN KEY (Player_Id) REFERENCES Player(Player_Id)
);

-- Table to store chess openings
CREATE TABLE Opening (
    Opening_Id SERIAL PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    ECO_Code VARCHAR(3),
    Agressiveness BOOLEAN,
    CONSTRAINT Chk_ECO CHECK(LENGTH(ECO_Code) IN (2, 3))
);

-- Table to store club details
CREATE TABLE Club (
    Club_Id SERIAL PRIMARY KEY,
    Club_Name VARCHAR(50) UNIQUE,
    Location VARCHAR
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
    Result ENUM('1-0', '0-1', '1/2-1/2') NOT NULL,
    Opening_Id INTEGER,
    FOREIGN KEY (Opening_Id) REFERENCES Opening(Opening_Id) ON DELETE SET NULL
);

-- Table to store players in games
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
    Name VARCHAR UNIQUE,
    Location VARCHAR,
    Total_Round_Number INT NOT NULL,
    Game_Date TIMESTAMP,
    Format VARCHAR,
    Prize_Pool DECIMAL(15, 2)
);

-- Table to store ranking details in tournaments
CREATE TABLE Tournament_Ranking (
    Tournament_Id INTEGER,
    Rank VARCHAR,
    Player_Name VARCHAR,
    Prize_Money_Won DECIMAL(15, 2),
    PRIMARY KEY (Tournament_Id, Rank),
    FOREIGN KEY (Tournament_Id) REFERENCES Tournament(Tournament_Id)
);
