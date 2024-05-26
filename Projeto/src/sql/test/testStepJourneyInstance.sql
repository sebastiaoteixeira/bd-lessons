
DECLARE @journey INT = 4;

INSERT INTO [UrbanBus].[journeyInstance] ([idJourney], [startTime])
VALUES (@journey, GETDATE());
GO

DECLARE @idJourneyInstance INT = SCOPE_IDENTITY();
SELECT @idJourneyInstance;

-- Call journeyInstanceEnded
DECLARE @ended BIT = 0;
EXEC @ended = journeyInstanceEnded @idJourneyInstance;
SELECT @ended;

-- Call getCurrentJourneyInstanceStop
DECLARE @currentStop INT;
EXEC @currentStop = getCurrentJourneyInstanceStop @idJourneyInstance;
SELECT @currentStop;

-- Call getNextJourneyInstanceStop
DECLARE @nextStop INT;
EXEC @nextStop = getNextJourneyInstanceStop @idJourneyInstance;
SELECT @nextStop;

-- Call stepJourneyInstance
EXEC stepJourneyInstance @idJourneyInstance, @nextStop OUTPUT;
SELECT @nextStop;
GO

DECLARE @idJourneyInstance INT;
-- get last inserted idJourneyInstance
SELECT @idJourneyInstance = MAX([id])
FROM [UrbanBus].[journeyInstance];

DECLARE @ended BIT;
DECLARE @currentStop INT;
DECLARE @nextStop INT;

-- Call journeyInstanceEnded
EXEC @ended = journeyInstanceEnded @idJourneyInstance;
SELECT @ended;

-- Call getCurrentJourneyInstanceStop
EXEC @currentStop = getCurrentJourneyInstanceStop @idJourneyInstance;
SELECT @currentStop;

-- Call getNextJourneyInstanceStop
EXEC @nextStop = getNextJourneyInstanceStop @idJourneyInstance;
SELECT @nextStop;

-- Call stepJourneyInstance
EXEC stepJourneyInstance @idJourneyInstance, @nextStop OUTPUT;
SELECT @nextStop;
GO

DECLARE @idJourneyInstance INT;
-- get last inserted idJourneyInstance
SELECT @idJourneyInstance = MAX([id])
FROM [UrbanBus].[journeyInstance];

DECLARE @ended BIT;
DECLARE @currentStop INT;
DECLARE @nextStop INT;

-- Call stepJourneyInstance
EXEC stepJourneyInstance @idJourneyInstance, @nextStop OUTPUT;
SELECT @nextStop;
GO

DECLARE @idJourneyInstance INT;
-- get last inserted idJourneyInstance
SELECT @idJourneyInstance = MAX([id])
FROM [UrbanBus].[journeyInstance];

DECLARE @ended BIT;
DECLARE @currentStop INT;
DECLARE @nextStop INT;

-- Call journeyInstanceEnded
EXEC @ended = journeyInstanceEnded @idJourneyInstance;
SELECT @ended;

-- Call getCurrentJourneyInstanceStop
EXEC @currentStop = getCurrentJourneyInstanceStop @idJourneyInstance;
SELECT @currentStop;

-- Call getNextJourneyInstanceStop
EXEC @nextStop = getNextJourneyInstanceStop @idJourneyInstance;
SELECT @nextStop;



-- Call journeyInstanceEnded
EXEC @ended = journeyInstanceEnded @idJourneyInstance;
SELECT @ended;

-- Call getCurrentJourneyInstanceStop
EXEC @currentStop = getCurrentJourneyInstanceStop @idJourneyInstance;
SELECT @currentStop;

-- Call getNextJourneyInstanceStop
EXEC @nextStop = getNextJourneyInstanceStop @idJourneyInstance;
SELECT @nextStop;

