-- Insert players with age and ELO rating
INSERT INTO Player (First_Name, Last_Name, Age, Title, ELO_Rating)
VALUES 
('Magnus', 'Carlsen', 33, 'GM', 2831), 
('Fabiano', 'Caruana', 32, 'GM', 2803),
('Hikaru', 'Nakamura', 36, 'GM', 2802),
('Arjun', 'Erigaisi', 20, 'GM', 2800),
('Gukesh', 'Dommaraju', 18, 'GM', 2776),
('Nodirbek', 'Abdusattorov', 19, 'GM', 2767),
('Alireza', 'Firouzja', 20, 'GM', 2763),
('Ian', 'Nepomniachtchi', 33, 'GM', 2753),
('Yi', 'Wei', 24, 'GM', 2750),
('Viswanathan', 'Anand', 54, 'GM', 2750),
('Levon', 'Aronian', 41, 'GM', 2747),
('Wesley', 'So', 30, 'GM', 2747),
('Dominguez', 'Perez', 41, 'GM', 2741),
('Praggnanandhaa', 'R', 18, 'GM', 2740),
('Jan-Krzysztof', 'Duda', 26, 'GM', 2740),
('Quang Liem', 'Le', 32, 'GM', 2739),
('Liren', 'Ding', 31, 'GM', 2734),
('Hans', 'Niemann', 21, 'GM', 2734),
('Vincent', 'Keymer', 19, 'GM', 2733),
('Maxime', 'Vachier-Lagrave', 33, 'GM', 2732),
('Shakhriyar', 'Mamedyarov', 39, 'GM', 2732),
('Anish', 'Giri', 30, 'GM', 2730),
('Chithambaram', 'Aravindh', 24, 'GM', 2725),
('Santosh', 'Vidit', 29, 'GM', 2721),
('Richard', 'Rapport', 28, 'GM', 2721),
('Veselin', 'Topalov', 49, 'GM', 2717),
('Yangyi', 'Yu', 29, 'GM', 2715),
('Vladimir', 'Fedoseev', 29, 'GM', 2712),
('Daniil', 'Dubov', 28, 'GM', 2700);

-- Insert player nationalities
INSERT INTO Player_Nationality (Player_Id, Nationality)
VALUES
(1, 'Norwegian'),
(2, 'American'),
(3, 'American'),
(4, 'Indian'),
(5, 'Indian'),
(6, 'Uzbek'),
(7, 'French'),
(8, 'Russian'),
(9, 'Chinese'),
(10, 'Indian'),
(11, 'Armenian'),
(12, 'American'),
(13, 'Cuban'),
(14, 'Indian'),
(15, 'Polish'),
(16, 'Vietnamese'),
(17, 'Chinese'),
(18, 'American'),
(19, 'German'),
(20, 'French'),
(21, 'Azerbaijani'),
(22, 'Dutch'),
(23, 'Indian'),
(24, 'Indian'),
(25, 'Hungarian'),
(26, 'Chinese'),
(27, 'Russian'),
(28, 'Russian');

-- Insert chess openings
INSERT INTO Opening (Name, ECO_Code, Agressiveness)
VALUES
('Sicilian Defense', 'B20', TRUE),
('French Defense', 'C00', FALSE),
('Ruy Lopez', 'C60', TRUE),
('Queens Gambit', 'D06', FALSE),
('Kings Indian Defense', 'E60', TRUE),
('Caro-Kann Defense', 'B10', FALSE),
('Grunfeld Defense', 'D80', TRUE),
('Scandinavian Defense', 'B01', FALSE);

-- Insert clubs
INSERT INTO Club (Club_Name, Location)
VALUES
('Oslo Chess Club', 'Oslo, Norway'),
('Moscow Chess Federation', 'Moscow, Russia'),
('Saint Louis Chess Club', 'Saint Louis, USA'),
('Indian Chess Club', 'Chennai, India'),
('Shenzhen Chess Club', 'Shenzhen, China'),
('Paris Chess Club', 'Paris, France'),
('Berlin Chess Academy', 'Berlin, Germany'),
('Budapest Chess Academy', 'Budapest, Hungary');

-- Assign random Opening_Id to each Player_Id
INSERT INTO Player_Styles (Player_Id, Opening_Id)
SELECT 
    Player.Player_Id,
    (SELECT Opening.Opening_Id 
     FROM Opening 
     ORDER BY RANDOM() 
     LIMIT 1) AS Random_Opening_Id
FROM 
    Player;


-- Assign random Club_Id to each Player_Id
INSERT INTO Club_Players (Club_Id, Player_Id)
SELECT 
    (SELECT Club.Club_Id 
     FROM Club 
     ORDER BY RANDOM() 
     LIMIT 1) AS Random_Club_Id,
    Player.Player_Id
FROM 
    Player;