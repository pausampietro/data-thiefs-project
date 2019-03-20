SELECT 
    flight_number AS flight,
    MAX(aircraft_iata) AS aircraft_iata,
    MAX(aircraft_name) AS aircraft_name,
    MAX(arrival) AS destination,
    MAX(airports_distance.`range`) AS flight_range,
    MIN(distance_to_bcn) AS 'distance to bcn',
    MIN(total_speed) AS speed,
    MIN(test_flights.latitude) as act_latitude,
    MIN(test_flights.longitude) as longitude,
    MIN(`Fuel burn (kg/km)`) AS fuel_burn,
    MIN( round(`total_speed` * (10.0/60.0) * `Fuel burn (kg/km)` * 3.0) ) AS `Co2 (kg/10min)`,
    MIN( round(distance_to_bcn * `Fuel burn (kg/km)` * 3.0) ) AS `Co2 (flight)`
FROM
    test_flights
        LEFT JOIN
    airports_distance ON test_flights.arrival = airports_distance.iata
        LEFT JOIN
    aircrafts_iata ON test_flights.aircraft_icao = aircrafts_iata.icao
        LEFT JOIN
    aircrafts_features ON aircrafts_features.Model = aircraft_name
        AND aircrafts_features.`Flight Range` = airports_distance.`range`
GROUP BY flight_number
HAVING NOT ISNULL(flight_range)
ORDER BY 1 DESC
;


