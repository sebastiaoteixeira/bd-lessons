SELECT 
    ji.[id] AS 'id',
    ji.[idJourney] AS 'idJourney',
    ji.[startTime] AS 'time',
    j.[idLine] AS 'journey.idLine',
    j.[idFirstStop] AS 'journey.idFirstStop',
    j.[idLastStop] AS 'journey.idLastStop',
    j.[time] AS 'journey.time'
FROM 
    [UrbanBus.journeyInstance] ji
JOIN 
    [UrbanBus.journey] j ON ji.[idJourney] = j.[id]