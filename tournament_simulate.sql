-- Simulate multiple tournaments with realistic names and locations
DO $$
DECLARE
    i INTEGER;
    tournament_id INTEGER;
    tournament_name VARCHAR(100);
    tournament_location VARCHAR(100);
    tournament_names TEXT[] := ARRAY[
        'World Chess Championship',
        'Grandmaster Invitational',
        'Rapid Chess Open',
        'Blitz Chess Cup',
        'Junior Chess Masters',
        'Continental Chess Championship',
        'City Open Chess Tournament',
        'National Chess League Finals',
        'Annual Chess Classic',
        'Regional Chess Challenge'
    ];
    tournament_locations TEXT[] := ARRAY[
        'New York, USA',
        'Paris, France',
        'Berlin, Germany',
        'Moscow, Russia',
        'Tokyo, Japan',
        'London, UK',
        'Madrid, Spain',
        'Rome, Italy',
        'Sydney, Australia',
        'Dubai, UAE'
    ];
BEGIN
    -- Loop to create and simulate multiple tournaments
    FOR i IN 1..ARRAY_LENGTH(tournament_names, 1) LOOP
        -- Select tournament name and location from the lists
        tournament_name := tournament_names[i];
        tournament_location := tournament_locations[i];

        -- Simulate a tournament with random parameters
        tournament_id := simulate_tournament(
            tournament_name,
            tournament_location, -- Use the predefined location
            5 + (RANDOM() * 5)::INTEGER, -- Random rounds between 5 and 10
            (10000 + (RANDOM() * 40000))::DECIMAL(15,2) -- Random prize pool between 10,000 and 50,000
        );

        -- Output the tournament ID, name, and location
        RAISE NOTICE 'Simulated Tournament: % (ID: %) - Location: %', tournament_name, tournament_id, tournament_location;
    END LOOP;
END $$;