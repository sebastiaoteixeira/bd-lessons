from flask import jsonify, request
from flask_cors import CORS
from .app import App
from .utils.runSQL import runSQLQuery, dbconnect, runSQLFile
import time

app = App(__name__)
CORS(app)

# Connect to the database
connection = dbconnect()


## HELLO WORLD ##
@app.route('/api/v1/hello', methods=['GET'])
def hello():
    return jsonify({'message': 'Hello, World!'})


## AUTHENTICATION ##
@app.route('/api/v1/register', methods=['POST'])
def register():
    # TODO: Implement registration
    name = request.json['name']
    email = request.json['email']
    nif = request.json['nif']
    password = request.json['password']

    for _ in runSQLQuery(connection, './src/sql/queries/register.sql', (email, password, name, nif), logger=app.logger):
        pass

    for token in runSQLQuery(connection, './src/sql/queries/getTokenSession.sql', (email,), logger=app.logger):
        return jsonify({'token': token[0]})


@app.route('/api/v1/auth', methods=['POST'])
def auth():
    email = request.json['email']
    password = request.json['password']

    for result in runSQLQuery(connection, './src/sql/queries/auth.sql', (email, password), logger=app.logger):
        app.logger.info(result)

    for token in runSQLQuery(connection, './src/sql/queries/getTokenSession.sql', (email,), logger=app.logger):
        return jsonify({'token': token[0]})
    return jsonify({'error': 'Invalid credentials'}), 401


# Decorator: Only authenticated users can access these routes
def require_auth(func):
    def wrapper():
        # Check for the header 'Authorization'
        # If not, return 401 Unauthorized
        # If valid, call the function
        token = request.headers.get('Authorization')
        if not token:
            return jsonify({'error': 'Unauthorized'}), 401

        for result in runSQLQuery(connection, './src/sql/queries/checkAuthentication.sql', (token,), logger=app.logger):
            app.logger.debug('AUTH RESULT: ' + str(result))
            if result[0]:
                return func()
            return jsonify({'error': 'Unauthorized'}), 401
    wrapper.__name__ = func.__name__
    return wrapper

# Authentication checker
@app.route('/api/v1/auth/check', methods=['GET'])
@require_auth
def check_auth():
    return jsonify({'message': 'Authenticated', 'token': request.headers.get('Authorization')})


# Module 1: Stops, Lines and Journeys
## GETTERS ##
@app.route('/api/v1/stops', methods=['GET'])
def stops():
    result = []

    name = request.args.get('name')
    name = f'%{name}%' if name else '%'
    limit = request.args.get('limit')
    if not limit:
        limit = 1000
    offset = request.args.get('offset')
    if not offset:
        offset = 0

    for stop in runSQLQuery(connection, './src/sql/queries/stops.sql', (name,), limit=limit, offset=offset):
        result.append({
            'id': stop[0],
            'name': stop[1],
            'location': stop[2],
            'longitude': stop[3],
            'latitude': stop[4],
        })
    
    return jsonify(result)

@app.route('/api/v1/stop/<int:stopnumber>', methods=['GET'])
def stop(stopnumber):
    for stop in runSQLQuery(connection, './src/sql/queries/stop.sql', (stopnumber,)):
        return jsonify({
            'id': stopnumber,
            'name': stop[0],
            'location': stop[1],
            'longitude': stop[2],
            'latitude': stop[3],
        })

@app.route('/api/v1/lines', methods=['GET'])
def lines():
    result = []

    for line in runSQLQuery(connection, './src/sql/queries/lines.sql'):
        result.append({
            'number': line[0],
            'designation': line[1],
            'idFirstStop': line[2],
            'idLastStop': line[3],
            'color': "#{:0>6}".format(hex(line[4])[2:])
        })

    return jsonify(result)


@app.route('/api/v1/line/<int:linenumber>', methods=['GET'])
def line(linenumber):
    for line in runSQLQuery(connection, './src/sql/queries/line.sql', (linenumber,)):
        return jsonify({
            'number': linenumber,
            'designation': line[0],
            'idFirstStop': line[1],
            'idLastStop': line[2],
            'color': "#{:0>6}".format(hex(line[3])[2:])
        })


def getDirection(stop):
    return 'outbound' if stop[2] else 'inbound'

