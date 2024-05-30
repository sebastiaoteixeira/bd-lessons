DECLARE @line INT = ?;
DECLARE @stops VARCHAR(1000) = ?;

IF @line IS NULL
	IF @stops IS NULL
		-- Select all journeys
		SELECT [UrbanBus].[journey].[id], [UrbanBus].[journey].[idLine], [UrbanBus].[journey].[idFirstStop], [UrbanBus].[journey].[idLastStop], [UrbanBus].[journey].[startTime], [UrbanBus].[journey].[outbound], fs.[name], fs.[location], fs.[longitude], fs.[latitude], ls.[name], ls.[location], ls.[longitude], ls.[latitude], l.[designation], l.[color]
		FROM [UrbanBus].[journey]
		JOIN [UrbanBus].[stop] AS fs
		ON [UrbanBus].[journey].[idFirstStop] = fs.[id]
		JOIN [UrbanBus].[stop] AS ls
		ON [UrbanBus].[journey].[idLastStop] = ls.[id]
		JOIN [UrbanBus].[line] AS l
		ON [UrbanBus].[journey].[idLine] = l.[number];
	ELSE
		-- Select searchJourneysByStops
		SELECT s.[id], s.[idLine], s.[idFirstStop], s.[idLastStop], s.[startTime], s.[outbound], fs.[name], fs.[location], fs.[longitude], fs.[latitude], ls.[name], ls.[location], ls.[longitude], ls.[latitude], l.[designation], l.[color]
		FROM searchJourneysByStops(@stops) as s
		JOIN [UrbanBus].[stop] AS fs
		ON s.[idFirstStop] = fs.[id]
		JOIN [UrbanBus].[stop] AS ls
		ON s.[idLastStop] = ls.[id]
		JOIN [UrbanBus].[line] AS l
		ON s.[idLine] = l.[number]
ELSE
	IF @stops IS NULL
		-- Select searchJourneysByLine
		SELECT jbl.[id], jbl.[idLine], jbl.[idFirstStop], jbl.[idLastStop], jbl.[startTime], jbl.[outbound], fs.[name], fs.[location], fs.[longitude], fs.[latitude], ls.[name], ls.[location], ls.[longitude], ls.[latitude], l.[designation], l.[color], jbl.[lastStopTime]
		FROM getJourneysByLine(@line) AS jbl
		JOIN [UrbanBus].[stop] AS fs
		ON jbl.[idFirstStop] = fs.[id]
		JOIN [UrbanBus].[stop] AS ls
		ON jbl.[idLastStop] = ls.[id]
		JOIN [UrbanBus].[line] AS l
		ON jbl.[idLine] = l.[number];
	ELSE
		-- Select searchJourneysByStops and filter by line
		SELECT s.[id], s.[idLine], s.[idFirstStop], s.[idLastStop], s.[startTime], s.[outbound], fs.[name], fs.[location], fs.[longitude], fs.[latitude], ls.[name], ls.[location], ls.[longitude], ls.[latitude], l.[designation], l.[color]
		FROM searchJourneysByStops(@stops) as s
		JOIN [UrbanBus].[stop] AS fs
		ON s.[idFirstStop] = fs.[id]
		JOIN [UrbanBus].[stop] AS ls
		ON s.[idLastStop] = ls.[id]
		JOIN [UrbanBus].[line] AS l
		ON s.[idLine] = l.[number]
		WHERE s.[idLine] = @line;
