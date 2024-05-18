import sys
import getopt
from .utils import runSQL
from .server import app

def run():
    try:
        opts, args = getopt.getopt(sys.argv[1:], "hf:r", ["help", "file"])
    except getopt.GetoptError as e:
        print(e)
        return

    for opt, arg in opts:
        if opt in ('-h', '--help'):
            print("Usage: main.py [-h] [-f]")
            return
        elif opt in ('-f', '--file'):
            connection = runSQL.dbconnect()
            for res in runSQL.runSQLFile(connection, arg):
                print(res)
            connection.closeConnection()
            return
        elif opt in ('-r', '--reset'):
            sqlFiles = [
                        'src/sql/setup/dropAllTables.sql',
                        'src/sql/setup/createTables.sql',
                        'src/sql/preloadData/insertStops.sql',
                        'src/sql/preloadData/insertLines.sql',
                        'src/sql/preloadData/insertJourneys.sql'
                        ]
            connection = runSQL.dbconnect()
            for file in sqlFiles:
                for res in runSQL.runSQLFile(connection, file):
                    print(res)
            connection.closeConnection()
            return
        
    print("Starting api server...")
    app.run(host="0.0.0.0", port=5000, debug=True)

