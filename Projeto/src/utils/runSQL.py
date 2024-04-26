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
    
    def getConnection(self):
        if self.conn is None:
            self.conn = pyodbc.connect(self.connectionString)
        return self.conn

    def closeConnection(self):
        if self.conn:
            self.conn.close()
            self.conn = None

def runSQL(connection, query, args):
    conn = connection.getConnection()
    cursor = conn.cursor()
    if args:
        cursor.execute(query, args)
    else:
        cursor.execute(query)
    if 'SELECT' in query:
        rows = cursor.fetchall()
        return rows
    conn.commit()
    return ('Query executed successfully',)

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
        inputs = {}
        first = True
        if ':' not in query:
            print(query)
            yield runSQL(connection, query, None)
        else:
            for query in query.split(':'):
                if first:
                    first = False
                else:
                    print('<enter value for ', query.split()[0], end='> ')
                    inputs[query.split()[0]] = input()
                print(query)

            print(query)
            print(inputs)

            res = runSQL(connection, query, inputs)
            yield res

if __name__ == '__main__':
    for result in runSQLFile('query.sql'):
        print(result)

