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
    IFNULL(MIN(`Fuel burn (kg/km)`),
            (SELECT 
                    ROUND(AVG(`Fuel burn (kg/km)`), 2)
                FROM
                    aircrafts_features
                WHERE
                    `Flight Range` = MAX(airports_distance.`range`)
                GROUP BY `Flight Range`)) AS fuel_burn,
    IFNULL(MIN(ROUND(`total_speed` * (10.0 / 60.0) * `Fuel burn (kg/km)` * 3.0)),
            ROUND(MIN(`total_speed` * (10.0 / 60.0) * 3.0) * (SELECT 
                            ROUND(AVG(`Fuel burn (kg/km)`), 2)
                        FROM
                            aircrafts_features
                        WHERE
                            `Flight Range` = MAX(airports_distance.`range`)
                        GROUP BY `Flight Range`))) AS `Co2 (kg/10min)`,
    IFNULL(MIN(ROUND(distance_to_bcn * `Fuel burn (kg/km)` * 3.0)),
            ROUND(MIN(distance_to_bcn * 3.00) * (SELECT 
                            ROUND(AVG(`Fuel burn (kg/km)`), 2)
                        FROM
                            aircrafts_features
                        WHERE
                            `Flight Range` = MAX(airports_distance.`range`)
                        GROUP BY `Flight Range`))) AS `Co2 (flight)`
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


