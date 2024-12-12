INSERT INTO Player (First_Name, Last_Name, Age, Title, Club_Affiliation, Nationality, ELO_Rating)
VALUES 
('Magnus', 'Carlsen', 33, 'GM', 'Lagos Chess Club', 'Norwegian', 2847),
('Viswanathan', 'Anand', 54, 'GM', 'Chennai Chess Club', 'Indian', 2750),
('Hou', 'Yifan', 25, 'GM', 'Beijing Chess Club', 'Chinese', 2600),
('Fabiano', 'Caruana', 31, 'GM', 'St. Louis Chess Club', 'American', 2780),
('Levon', 'Aronian', 41, 'GM', 'Yerevan Chess Club', 'Armenian', 2765),
('Judit', 'Polgár', 47, 'WGM', 'Budapest Chess Club', 'Hungarian', 2700),
('Anish', 'Giri', 29, 'GM', 'Hoogeveen Chess Club', 'Dutch', 2760),
('Nodirbek', 'Abdusattorov', 20, 'GM', 'Tashkent Chess Club', 'Uzbekistani', 2675),
('Kasper', 'Schmidt', 22, 'IM', 'Berlin Chess Club', 'German', 2450),
('Sophie', 'Jones', 18, 'WIM', 'Oxford Chess Club', 'British', 2100),
('Radosław', 'Wojtaszek', 35, 'GM', 'Warsaw Chess Club', 'Polish', 2705),
('Daniil', 'Dubov', 27, 'GM', 'Moscow Chess Club', 'Russian', 2720),
('Alireza', 'Firouzja', 20, 'GM', 'Paris Chess Club', 'Iranian', 2788),
('Zhu', 'Jiner', 24, 'WIM', 'Shanghai Chess Club', 'Chinese', 2300),
('Arjun', 'Erigaisi', 22, 'GM', 'Hyderabad Chess Club', 'Indian', 2595),
('Wei', 'Yi', 19, 'IM', 'Shanghai Chess Club', 'Chinese', 2470),
('Ian', 'Nepomniachtchi', 32, 'GM', 'St. Petersburg Chess Club', 'Russian', 2785),
('Sara', 'Khademalsharieh', 26, 'WIM', 'Tehran Chess Club', 'Iranian', 2485),
('Sam', 'Shankland', 32, 'GM', 'San Francisco Chess Club', 'American', 2675),
('Zahar', 'Zamochkin', 28, 'NM', 'Minsk Chess Club', 'Belarusian', 2400);

INSERT INTO Opening (Name, ECO_Code, Agressiveness)
VALUES 
('Sicilian Defense', 'B40', TRUE),
('Queen''s Gambit', 'D37', FALSE),
('King''s Indian Defense', 'A48', TRUE),
('Ruy Lopez', 'C60', FALSE),
('English Opening', 'A10', FALSE),
('French Defense', 'C00', FALSE),
('Caro-Kann Defense', 'B12', FALSE),
('Scotch Game', 'C45', TRUE),
('Pirc Defense', 'B07', TRUE),
('Petrov''s Defense', 'C42', FALSE),
('Nimzo-Indian Defense', 'E20', FALSE),
('Alekhine Defense', 'B02', TRUE),
('Grünfeld Defense', 'D97', TRUE),
('King''s Gambit', 'C30', TRUE),
('Indian Game', 'A00', TRUE),
('Vienna Game', 'C29', TRUE),
('Benoni Defense', 'A60', TRUE),
('Dutch Defense', 'A80', FALSE),
('Philidor Defense', 'C41', FALSE),
('Modern Defense', 'B06', TRUE);

