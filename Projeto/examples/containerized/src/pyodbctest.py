"""
Connects to a SQL database using pyodbc
"""
import pyodbc
import os

SERVER = os.environ.get('SQL_SERVER')
DATABASE = os.environ.get('SQL_DATABASE')
USERNAME = os.environ.get('SQL_USER')
PASSWORD = os.environ.get('SQL_PASSWORD')

connectionString = f'DRIVER={{ODBC Driver 18 for SQL Server}};SERVER={SERVER};DATABASE={DATABASE};UID={USERNAME};PWD={PASSWORD};TrustServerCertificate=yes'
print(connectionString)

conn = pyodbc.connect(connectionString)

SQL_QUERY = """SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = N'ATL_Pessoa'"""


cursor = conn.cursor()
cursor.execute(SQL_QUERY)

# Fetch all results
for row in cursor:
    print(row)

