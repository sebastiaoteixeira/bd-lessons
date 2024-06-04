# This script should be run to start the bus service.
# Every 20 seconds, the bus service will update the status of journeyInstances.

from time import sleep, timezone, localtime, altzone
from datetime import time, datetime
import pytz
import logging
import random

from .utils.runSQL import runSQLQuery, dbconnect, runSQLFile
import threading

# Connect to the database
connection = dbconnect()


class BusService(threading.Thread):
    def __init__(self):
        threading.Thread.__init__(self)
    
    def run(self):
        while True:
            sleep(75)
            
            
            # VERIFY IF THERE IS A JOURNEY TO BE INSTANTIATED
            ## Get all journeys
            
            journeys = []
            limit = 10000
            offset = 0
            line = None
            includeStops = None
            for journey in runSQLQuery(connection, './src/sql/queries/journeys.sql', (line, includeStops), limit=limit, offset=offset):
                journeys.append({
                    'id': journey[0],
                    'line': {
                        'number': journey[1],
                        'name': journey[14],
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
                    'time': journey[4],
                    'direction': 'outbound' if journey[5] else 'inbound'
                })
                
            ## For each journey verify if there is less then one hour to the start time
            for journey in journeys:
                # convert journeyTime from datetime to seconds
                journeyTime = journey['time']
                print('Journey time: ', journeyTime)
                journeyTime = journeyTime.hour * 3600 + journeyTime.minute * 60 + journeyTime.second
                
                currentTime = datetime.now(pytz.timezone('Europe/Lisbon'))
                
                print("Current time: ", currentTime)
                currentTime = currentTime.hour * 3600 + currentTime.minute * 60 + currentTime.second
                if journeyTime - currentTime < 3600 and journeyTime - currentTime > 0:
                    # Verify if journeyInstance already exists
                    alreadyExists = False
                    for journeyInstance in runSQLQuery(connection, './src/sql/queries/journeyInstances.sql', (journey['id'], None)):
                        startTime = journeyInstance[2]
                        startTime = startTime.hour * 3600 + startTime.minute * 60 + startTime.second
                        if currentTime - 12000 < startTime:
                            alreadyExists = True
                            break
                    
                    if alreadyExists:
                        print('Journey already instantiated')
                        continue

                    
                    # Create a new journeyInstance
                    try:
                        for _ in runSQLQuery(connection, './src/sql/insert/createJourneyInstance.sql', (journey['id'],)):
                            break
                        print('Journey to be instantiated')
                        print(journey)
                        print('time difference: ', journeyTime - currentTime)
                    except Exception as e:
                        logging.error(e)
                    sleep(2)
                
                    
            # UPDATE JOURNEY INSTANCES
            ## Get all journeyInstances
            journeyInstances = []
            limit = 10000
            offset = 0
            for journeyInstance in runSQLQuery(connection, './src/sql/queries/journeyInstances.sql', (None, None), limit=limit, offset=offset):
                journeyInstances.append({
                    'id': journeyInstance[0],
                    'journey': {
                        'id': journeyInstance[1],
                        'idLine': journeyInstance[2],
                        'firstStopId': journeyInstance[3],
                        'lastStopId': journeyInstance[4],
                        'time': journeyInstance[5]
                    },
                    'startTime': journeyInstance[2],
                })
            
            print("aaa")

            ## For each journeyInstance, update status
            for journeyInstance in journeyInstances:
                # Get journeyInstance start time
                _startTime = journeyInstance['startTime']
                startTime = _startTime.hour * 3600 + _startTime.minute * 60 + _startTime.second
                
                # Get current time
                _currentTime = datetime.now(pytz.timezone('Europe/Lisbon'))
                currentTime = _currentTime.hour * 3600 + _currentTime.minute * 60 + _currentTime.second
                
                ## Verify if journeyInstance is recent
                if _startTime.day < _currentTime.day - 1:
                    continue
                
                print(journeyInstance['id'])
                
                ## Get next Stop
                nextStop = None
                for stop in runSQLQuery(connection, './src/sql/queries/journeyInstanceNextStop.sql', (journeyInstance['id'],)):
                    print(stop)
                    if stop[0]:
                        nextStop = {
                            'id': stop[0],
                            'name': stop[1],
                            'location': stop[2],
                            'longitude': stop[3],
                            'latitude': stop[4]
                        }
                    break
                
                print(nextStop)
                
                if nextStop:
                    # verify the time in journey to next stop
                    # call nextBuses
                    expectedTime = None
                    for bus in runSQLQuery(connection, './src/sql/queries/nextBuses.sql', (nextStop['id'])):
                        if bus[0] == journeyInstance['id']:
                            expectedTime = bus[7]
                    print(expectedTime)
                    if expectedTime:
                        expectedTime = expectedTime.hour * 3600 + expectedTime.minute * 60 + expectedTime.second
                        if expectedTime < currentTime:
                            # There is 50% chance of updating the status
                            if random.randint(0, 1):
                                print('Updating status')
                                for _ in runSQLQuery(connection, './src/sql/insert/stepJourneyInstance.sql', (journeyInstance['id'],)):
                                    break
                            else:
                                print('Not updating status')
                
        