@app.route('/api/v1/line/<int:linenumber>/stops', methods=['GET'])
def line_stops(linenumber):
    direction = request.args.get('direction')
    if not direction:
        result = {'inbound': [], 'outbound': []}

        for stop in runSQLQuery(connection, './src/sql/queries/lineStopsList.sql', (linenumber, False)):
            result['inbound'].append({
                'id': stop[0],
                'name': stop[1],
                'location': stop[2],
                'longitude': stop[3],
                'latitude': stop[4]
            })

        for stop in runSQLQuery(connection, './src/sql/queries/lineStopsList.sql', (linenumber, True)):
            result['outbound'].append({
                'id': stop[0],
                'name': stop[1],
                'location': stop[2],
                'longitude': stop[3],
                'latitude': stop[4]
            })

    else:
        result = []
        for stop in runSQLQuery(connection, './src/sql/queries/lineStopsList.sql', (linenumber, direction == 'outbound')):
            result.append({
                'id': stop[0],
                'name': stop[1],
                'location': stop[2],
                'longitude': stop[3],
                'latitude': stop[4]
            })

    return jsonify(result)


def getLineStop(stopnumber, stop):
    return {
        'id': stopnumber,
        'name': stop[0],
        'location': stop[1],
        'longitude': stop[2],
        'latitude': stop[3],
        'nextStop': {
            'id': stop[4],
            'name': stop[5],
            'location': stop[6],
            'longitude': stop[7],
            'latitude': stop[8],
        },
        'timeToNext': str(stop[9]),
        'direction': 'outbound' if stop[10] else 'inbound'
    }

@app.route('/api/v1/line/<int:linenumber>/stop/<int:stopnumber>', methods=['GET'])
def line_stop(linenumber, stopnumber):
    result = []

    direction = request.args.get('direction')

    for stop in runSQLQuery(connection, *(('./src/sql/queries/uniDir_line_stop.sql', (linenumber, stopnumber, direction == 'outbound')) if direction else ('./src/sql/queries/line_stop.sql', (linenumber, stopnumber)))):
        result.append(getLineStop(stopnumber, stop))

    return jsonify(result)


@app.route('/api/v1/line/<int:linenumber>/stop/<int:stopnumber>/next', methods=['GET'])
def next_stop(linenumber, stopnumber):
    direction = request.args.get('direction')
    if not direction:
        return jsonify({'error': 'Direction is required'}), 400
    if direction not in ['inbound', 'outbound']:
        return jsonify({'error': 'Invalid direction'}), 400

    for stop in runSQLQuery(connection, './src/sql/queries/next_stop.sql', (linenumber, stopnumber, direction == 'outbound')):
        return jsonify(getLineStop(stop[0], stop[1:]))


@app.route('/api/v1/journeys', methods=['GET'])
def journeys():
    result = []

    line = request.args.get('line')
    includeStops = request.args.get('includeStops')
    start = request.args.get('start')
    end = request.args.get('end')
    limit = request.args.get('limit')
    if not limit:
        limit = 1000
    offset = request.args.get('offset')
    if not offset:
        offset = 0

    if start and end:
        for journey in runSQLQuery(connection, './src/sql/queries/flsJourneys.sql', (line, start, end), limit=limit, offset=offset):
            result.append({
                'id': journey[0],
                'line': {
                    'number': journey[1],
                    'designation': journey[16],
                    'color': "#{:0>6}".format(hex(journey[17])[2:])
                },
                'firstStop': {
                    'id': journey[2],
                    'name': journey[8],
                    'location': journey[9],
                    'longitude': journey[10],
                    'latitude': journey[11],
                },
                'lastStop': {
                    'id': journey[3],
                    'name': journey[12],
                    'location': journey[13],
                    'longitude': journey[14],
                    'latitude': journey[15],
                },
                'firstSelectedStop': {
                    'id': start,
                    'name': journey[18],
                    'location': journey[19],
                    'longitude': journey[20],
                    'latitude': journey[21],
                    'time': str(journey[5])
                },
                'lastSelectedStop': {
                    'id': end,
                    'name': journey[22],
                    'location': journey[23],
                    'longitude': journey[24],
                    'latitude': journey[25],
                    'time': str(journey[6])
                },
                'time': str(journey[4]),
                'direction': 'outbound' if journey[7] else 'inbound'
            })
    else:
        for journey in runSQLQuery(connection, './src/sql/queries/journeys.sql', (line, includeStops), limit=limit, offset=offset):
            result.append({
                'id': journey[0],
                'line': {
                    'number': journey[1],
                    'designation': journey[14],
                    'color': "#{:0>6}".format(hex(journey[15])[2:])
                },
                'firstStop': {
                    'id': journey[2],
                    'name': journey[6],
                    'location': journey[7],
                    'longitude': journey[8],
                    'latitude': journey[9]
                },
                'lastStop': {
                    'id': journey[3],
                    'name': journey[10],
                    'location': journey[11],
                    'longitude': journey[12],
                    'latitude': journey[13]
                },
                'time': str(journey[4]),
                'direction': 'outbound' if journey[5] else 'inbound'
            })

    return jsonify(result)


