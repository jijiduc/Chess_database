# Chess Database

## Description

This project is a micro-project for the 201.3 - Relational Database course, lectured by Professor Renaud Richardet. It is aimed at designing and implementing a relational database centered on chess players, tournaments, and related activities.

---

## Project Objectives

### Idea: A Chess Players Database

This project focuses on organizing and managing data related to chess players, clubs, tournaments, games, and their encounters during tournaments. The system provides a structured view of chess data for analysis and tracking purposes.

---

## System Requirements

### **Title management**

- Details of titles
  - Title code
  - Title name
  - Title description
  - Elo necessary for title

### **Players Management**

- Information tracked:
  - First Name
  - Last Name
  - Age
  - ELO Rating
  - Playing styles

### **Country management**

- Details for countries management
  - Country name
  - Start date (when the player started representing this country)

### **Opening Management**

- Details about chess openings:
  - ECO Code
  - Name
  - Aggressiveness (Boolean)

### **Clubs Management**

- Details of chess clubs:
  - Club Name
  - Location

### **Games Management**

- Essential details for every chess game:
  - Date of the game
  - Players involved
  - Result (win, draw, loss)
  - Opening played

### **Tournament Management**

- Details of tournaments:
  - Name
  - Location
  - Total number of rounds
  - Format (e.g., round-robin, knockout, Swiss)
  - Prize pool

### **Tournament Ranking Management**

- Details of tournament rankings:
  - Rank
  - Player Name
  - Prize Money Won

---

## Project Description

### Project Title

Chess Database

### Organization and Purpose

The Chess Database provides an organized structure to store and query chess-related data. It's designed to create tournaments and keep records of results:

- A clear record of players and their achievements.
- A historical log of tournaments and games.
- Insights into player performance trends.

---

## Database Normalization Analysis

The database is designed to be in Third Normal Form (3NF). Here's the analysis of how it meets the normalization requirements:

### First Normal Form (1NF)

- All tables have a primary key
  - Player table has atomic columns for First_Name, Last_Name, Age, etc.
- Each column contains atomic values
  - Multiple nationalities are handled in a separate Player_Nationality table
- No repeating groups
  - Multiple player styles are handled in a separate Player_Styles table

### Second Normal Form (2NF)

Meets 1NF requirements and no partial dependencies on the primary key
Examples:

- Game_Players table only contains the Game_Id and Player_Id, with other player information stored in the Player table
- Tournament_Players table only contains Tournament_Id and Player_Id relationships
- Club_Players table maintains only the club-player relationships

### Third Normal Form (3NF)

Meets 2NF requirements and no transitive dependencies
Examples:

- Player information is separated from nationality (Player_Nationality table)
- Opening information is separated from games (Opening table)
- Tournament rankings are separated from tournament details (Tournament_Ranking table)
- Game details are normalized with round numbers and game numbers within rounds
- Club information is separated from player details

### Key Design Decisions for 3NF

Player-Related Information:

- Core player details in Player table
- Separate tables for nationalities and styles
- No redundant storage of calculated data

Game Management:

- Games are uniquely identified within tournaments using round_number and round_game_number
- Opening selections are stored as references to the Opening table
- Results are stored with proper constraints

Tournament Structure:

- Tournament details separated from rankings
- Prize money calculations handled through functions
- Clear separation of tournament-player relationships

Referential Integrity:

- Proper foreign key constraints throughout
- Cascade deletions where appropriate
- Null handling for optional relationships

---

## Database Indexes

The following describes the indexes implemented in the chess database to optimize query performance.

### Player Index

```CREATE INDEX idx_player ON Player(ELO_Rating);```

This index optimizes queries that filter or sort players by their ELO rating. It's particularly useful for:

- Tournament pairing systems that need to match players of similar strength
- Ranking queries that sort players by rating
- Statistics and analytics involving player ratings

### Tournament Index

```CREATE INDEX idx_tournament ON Tournament(Tournament_Id);```

Improves performance for:

- Looking up specific tournaments
- Joining tournament data with games and players
- Tournament-specific statistics and results

### Game Players Index

```CREATE INDEX idx_game ON Game_Players(Player_Id, Game_Id);```

Enhances performance for:

- Finding all games played by a specific player
- Player performance analysis

### Player Country Indexes

```CREATE INDEX idx_player_country_player ON Player_Country(Player_Id);```

```CREATE INDEX idx_player_country_country ON Player_Country(Country_Id);```

These indexes improve performance for:

- Finding all players from a specific country
- Determining a player's country/nationality
- Country-based statistics and filters

### Country Name Index

```CREATE INDEX idx_country_name ON Country(Name);```

Optimizes:

- Looking up countries by name
- Country-based filtering and grouping
- Geographic analysis of players and tournaments

### Index Usage in Swiss Pairing System

The indexes play a crucial role in the Swiss pairing system:

- The idx_player index helps quickly sort and group players by rating within score brackets
- The idx_game index efficiently checks previous pairings to avoid rematches
- The tournament index helps retrieve all games and standings for the current tournament quickly

These indexes significantly improve the performance of:

- Score calculations
- Previous pairing checks
- Color balance determinations
- Player grouping by score brackets

### Features

- A scheduling system for tournaments, with incremental pairing round by round and final standings.
- A ranking feature for tournament results.
- Openings are randomly selected for each game
- Game Numbering System in format: Round_Number.Round_Game_Number
- Tiebreaks classification using Bucholz and Performance metrics

---

## Challenges and Scope

### Challenges encountered

- Designing relationships between players, games, and tournaments effectively.
- Normalizing data while retaining query performance.
- Disigning working functions to simulate a tournanement in swiss format

### Scope of Modeling

- **Modeled:**
  - Players, games, tournaments, and performance tracking.
  - Financial details (prize money payouts).
  - Scheduling systems for tournaments in a swiss manner.
- **Not Modeled:**
  - A detailed moves database for chess games.

---

## Familiarity and Motivation

As chess enthusiasts, this project combines personal interest with practical database design skills. The motivation lies in creating a system that offers insights into a pseudo chess world, such as player performance, gains, and tournament results.

### Data Availability

Populating datas for the players and clubs have been generated based on reality. The opening datas are taken from the international ECO chess opening classification.
