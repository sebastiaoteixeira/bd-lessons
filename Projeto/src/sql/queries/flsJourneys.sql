DECLARE @line INT = ?;
DECLARE @firstStop INT = ?;
DECLARE @lastStop INT = ?;

IF @line IS NULL
	-- CALL searchJourneysWithFLStop
	SELECT s.[id], s.[idLine], s.[idFirstStop], s.[idLastStop], s.[startTime], s.[firstStopTime], s.[lastStopTime], s.[outbound], fst.[name], fst.[location], fst.[longitude], fst.[latitude], lst.[name], lst.[location], lst.[longitude], lst.[latitude], l.[designation], l.[color], fs.[name], fs.[location], fs.[longitude], fs.[latitude], ls.[name], ls.[location], ls.[longitude], ls.[latitude]
	FROM searchJourneysWithFLStop(@firstStop, @lastStop) AS s
	JOIN [UrbanBus].[stop] AS fst
	ON s.[idFirstStop] = fst.[id]
	JOIN [UrbanBus].[stop] AS lst
	ON s.[idLastStop] = lst.[id]
	JOIN [UrbanBus].[line] AS l
	ON s.[idLine] = l.[number]
	JOIN [UrbanBus].[stop] AS fs
	ON fs.[id] = @firstStop
	JOIN [UrbanBus].[stop] AS ls
	ON ls.[id] = @lastStop;
ELSE
	-- CALL searchJourneysWithFLStop and filter by line
	SELECT s.[id], s.[idLine], s.[idFirstStop], s.[idLastStop], s.[startTime], s.[firstStopTime], s.[lastStopTime], s.[outbound], fst.[name], fst.[location], fst.[longitude], fst.[latitude], lst.[name], lst.[location], lst.[longitude], lst.[latitude], l.[designation], l.[color], fs.[name], fs.[location], fs.[longitude], fs.[latitude], ls.[name], ls.[location], ls.[longitude], ls.[latitude]
	FROM searchJourneysWithFLStop(@firstStop, @lastStop) AS s
	JOIN [UrbanBus].[stop] AS fst
	ON s.[idFirstStop] = fst.[id]
	JOIN [UrbanBus].[stop] AS lst
	ON s.[idLastStop] = lst.[id]
	JOIN [UrbanBus].[line] AS l
	ON s.[idLine] = l.[number]
	JOIN [UrbanBus].[stop] AS fs
	ON fs.[id] = @firstStop
	JOIN [UrbanBus].[stop] AS ls
	ON ls.[id] = @lastStop
	WHERE s.[idLine] = @line;
