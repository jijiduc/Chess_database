CREATE TABLE Player (
    Player_Id SERIAL PRIMARY KEY,
    First_Name VARCHAR,
    Last_Name VARCHAR,
    Age INTEGER,
    Title VARCHAR,
    Club_Affiliation VARCHAR,
    Nationality VARCHAR,
    ELO_Rating INTEGER,
    -- Playing_Styles
    CONSTRAINT Chk_ELO CHECK(ELO_Rating >= 0),
    CONSTRAINT Chk_Age CHECK(Age BETWEEN 0 AND 99),
    CONSTRAINT Chk_Title CHECK(Title IN ('GM','WGM','IM','WIM','FM','WFM','NM','CM','WCM','WNM') OR Title IS NULL),
);

CREATE TABLE Player_Styles (
    Player_Id INTEGER,
    Opening_Id INTEGER,
    PRIMARY KEY (Player_Id,Opening_Id)
)

CREATE TABLE Opening (
    Opening_Id SERIAL PRIMARY KEY,
    Name VARCHAR,
    ECO_Code VARCHAR(3),
    Agressiveness BOOLEAN,
    CONSTRAINT Chk_ECO CHECK(LENGTH(ECO_Code) IN (2,3)),
)

CREATE TABLE Club (
    Club_Id SERIAL PRIMARY KEY,
    Club_Name VARCHAR,
    Location VARCHAR
);

CREATE TABLE Club_Players (
    Club_Id INTEGER,
    Player_Id INTEGER,
    PRIMARY KEY(Club_Id,Player_Id)
);

CREATE TABLE Game (
    Game_Id SERIAL PRIMARY KEY,
    Game_Date DATETIME,
    Result VARCHAR,
    Opening_Id INTEGER
    CONSTRAINT fk_opening FOREIGN KEY (Opening_Id) REFERENCES Opening(Opening_Id)
);

CREATE TABLE Game_Players (
    Game_Id INTEGER,
    Player_Id INTEGER,
    PRIMARY KEY(Game_Id,Player_Id)
);

CREATE TABLE Tournament (
    Tournament_Id SERIAL PRIMARY KEY
    Name VARCHAR,
    Location VARCHAR,
    Game_Date TIMESTAMP,
    Format VARCHAR,
    Prize_Pool VARCHAR
);

CREATE TABLE Tournament_Ranking (
    Rank VARCHAR,
    Name VARCHAR,
    Prize_Money_Won MONEY
);
