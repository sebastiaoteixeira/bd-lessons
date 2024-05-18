DECLARE @line INT = ?;
DECLARE @stops VARCHAR(1000) = ?;

IF @line IS NULL
	IF @stops IS NULL
		-- Select all journeys
		SELECT [UrbanBus].[journey].[id], [UrbanBus].[journey].[idLine], [UrbanBus].[journey].[idFirstStop], [UrbanBus].[journey].[idLastStop], [UrbanBus].[journey].[startTime], [UrbanBus].[journey].[outbound] FROM [UrbanBus].[journey];
	ELSE
		-- Select searchJourneysByStops
		SELECT s.[id], s.[idLine], s.[idFirstStop], s.[idLastStop], s.[startTime], s.[outbound]
		FROM searchJourneysByStops(@stops) as s;
ELSE
	IF @stops IS NULL
		-- Select searchJourneysByLine
		SELECT [UrbanBus].[journey].[id], [UrbanBus].[journey].[idLine], [UrbanBus].[journey].[idFirstStop], [UrbanBus].[journey].[idLastStop], [UrbanBus].[journey].[startTime], [UrbanBus].[journey].[outbound] FROM [UrbanBus].[journey] WHERE [UrbanBus].[journey].[idLine] = @line;
	ELSE
		-- Select searchJourneysByStops and filter by line
		SELECT s.[id], s.[idLine], s.[idFirstStop], s.[idLastStop], s.[startTime], s.[outbound]
		FROM searchJourneysByStops(@stops) as s WHERE s.[idLine] = @line;
