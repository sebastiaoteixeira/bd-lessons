from flask import Flask, jsonify, request
from .utils.runSQL import runSQLQuery, dbconnect
from datetime import datetime

app = Flask(__name__)

# Stats
stats = {
    'start_time': datetime.utcnow(),
    'requests': 0,
    'errors': 0
}

# Connect to the database
connection = dbconnect()


## HELLO WORLD ##
@app.route('/api/v1/hello', methods=['GET'])
def hello():
    return jsonify({'message': 'Hello, World!'})


## AUTHENTICATION ##
@app.route('/api/v1/register', methods=['GET'])
def register():
    # TODO: Implement registration
    pass

@app.route('/api/v1/auth', methods=['POST'])
def auth():
    # TODO: Implement authentication
    pass

@app.route('/api/v1/auth', methods=['DELETE'])
def unauth():
    # TODO: Implement unauthentication
    pass

# Decorator: Only authenticated users can access these routes
def require_auth(func):
    # TODO: Implement authentication check in a decorator pattern
    pass


## GETTERS ##
# Module 1: Stops, Lines and Journeys
@app.route('/api/v1/stops', methods=['GET'], strict_slashes=False)
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

    for stop in runSQLQuery(connection, './src/sql/stops.sql', (name,), limit, offset):
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
    for stop in runSQLQuery(connection, './src/sql/stop.sql', (stopnumber,)):
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

    for line in runSQLQuery(connection, './src/sql/lines.sql'):
        result.append({
            'number': line[0],
            'designation': line[1],
            'idFirstStop': line[2],
            'idLastStop': line[3],
            'color': line[4]
        })

    return jsonify(result)


@app.route('/api/v1/line/<int:linenumber>', methods=['GET'])
def line(linenumber):
    for line in runSQLQuery(connection, './src/sql/line.sql', (linenumber,)):
        return jsonify({
            'number': linenumber,
            'designation': line[0],
            'idFirstStop': line[1],
            'idLastStop': line[2],
            'color': line[3]
        })


def computeStopsOrder(raw_result, firstStop, lastStop):
    result = []
    result.append(firstStop)
    while result[-1] != lastStop:
        found = False
        for stop in raw_result:
            app.logger.info(stop)
            if stop['id'] == result[-1]:
                result.append(stop['idNextStop'])
                found = True
                break
        if not found:
            return None
    return result


def getDirection(stop):
    return 'outbound' if stop[2] else 'inbound'

@app.route('/api/v1/line/<int:linenumber>/stops', methods=['GET'])
def line_stops(linenumber):
    direction = request.args.get('direction')
    if direction:
        directions = [direction]
        if direction not in ['inbound', 'outbound']:
            return jsonify({'error': 'Invalid direction'})
    else:
        directions = ['inbound', 'outbound']

    raw_result = {d: [] for d in directions}
    app.logger.info(raw_result)
    firstAndLastStop = []

    for line in runSQLQuery(connection, './src/sql/line.sql', (linenumber,)):
        firstAndLastStop.extend(line[1:3])
        break

    for stop in runSQLQuery(connection, './src/sql/uniDir_line_stops.sql', (linenumber, direction == 'outbound')) if direction else runSQLQuery(connection, './src/sql/line_stops.sql', (linenumber,)):
        raw_result[getDirection(stop)].append({
            'id': stop[0],
            'idNextStop': stop[1]
            })

    app.logger.info(raw_result)
    result = {d: [] for d in directions}
    for key in result:
        result[key] = computeStopsOrder(raw_result[key], firstAndLastStop[0 if key == 'inbound' else 1], firstAndLastStop[0 if key == 'outbound' else 1])

    if None in result.values():
        return jsonify({'error': 'Invalid stops order'})

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

    for stop in runSQLQuery(connection, './src/sql/uniDir_line_stop.sql', (linenumber, stopnumber, direction == 'outbound')) if direction else runSQLQuery(connection, './src/sql/line_stop.sql', (linenumber, stopnumber)):
        result.append(getLineStop(stopnumber, stop))

    return jsonify(result)


@app.route('/api/v1/line/<int:linenumber>/stop/<int:stopnumber>/next', methods=['GET'])
def next_stop(linenumber, stopnumber):
    direction = request.args.get('direction')
    if not direction:
        return jsonify({'error': 'Direction is required'})
    if direction not in ['inbound', 'outbound']:
        return jsonify({'error': 'Invalid direction'})

    for stop in runSQLQuery(connection, './src/sql/next_stop.sql', (linenumber, stopnumber, direction == 'outbound')):
        return jsonify(getLineStop(stop[0], stop[1:]))

@app.route('/api/v1/journeys', methods=['GET'])
def journeys():
    # TODO: Implement journeys getter (with include stops option)
    pass

@app.route('/api/v1/journey/<int:journeynumber>', methods=['GET'])
def journey(journeynumber):
    # TODO: Implement journey getter
    pass

@app.route('/api/v1/line/<int:linenumber>/journeys', methods=['GET'])
def line_journeys(linenumber):
    # TODO: Implement journeys getter for a line (with include stops option)
    pass


# Module 2: Tickets and Prices
@app.route('/api/v1/price/<string:ticketType>/<int:start>/<int:end>', methods=['GET'])
def price(ticketType, start, end):
    # TODO: Implement price getter
    pass


# Module 3: Statistics and Registers
@app.route('/api/v1/journeyInstances', methods=['GET'])
def journeyInstances():
    # TODO: Implement journey instance getter (with mintime, maxtime, journey and/or line options)
    pass

@app.route('/api/v1/journeyInstance/<int:journeyInstanceNumber>', methods=['GET'])
def journeyInstance(journeyInstanceNumber):
    # TODO: Implement journey instance getter
    pass

@app.route('/api/v1/journeyInstance/<int:journeyInstanceNumber>/stops', methods=['GET'])
def journeyInstanceStops(journeyInstanceNumber):
    # TODO: Implement journey instance stops getter
    pass

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
    pass









## STATS ##
@app.route('/api/v1/stats', methods=['GET'])
def stats():
    return jsonify({
        'uptime': datetime.datetime.now() - stats['start_time'],
        'requests': stats['requests'],
        'errors': stats['errors']
        })