INSERT INTO Club (Club_Name, Location)
VALUES 
('Lagos Chess Club', 'Lagos, Nigeria'),
('Chennai Chess Club', 'Chennai, India'),
('St. Louis Chess Club', 'St. Louis, USA'),
('Beijing Chess Club', 'Beijing, China'),
('Yerevan Chess Club', 'Yerevan, Armenia'),
('Budapest Chess Club', 'Budapest, Hungary'),
('Moscow Chess Club', 'Moscow, Russia'),
('Hoogeveen Chess Club', 'Hoogeveen, Netherlands'),
('Shanghai Chess Club', 'Shanghai, China'),
('Warsaw Chess Club', 'Warsaw, Poland'),
('Paris Chess Club', 'Paris, France'),
('Tehran Chess Club', 'Tehran, Iran'),
('San Francisco Chess Club', 'San Francisco, USA'),
('Berlin Chess Club', 'Berlin, Germany'),
('Hyderabad Chess Club', 'Hyderabad, India'),
('Oxford Chess Club', 'Oxford, UK'),
('Minsk Chess Club', 'Minsk, Belarus'),
('Tashkent Chess Club', 'Tashkent, Uzbekistan'),
('Belgrade Chess Club', 'Belgrade, Serbia'),
('Lviv Chess Club', 'Lviv, Ukraine');

INSERT INTO Game (Game_Date, Result, Opening_Id)
VALUES 
('2024-01-15 14:30:00', '1-0', 1),  -- Sicilian Defense
('2024-02-05 19:45:00', '0-1', 2),  -- Queen\'s Gambit
('2024-03-10 17:00:00', '1/2-1/2', 3),  -- King\'s Indian Defense
('2024-04-20 11:00:00', '1-0', 4),  -- Ruy Lopez
('2024-05-10 13:00:00', '0-1', 5),  -- English Opening
('2024-06-22 15:00:00', '1/2-1/2', 6),  -- French Defense
('2024-07-04 16:30:00', '1-0', 7),  -- Caro-Kann Defense
('2024-08-15 18:45:00', '0-1', 8),  -- Scotch Game
('2024-09-25 20:00:00', '1-0', 9),  -- Pirc Defense
('2024-10-05 12:00:00', '0-1', 10), -- Petrov\'s Defense
('2024-11-03 14:00:00', '1/2-1/2', 11), -- Nimzo-Indian Defense
('2024-12-01 19:00:00', '1-0', 12), -- Alekhine Defense
('2024-12-10 17:30:00', '0-1', 13), -- Grünfeld Defense
('2024-12-12 16:00:00', '1-0', 14), -- King\'s Gambit
('2024-12-20 14:45:00', '1/2-1/2', 15), -- Indian Game
('2024-12-22 18:00:00', '0-1', 16), -- Vienna Game
('2024-12-25 11:30:00', '1-0', 17), -- Benoni Defense
('2024-12-30 15:00:00', '1/2-1/2', 18), -- Dutch Defense
('2024-12-31 13:00:00', '0-1', 19), -- Philidor Defense
('2024-12-12 20:00:00', '1-0', 20); -- Modern Defense

INSERT INTO Tournament (Name, Location, Game_Date, Format, Prize_Pool)
VALUES 
('World Chess Championship 2024', 'Dubai, UAE', '2024-04-01 15:00:00', 'Classical', '$2,000,000'),
('Sinquefield Cup 2024', 'St. Louis, USA', '2024-08-10 14:00:00', 'Round Robin', '$500,000'),
('Grand Slam Chess Final 2024', 'Madrid, Spain', '2024-06-15 13:30:00', 'Knockout', '$1,000,000'),
('Candidates Tournament 2024', 'London, UK', '2024-07-05 16:00:00', 'Round Robin', '$1,500,000'),
('Chess.com Global Championship 2024', 'Online', '2024-09-01 20:00:00', 'Online Tournament', '$500,000'),
('Tata Steel Chess Tournament 2024', 'Wijk aan Zee, Netherlands', '2024-01-10 12:00:00', 'Round Robin', '$200,000'),
('Grand Prix Chess 2024', 'Moscow, Russia', '2024-05-15 18:30:00', 'Knockout', '$300,000'),
('Copenhagen Chess 2024', 'Copenhagen, Denmark', '2024-02-25 17:00:00', 'Swiss System', '$150,000'),
('FIDE World Cup 2024', 'Baku, Azerbaijan', '2024-03-10 11:00:00', 'Knockout', '$1,200,000'),
('International Chess Festival 2024', 'Paris, France', '2024-12-01 09:00:00', 'Swiss System', '$100,000');

