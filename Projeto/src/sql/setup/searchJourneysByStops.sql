-- Select all journeys such as its line has all the stops in @includedStops
-- But no one is in exceptions table

CREATE OR ALTER FUNCTION searchJourneysByStops
(
	@includedStops VARCHAR(1000)
)
RETURNS TABLE
AS
RETURN
(
	WITH SplitStops AS 
	(
		-- Split lines by ',' and convert to int
		SELECT CAST(value AS INT) AS id
		FROM STRING_SPLIT(@includedStops, ',')
	)
	, StopCount AS
	(
		SELECT COUNT(*) AS count
		FROM SplitStops
	)

	SELECT j.[id], j.[idLine], j.[idFirstStop], j.[idLastStop], j.[startTime], j.[outbound]
	FROM [UrbanBus].[journey] AS j
	WHERE NOT EXISTS 
	(
		SELECT 1
		FROM [UrbanBus].[exceptions] AS e
		WHERE e.idJourney = j.id
	)
	AND 
	(
		SELECT COUNT(*)
		FROM [UrbanBus].[line_stop] AS ls
		WHERE ls.idLine = j.idLine
		AND ls.idStop IN (SELECT id FROM SplitStops)
	) = (SELECT count FROM StopCount)
);
