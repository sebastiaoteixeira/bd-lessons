DECLARE @journey INT = ?;
DECLARE @line INT = ?;

IF @line IS NULL AND @journey IS NULL
    SELECT 
        ji.[id],
        ji.[idJourney],
        ji.[startTime],
        j.[idLine],
        j.[idFirstStop],
        j.[idLastStop],
        j.[startTime]
    FROM 
        [UrbanBus].[journeyInstance] AS ji
    JOIN 
        [UrbanBus].[journey] AS j ON ji.[idJourney] = j.[id]

ELSE IF @line IS NULL
    SELECT 
        ji.[id],
        ji.[idJourney],
        ji.[startTime],
        j.[idLine],
        j.[idFirstStop],
        j.[idLastStop],
        j.[startTime]
    FROM 
        [UrbanBus].[journeyInstance] AS ji
    JOIN 
        [UrbanBus].[journey] AS j ON ji.[idJourney] = j.[id]
    WHERE
        ji.[idJourney] = @journey

ELSE IF @journey IS NULL
    SELECT 
        ji.[id] AS 'id',
        ji.[idJourney] AS 'idJourney',
        ji.[startTime] AS 'time',
        j.[idLine] AS 'journey.idLine',
        j.[idFirstStop] AS 'journey.idFirstStop',
        j.[idLastStop] AS 'journey.idLastStop',
        j.[startTime] AS 'journey.time'
    FROM 
        [UrbanBus].[journeyInstance] AS ji
    JOIN 
        [UrbanBus].[journey] AS j ON ji.[idJourney] = j.[id]
    WHERE
        j.[idLine] = @line
