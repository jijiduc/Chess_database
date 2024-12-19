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

### Unique Features

- A scheduling system for tournaments, with incremental pairing round by round and final standings.
- A ranking feature for tournament results.

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
