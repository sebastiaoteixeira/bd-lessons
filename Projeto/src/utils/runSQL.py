import pyodbc
import os

class dbconnect():
    def __init__(self):
        self.conn = None

        SERVER = os.environ.get('SQL_SERVER')
        DATABASE = os.environ.get('SQL_DATABASE')
        USERNAME = os.environ.get('SQL_USER')
        PASSWORD = os.environ.get('SQL_PASSWORD')

        self.connectionString = f'DRIVER={{ODBC Driver 18 for SQL Server}};SERVER={SERVER};DATABASE={DATABASE};UID={USERNAME};PWD={PASSWORD};TrustServerCertificate=yes'
        print(self.connectionString)

    def getConnection(self):
        if self.conn is None:
            self.conn = pyodbc.connect(self.connectionString)
        return self.conn

    def closeConnection(self):
        if self.conn:
            self.conn.close()
            self.conn = None

def runSQL(connection, query, args=None, limit=1000, offset=0):
    conn = connection.getConnection()
    cursor = conn.cursor()
    if args:
        cursor.execute(query, args)
    else:
        cursor.execute(query)
    if 'SELECT' in query.upper():
        cursor.skip(offset)
        for row in cursor:
            yield row
            if limit:
                limit -= 1
                if limit == 0:
                    break
    else:
        conn.commit()
        return ('Query executed successfully',)

def runSQLQuery(connection, queryFile, args=None, limit=1000, offset=0):
    limit = min(int(limit), 1000)
    offset = max(int(offset), 0)
    with open(queryFile, 'r') as file:
        query = file.read()

    # Remove comments
    query = '\n'.join([line for line in query.split('\n') if not line.startswith('--')])

    for row in runSQL(connection, query, args, limit, offset):
        yield row


def runSQLFile(connection, queryFile):
    with open(queryFile, 'r') as file:
        query = file.read()

    # Remove comments
    query = '\n'.join([line for line in query.split('\n') if not line.startswith('--')])

    queries = query.split('GO')
    if queries[-1].strip() == '':
        queries.pop()

    for query in queries:
        query = query.strip()
        print(query)
        for row in runSQL(connection, query):
            yield row

