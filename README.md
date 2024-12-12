# Chess Database

## Description

This project is a micro-project for the 201.3 - Relational Database course, lectured by Professor Renault Richardet, is aimed at designing and implementing a relational database centered on chess players, tournaments, and related activities.

---

## Project Objectives

### Idea: A Chess Players Database

This project focuses on organizing and managing data related to chess players, clubs, tournaments, games, and their encounter during tounrnaments. The system aims to provide a structured view of chess data for analysis and tracking purposes.

---

## System Requirements

### **Players Management**

- Information to track:
  - Name
  - Age
  - Title
  - Club affiliation
  - Nationality
  - ELO rating
  - Playing styles

### **Opening Management**

- Detail about the opening
  - ECO code
  - Name
  - agressiveness [Boolean]

### **Clubs Management**

- Details of chess clubs, including:
  - Club name
  - Location
  - Associated players

### **Games Management**

- Essential details for every chess game:
  - Date of the game
  - Players involved
  - Result (win, draw, loss)
  - Opening played

### **Tournament Management**

- Tournaments details to include:
  - Name
  - Location
  - Dates
  - Format (e.g., round-robin, knockout, swiss)
  - Prize pool

### **Ranking of tournament Management**

- Tournaments ranking details to include:
   - rank
   - name
   - prize money won


---

## Project Description

### Project Title

**Chess Database**

### Organization and Purpose

The Chess Database provides an organized structure to store and query chess-related data. It is designed to assist players, clubs, and tournament organizers by offering:

- A clear record of players and their achievements.
- A historical log of tournaments and games.
- Insights into player performance trends.


### Unique Features

- Have a scheduling system for tournament, incrementive pairing round by round and final solution.
- Have a ranking feature for tournament final results, 

---

## Challenges and Scope

### Expected Challenges

- Designing relationships between players, games, and tournaments effectively.
- Normalizing data while retaining query performance.

### Scope of Modeling

- **Will model:**
  - Players, games, tournaments, and performance tracking.
  - Club affiliations and tournament results.
  - Financial details (e.g., prize payouts).
  - Scheduling systems for tournaments or games.
- **Will not model:**
  - game moves database

---

## Familiarity and Motivation

As chess enthusiasts, this project combines personal interest with practical database design skills. Our motivation lies in creating a system that can offer insights into a pseudo chess world, such as player performance, gains and tournaments results.

### Data Availability

- Initial data can be simulated or sourced from freely available chess tournament records and player databases online, for example TWIC. Probable adaptation may need to be done. If necessary, generated datas will be used to populated the tables.
