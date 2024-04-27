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
@app.route('/api/v1/stops', methods=['GET'])
def stops():
    result = []

    name = request.args.get('name')
    name = f'%{name}%' if name else '%'
    

    for stop in runSQLQuery(connection, './src/sql/stops.sql', (name,)):
        result.append({
            'id': stop[0],
            'name': stop[1],
            'latitude': stop[2],
            'longitude': stop[3]
        })
    
    return jsonify(result)

@app.route('/api/v1/stop/<int:stopnumber>', methods=['GET'])
def stop(stopnumber):
    for stop in runSQLQuery(connection, './src/sql/stop.sql', (stopnumber,)):
        return jsonify({
            'id': stop[0],
            'name': stop[1],
            'latitude': stop[2],
            'longitude': stop[3]
        })

@app.route('/api/v1/lines', methods=['GET'])
def lines():
    # TODO: Implement lines getter
    pass

@app.route('/api/v1/line/<int:linenumber>', methods=['GET'])
def line(linenumber):
    # TODO: Implement line getter
    pass

@app.route('/api/v1/line/<int:linenumber>/stops', methods=['GET'])
def line_stops(linenumber):
    # TODO: Implement stops getter for a line (ordened and with time to next stop)
    pass

@app.route('/api/v1/line/<int:linenumber>/stop/<int:stopnumber>', methods=['GET'])
def line_stop(linenumber, stopnumber):
    # TODO: Implement stop getter for a line (should return next stop and time to next stop)
    pass

@app.route('/api/v1/line/<int:linenumber>/stop/<int:stopnumber>/next', methods=['GET'])
def next_stop(linenumber, stopnumber):
    # TODO: Implement next stop getter for a stop in a line
    pass

@app.route('/api/v1/line/<int:linenumber>/stop/<int:stopnumber>/prev', methods=['GET'])
def prev_stop(linenumber, stopnumber):
    # TODO: Implement previous stop getter for a stop in a line
    pass

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
