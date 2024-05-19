DECLARE @line INT = ?;
DECLARE @firstStop INT = ?;
DECLARE @lastStop INT = ?;

IF @line IS NULL
	-- CALL searchJourneysWithSLStop
	SELECT s.[id], s.[idLine], s.[idFirstStop], s.[idLastStop], s.[startTime], s.[firstStopTime], s.[lastStopTime], s.[outbound]
	FROM searchJourneysWithSLStop(@firstStop, @lastStop) AS s;
ELSE
	-- CALL searchJourneysWithSLStop and filter by line
	SELECT s.[id], s.[idLine], s.[idFirstStop], s.[idLastStop], s.[startTime], s.[firstStopTime], s.[lastStopTime], s.[outbound]
	FROM searchJourneysWithSLStop(@firstStop, @lastStop) AS s
	WHERE s.[idLine] = @line;
