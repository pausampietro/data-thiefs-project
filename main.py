from extract_data import get_flight_data, save_to_sql

flights_data = get_flight_data()

save_to_sql(flights_data, 'flight_data_test')