@app.route('/api/v1/journey/<int:journeynumber>', methods=['GET'])
def journey(journeynumber):
    # TODO: Implement journey getter
    for journey in runSQLQuery(connection, './src/sql/queries/journey.sql', (journeynumber,)):
        return jsonify({
            'id': journey[0],
            'line': {
                'number': journey[1],
                'designation': journey[14],
                'color': "#{:0>6}".format(hex(journey[15])[2:])
                },
            'firstStop': {
                'id': journey[2],
                'name': journey[6],
                'location': journey[7],
                'longitude': journey[8],
                'latitude': journey[9]
                },
            'lastStop': {
                'id': journey[3],
                'name': journey[10],
                'location': journey[11],
                'longitude': journey[12],
                'latitude': journey[13]
                },
            'time': str(journey[4]),
            'direction': 'outbound' if journey[5] else 'inbound'
        })

@app.route('/api/v1/journey/<int:journeynumber>/stops', methods=['GET'])
def journey_stops(journeynumber):
    result = []
    for stop in runSQLQuery(connection, './src/sql/queries/journeyStopsList.sql', (journeynumber,)):
        result.append({
            'id': stop[0],
            'name': stop[1],
            'location': stop[2],
            'longitude': stop[3],
            'latitude': stop[4],
            'time': str(stop[5])
        })
    return jsonify(result)

@app.route('/api/v1/line/<int:linenumber>/journeys', methods=['GET'])
def line_journeys(linenumber):
    # TODO: Implement journeys getter for a line (with include stops option)
    # Alias: /api/v1/journeys?line=<linenumber>
    result = []

    includeStops = request.args.get('includeStops')

    for journey in runSQLQuery(connection, './src/sql/queries/journeys.sql' ,(linenumber, includeStops)):
        result.append({
            'id': journey[0],
            'idLine': journey[1],
            'idFirstStop': journey[2],
            'idLastStop': journey[3],
            'time': str(journey[4]),
        })

    return jsonify(result)


# Module 2: Tickets and Prices
## GETTERS ##
@app.route('/api/v1/prices')
def price():
    # TODO: Implement price getter (with ticket type, start and end stops)
    start = request.args.get('start')
    end = request.args.get('end')
    
    res = []

    for price in runSQLQuery(connection, './src/sql/queries/prices.sql', (start, end)):
        res.append({
            'start': start,
            'end': end,
            'zone': price[1],
            'price': price[0]
            })
    
    return jsonify(res)
    
    

@app.route('/api/v1/tickets', methods=['GET'])
def tickets():
    # TODO: Implement tickets getter with all items purchased (onlyValid options)
    result = []

    onlyValid = request.args.get('onlyValid')
    if onlyValid:
        onlyValid = onlyValid.lower() == 'true'
    else:
        onlyValid = False

    for ticket in runSQLQuery(connection, './src/sql/queries/tickets.sql', (onlyValid,)):
        result.append({
            'id': ticket[0],
            'idItemTariff': ticket[1],
            'idTransportTicket': ticket[2],
            'date': ticket[3]
        })

    return jsonify(result)

@app.route('/api/v1/myTickets', methods=['GET'])
@require_auth
def myTickets():
    # TODO: Implement tickets getter with all items purchased (onlyValid options)
    result = []
    
    token = request.headers.get('Authorization')
    
    onlyValid = request.args.get('onlyValid')
    if onlyValid:
        onlyValid = onlyValid.lower() == 'true'
    else:
        onlyValid = False
    
    for ticket in runSQLQuery(connection, './src/sql/queries/myTickets.sql', (token,onlyValid)):
        result.append({
            'id': ticket[0],
            'idItemTariff': ticket[1],
            'idTransportTicket': ticket[2],
            'date': ticket[3]
        })
        
    return jsonify(result)

@app.route('/api/v1/ticket/<int:ticketnumber>', methods=['GET'])
def ticket(ticketnumber):
    # TODO: Implement ticket getter with all items purchased
    result = []

    for ticket in runSQLQuery(connection, './src/sql/queries/ticket.sql', (ticketnumber,)):
        result.append({
            'id': ticket[0],
            'idItemTariff': ticket[1],
            'idTransportTicket': ticket[2],
            'date': ticket[3]
        })

    return jsonify(result)

