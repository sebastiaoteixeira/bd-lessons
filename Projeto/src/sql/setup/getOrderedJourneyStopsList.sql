-- Returns a list of stops for a journey, ordered by stop order

CREATE OR ALTER FUNCTION getOrderedJourneyStopsList
(
	@journeyNumber INT
)
RETURNS @result TABLE
(
	[id] INT,
	[name] VARCHAR(255),
	[location] VARCHAR(255),
	[longitude] DECIMAL(9,6),
	[latitude] DECIMAL(9,6),
	[time] TIME
)
AS
BEGIN
	DECLARE @firstStop INT;
	DECLARE @lastStop INT;
	DECLARE @lineNumber INT;
	DECLARE @time TIME;
	DECLARE @outbound BIT;

	SELECT @lineNumber = idLine, @firstStop = idFirstStop, @lastStop = idLastStop, @time = startTime, @outbound = outbound
	FROM [UrbanBus].[journey]
	WHERE [id] = @journeyNumber;

	-- Get the firstStop
	INSERT INTO @result
	SELECT s.[id], s.[name], s.[location], s.[longitude], s.[latitude], @time
	FROM [UrbanBus].[stop] AS s
	JOIN [UrbanBus].[line_stop] AS ls
	ON s.id = ls.idStop
	WHERE ls.idLine = @lineNumber
	AND ls.idStop = @firstStop
	AND ls.outbound = @outbound;

	-- Get the rest of the stops
	WHILE @firstStop != @lastStop
		BEGIN
			-- Verify if there is an exception
			IF NOT EXISTS
			(
				SELECT 1
				FROM [UrbanBus].[exceptions] AS e
				WHERE e.idJourney = @journeyNumber
				AND e.idStop = @firstStop
			)
			BEGIN
				SELECT @firstStop = idNextStop, @time = DATEADD(SECOND, DATEDIFF(SECOND, 0, @time) + DATEDIFF(SECOND, 0, timeToNext), 0)
				FROM [UrbanBus].[line_stop]
				WHERE idLine = @lineNumber
				AND idStop = @firstStop
				AND outbound = @outbound;

				INSERT INTO @result
				SELECT s.[id], s.[name], s.[location], s.[longitude], s.[latitude], @time
				FROM [UrbanBus].[stop] AS s
				JOIN [UrbanBus].[line_stop] AS ls
				ON s.id = ls.idStop
				WHERE ls.idLine = @lineNumber
				AND ls.idStop = @firstStop
				AND ls.outbound = @outbound;
			END
			ELSE
				-- Add timeModification to time
				SELECT @time = DATEADD(SECOND, DATEDIFF(SECOND, 0, @time) + DATEDIFF(SECOND, 0, timeModification), 0)
				FROM [UrbanBus].[exceptions]
				WHERE idJourney = @journeyNumber
				AND idStop = @firstStop;
		END;

	RETURN;
END;