INSERT INTO Tournament_Ranking (Rank, Name, Prize_Money_Won)
VALUES 
('1', 'Magnus Carlsen', '$1,200,000'),
('2', 'Fabiano Caruana', '$800,000'),
('3', 'Ding Liren', '$600,000'),
('4', 'Ian Nepomniachtchi', '$400,000'),
('5', 'Levon Aronian', '$250,000'),
('6', 'Anish Giri', '$150,000'),
('7', 'Hikaru Nakamura', '$120,000'),
('8', 'Maxime Vachier-Lagrave', '$100,000'),
('9', 'Wesley So', '$90,000'),
('10', 'Alireza Firouzja', '$80,000');

INSERT INTO Player_Styles (Player_Id, Opening_Id)
VALUES 
(1, 1),  -- Player 1 (Magnus Carlsen) is associated with Sicilian Defense
(2, 2),  -- Player 2 (Fabiano Caruana) is associated with Queen's Gambit
(3, 3),  -- Player 3 (Ding Liren) is associated with King's Indian Defense
(4, 4),  -- Player 4 (Ian Nepomniachtchi) is associated with Ruy Lopez
(5, 5),  -- Player 5 (Levon Aronian) is associated with English Opening
(6, 6),  -- Player 6 (Anish Giri) is associated with French Defense
(7, 7),  -- Player 7 (Hikaru Nakamura) is associated with Caro-Kann Defense
(8, 8),  -- Player 8 (Maxime Vachier-Lagrave) is associated with Scotch Game
(9, 9),  -- Player 9 (Wesley So) is associated with Pirc Defense
(10, 10), -- Player 10 (Alireza Firouzja) is associated with Petrov's Defense
(1, 12),  -- Player 1 (Magnus Carlsen) is also associated with Alekhine Defense
(2, 15),  -- Player 2 (Fabiano Caruana) is also associated with Indian Game
(3, 18),  -- Player 3 (Ding Liren) is also associated with Dutch Defense
(4, 13),  -- Player 4 (Ian Nepomniachtchi) is also associated with Grünfeld Defense
(5, 14);  -- Player 5 (Levon Aronian) is also associated with King's Gambit

INSERT INTO Club_Players (Club_Id, Player_Id)
VALUES 
(1, 1),  -- Club 1 (Lagos Chess Club) has Player 1 (Magnus Carlsen)
(1, 2),  -- Club 1 (Lagos Chess Club) has Player 2 (Fabiano Caruana)
(2, 3),  -- Club 2 (Chennai Chess Club) has Player 3 (Ding Liren)
(2, 4),  -- Club 2 (Chennai Chess Club) has Player 4 (Ian Nepomniachtchi)
(3, 5),  -- Club 3 (St. Louis Chess Club) has Player 5 (Levon Aronian)
(3, 6),  -- Club 3 (St. Louis Chess Club) has Player 6 (Anish Giri)
(4, 7),  -- Club 4 (Beijing Chess Club) has Player 7 (Hikaru Nakamura)
(4, 8),  -- Club 4 (Beijing Chess Club) has Player 8 (Maxime Vachier-Lagrave)
(5, 9),  -- Club 5 (Yerevan Chess Club) has Player 9 (Wesley So)
(5, 10), -- Club 5 (Yerevan Chess Club) has Player 10 (Alireza Firouzja)
(6, 1),  -- Club 6 (Budapest Chess Club) has Player 1 (Magnus Carlsen)
(7, 2),  -- Club 7 (Moscow Chess Club) has Player 2 (Fabiano Caruana)
(8, 3),  -- Club 8 (Hoogeveen Chess Club) has Player 3 (Ding Liren)
(9, 4),  -- Club 9 (Shanghai Chess Club) has Player 4 (Ian Nepomniachtchi)
(10, 5), -- Club 10 (Warsaw Chess Club) has Player 5 (Levon Aronian)
(11, 6), -- Club 11 (Paris Chess Club) has Player 6 (Anish Giri)
(12, 7), -- Club 12 (Tehran Chess Club) has Player 7 (Hikaru Nakamura)
(13, 8), -- Club 13 (San Francisco Chess Club) has Player 8 (Maxime Vachier-Lagrave)
(14, 9), -- Club 14 (Berlin Chess Club) has Player 9 (Wesley So)
(15, 10); -- Club 15 (Hyderabad Chess Club) has Player 10 (Alireza Firouzja)

