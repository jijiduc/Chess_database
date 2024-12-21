# Chess Database

## Description

This project is a micro-project for the 201.3 - Relational Database course, lectured by Professor Renaud Richardet. It is aimed at designing and implementing a relational database centered on chess players, tournaments, and related activities.

---

## Project Objectives

### Idea: A Chess Players Database

This project focuses on organizing and managing data related to chess players, clubs, tournaments, games, and their encounters during tournaments. The system provides a structured view of chess data for analysis and tracking purposes.

---

## System Requirements

### **Players Management**

- Information tracked:
  - First Name
  - Last Name
  - Age
  - Title (e.g., GM, IM, FM, etc.)
  - ELO Rating
  - Nationality
  - Playing styles

### **Opening Management**

- Details about chess openings:
  - ECO Code
  - Name
  - Aggressiveness (Boolean)

### **Clubs Management**

- Details of chess clubs:
  - Club Name
  - Location
  - Associated Players

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

The Chess Database provides an organized structure to store and query chess-related data. It assists players, clubs, and tournament organizers by offering:

- A clear record of players and their achievements.
- A historical log of tournaments and games.
- Insights into player performance trends.

### Database Normalization Analysis

The database is designed to be in Third Normal Form (3NF). Here's the analysis of how it meets the normalization requirements:

#### First Normal Form (1NF)

- All tables have a primary key
  - Player table has atomic columns for First_Name, Last_Name, Age, etc.
- Each column contains atomic values
  - Multiple nationalities are handled in a separate Player_Nationality table
- No repeating groups
  - Multiple player styles are handled in a separate Player_Styles table

#### Second Normal Form (2NF)

Meets 1NF requirements and no partial dependencies on the primary key
Examples:

- Game_Players table only contains the Game_Id and Player_Id, with other player information stored in the Player table
- Tournament_Players table only contains Tournament_Id and Player_Id relationships
- Club_Players table maintains only the club-player relationships

#### Third Normal Form (3NF)

Meets 2NF requirements and no transitive dependencies
Examples:

- Player information is separated from nationality (Player_Nationality table)
- Opening information is separated from games (Opening table)
- Tournament rankings are separated from tournament details (Tournament_Ranking table)
- Game details are normalized with round numbers and game numbers within rounds
- Club information is separated from player details

#### Key Design Decisions for 3NF

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

### Features

- A scheduling system for tournaments, with incremental pairing round by round and final standings.
- A ranking feature for tournament results.
- Openings are randomly selected for each game
- Game Numbering System : Each game in a tournament round has a unique identifier in format: Round_Number.Round_Game_Number.

---

## Challenges and Scope

### Expected Challenges

- Designing relationships between players, games, and tournaments effectively.
- Normalizing data while retaining query performance.

### Scope of Modeling

- **Modeled:**
  - Players, games, tournaments, and performance tracking.
  - Club affiliations and tournament results.
  - Financial details (e.g., prize payouts).
  - Scheduling systems for tournaments or games.
- **Not Modeled:**
  - A detailed moves database for chess games.

---

## Familiarity and Motivation

As chess enthusiasts, this project combines personal interest with practical database design skills. The motivation lies in creating a system that offers insights into a pseudo chess world, such as player performance, gains, and tournament results.

### Data Availability

Initial data will be simulated or sourced from freely available chess tournament records and player databases online, such as TWIC. If necessary, generated data will be used to populate the tables.
