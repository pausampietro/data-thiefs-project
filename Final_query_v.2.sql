SELECT 
    reg_number AS flight,
    MAX(aircraft_iata) AS aircraft_iata,
    MAX(aircraft_name) AS aircraft_name,
    MAX(airline_name) AS airline_name,
    MAX(arrival) AS destination,
    MAX(airports_distance.`range`) AS flight_range,
    MIN(distance_to_bcn) AS 'distance to bcn',
    MIN(total_speed) AS speed,
    MIN(flights_dx.latitude) AS act_latitude,
    MIN(flights_dx.longitude) AS longitude,
    MIN(`Fuel burn (kg/km)`) AS fuel_burn,
    MIN(ROUND(`total_speed` * (10.0 / 60.0) * `Fuel burn (kg/km)` * 3.0)) `Co2 (kg/10min)`,
    MIN(ROUND(distance_to_bcn * `Fuel burn (kg/km)` * 3.0)) AS `Co2 (flight)`
FROM
    flights_dx
        LEFT JOIN
    airports_distance ON flights_dx.arrival = airports_distance.iata
        LEFT JOIN
    aircrafts_iata ON flights_dx.aircraft_icao = aircrafts_iata.icao
        LEFT JOIN
    aircrafts_features ON aircrafts_features.Model = aircraft_name
        AND aircrafts_features.`Flight Range` = airports_distance.`range`
        LEFT JOIN
    airlines_icao ON airlines_icao.airline_ICAO = flights_dx.airline_icao
GROUP BY reg_number
HAVING NOT ISNULL(flight_range)
ORDER BY 1 DESC
;