# Module 3: Statistics and Registers
## GETTERS ##
@app.route('/api/v1/journeyInstances', methods=['GET'])
def journeyInstances():
    # TODO: Implement journey instance getter (with mintime, maxtime, journey or line options)
    result = []

    #mintime = request.args.get('mintime')
    #maxtime = request.args.get('maxtime')
    journey = request.args.get('journey')
    line = request.args.get('line')
    limit = request.args.get('limit')
    if not limit:
        limit = 1000
    offset = request.args.get('offset')
    if not offset:
        offset = 0

    if journey and line:
        return jsonify({'error': 'Invalid parameters'}), 400
    
    for journeyInstance in runSQLQuery(connection, './src/sql/queries/journeyInstances.sql', limit=limit, offset=offset, args=(journey, line)):
        result.append({
            'id': journeyInstance[0],
            'idJourney': journeyInstance[1],
            'dateTime': str(journeyInstance[2]),
            'journey': {
                'idLine': journeyInstance[3],
                'idFirstStop': journeyInstance[4],
                'idLastStop': journeyInstance[5],
                'time': str(journeyInstance[6])
            }
        })

    return jsonify(result)

@app.route('/api/v1/journeyInstance/<int:journeyInstanceNumber>', methods=['GET'])
def journeyInstance(journeyInstanceNumber):
    # TODO: Implement journey instance getter
    result = []
    
    for journeyInstance in runSQLQuery(connection, './src/sql/queries/journeyInstance.sql', (journeyInstanceNumber,), logger=app.logger):
        result.append({
            'id': journeyInstanceNumber,
            'dateTime': str(journeyInstance[0]),
            'journey': {
                'id': journeyInstance[1],
                'idLine': journeyInstance[2],
                'idFirstStop': journeyInstance[3],
                'idLastStop': journeyInstance[4],
                'time': str(journeyInstance[5])
                }
            })
    return jsonify

@app.route('/api/v1/journeyInstance/<int:journeyInstanceNumber>/stops', methods=['GET'])
def journeyInstanceStops(journeyInstanceNumber):
    # TODO: Implement journey instance stops getter
    result = []
    
    for stop in runSQLQuery(connection, './src/sql/queries/journeyInstance.sql', (journeyInstanceNumber,), logger=app.logger):
        result.append({
            'id': stop[0],
            'name': stop[1],
            'location': stop[2],
            'longitude': stop[3],
            'latitude': stop[4],
            'time': str(stop[5])       
        })
    return jsonify

@app.route('/api/v1/journeyInstance/<int:journeyInstanceNumber>/validations', methods=['GET'])
def journeyInstanceValidations(journeyInstanceNumber):
    # TODO: Implement journey instance validations getter (with mintime and/or maxtime options)
    pass

@app.route('/api/v1/journeyInstance/<int:journeyInstanceNumber>/stop/<int:stopnumber>/validations', methods=['GET'])
def journeyInstanceStopValidations(journeyInstanceNumber, stopnumber):
    # TODO: Implement journey instance stop getter
    pass

@app.route('/api/v1/line/<int:linenumber>/journeyInstances', methods=['GET'])
def line_journeyInstances(linenumber):
    # TODO: Implement journey instances getter for a line
    result = []
    
    for journeyInstance in runSQLQuery(connection, './src/sql/queries/journeyInstances.sql', (linenumber,), logger=app.logger):
        result.append({
            'id': journeyInstance[0],
            'dateTime': str(journeyInstance[1]),
            'journey': {
                'id': journeyInstance[2],
                'idLine': journeyInstance[3],
                'idFirstStop': journeyInstance[4],
                'idLastStop': journeyInstance[5],
                'time': str(journeyInstance[6])
            }
        })
    return jsonify(result)









## STATS ##
@app.route('/api/v1/stats', methods=['GET'])
def stats():
    return jsonify(app.get_stats())


## PRELOAD DATA ##
import os

@app.route('/api/v1/preload', methods=['GET'])
def preload():
    for file in os.listdir('./src/sql/preloadData'):
        if file.endswith('.sql'):
            runSQLFile(connection.getConnection(), f'./src/sql/preloadData/{file}')



########## RESERVED AREA ##########
### NOT WRITE CODE IN THIS AREA ###


######## END RESERVED AREA ########


