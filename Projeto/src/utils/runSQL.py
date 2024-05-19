import pyodbc
import os

class dbconnect():
    def __init__(self):
        self.conn = []

        SERVER = os.environ.get('SQL_SERVER')
        DATABASE = os.environ.get('SQL_DATABASE')
        USERNAME = os.environ.get('SQL_USER')
        PASSWORD = os.environ.get('SQL_PASSWORD')

        self.connectionString = f'DRIVER={{ODBC Driver 18 for SQL Server}};SERVER={SERVER};DATABASE={DATABASE};UID={USERNAME};PWD={PASSWORD};TrustServerCertificate=yes'
        print(self.connectionString)

    def getConnection(self):
        self.conn.append(pyodbc.connect(self.connectionString))
        return self.conn[-1]

    def closeConnection(self):
        for conn in self.conn:
            try:
                conn.close()
            except:
                pass

def runSQL(connection, query, args=None, limit=1000, offset=0, logger=None):
    conn = connection.getConnection()
    cursor = conn.cursor()
    if args:
        cursor.execute(query, args)
    else:
        cursor.execute(query)
    if logger:
        for msg in cursor.messages:
            logger.debug(msg)
    try:
        cursor.skip(offset)
        for row in cursor:
            yield row
            if limit:
                limit -= 1
                if limit == 0:
                    break
    except pyodbc.ProgrammingError as e:
        if 'No results.  Previous SQL was not a query.' in str(e):
            if logger:
                logger.debug('No results.  Previous SQL was not a query.')
            conn.commit()
            return ('Query executed successfully',)
        else:
            raise e
    finally:
        cursor.close()
        conn.close()

def runSQLQuery(connection, queryFile, args=None, *, limit=1000, offset=0, append='', logger=None):
    limit = min(int(limit), 1000)
    offset = max(int(offset), 0)
    with open(queryFile, 'r') as file:
        query = file.read() + append
    if logger:
        logger.debug(query)

    # Remove comments
    query = '\n'.join([line for line in query.split('\n') if not line.startswith('--')])

    for row in runSQL(connection, query, args, limit, offset, logger):
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

