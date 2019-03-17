import requests
import pandas as pd
from pandas.io.json import json_normalize
from sqlalchemy import create_engine


def get_flight_data():
    '''
    This function gets the data of all the flights that are right now flying and that have departed from BCN.
    From an API from aviation-edge.com, it extracts a json file that is converted into a Dataframe.
    The time stamp is converted into a date.
    :return: A Dataframe with 23 columns.
    '''

    url = "http://aviation-edge.com/v2/public/flights?key=8bbf2c-a12972&depIata=BCN"

    response = requests.get(url).json()
    flights_data = pd.DataFrame(json_normalize(response))
    flights_data['system.updated'] = pd.to_datetime(flights_data['system.updated'], unit='s')


def save_to_sql(df_to_save, name_table):
    '''
    It saves a dataframe in the database of the group.

    :param df_to_save: dataframe to be stored in a sql database
    :param name_table: name of the table where we want to store the dataframe
    :return: A new (or updated) table in the database
    '''

    login = "root"
    password = "root"
    ip = "35.246.218.28"
    database = "Miscellaneous"

    engine = create_engine(f'mysql+pymysql://{login}:{password}@{ip}/{database}')

    df_to_save.to_sql(name_table, engine, if_exists='replace', index=False)

