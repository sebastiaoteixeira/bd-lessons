SELECT 
    ji.[id] AS 'id',
    ji.[idJourney] AS 'idJourney',
    ji.[startTime] AS 'time',
    j.[idLine] AS 'journey.idLine',
    j.[idFirstStop] AS 'journey.idFirstStop',
    j.[idLastStop] AS 'journey.idLastStop',
    j.[startTime] AS 'journey.time'
FROM 
    [UrbanBus.journeyInstance] AS ji
JOIN 
    [UrbanBus.journey] AS j ON ji.[idJourney] = j.[id]
