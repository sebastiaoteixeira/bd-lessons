DECLARE @idJourneyInstance INT;
-- Get highest journeyInstance id
SELECT @idJourneyInstance = MAX([id])
FROM [UrbanBus].[journeyInstance];

SELECT @idJourneyInstance;

DECLARE @s INT;

-- Call getCurrentJourneyInstanceStop
EXEC @s = getCurrentJourneyInstanceStop @idJourneyInstance;
SELECT @s;

-- Call getNextJourneyInstanceStop
EXEC @s = getNextJourneyInstanceStop @idJourneyInstance;
SELECT @s;

-- Call journeyInstanceEnded
DECLARE @ended BIT
EXEC @ended = journeyInstanceEnded @idJourneyInstance;
SELECT @ended;

-- Call stepJourneyInstance
EXEC stepJourneyInstance @idJourneyInstance;
