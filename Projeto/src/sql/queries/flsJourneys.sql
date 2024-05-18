DECLARE @line INT = ?;
DECLARE @firstStop INT = ?;
DECLARE @lastStop INT = ?;

IF @line IS NULL
		-- Select searchJourneysByStops
		SELECT s.[id], s.[idLine], s.[idFirstStop], s.[idLastStop], s.[startTime], s.[outbound]
		FROM searchJourneysByStops(@stops) as s
ELSE
		-- Select searchJourneysByStops and filter by line
		SELECT s.[id], s.[idLine], s.[idFirstStop], s.[idLastStop], s.[startTime], s.[outbound]
		FROM searchJourneysByStops(@stops) as s WHERE s.[idLine] = @line;
