-- FUNCTION to get journeys that have a 2 stops and the is in the direction of the stops

CREATE OR ALTER FUNCTION searchJourneysWithSLStop
(
	@firstStop INT,
	@lastStop INT
)
RETURNS @result TABLE
(
	[id] INT,
	[idLine] INT,
	[idFirstStop] INT,
	[idLastStop] INT,
	[startTime] TIME,
	[outbound] BIT
)
AS
BEGIN
	DECLARE @stopsString VARCHAR(1000) = CAST(@firstStop AS VARCHAR(10)) + ',' + CAST(@lastStop AS VARCHAR(10));

	-- Verify if both stops are in the same line calling the function searchJourneysByStops
	INSERT INTO @result
	SELECT s.[id], s.[idLine], s.[idFirstStop], s.[idLastStop], s.[startTime], s.[outbound]
	FROM searchJourneysByStops(@stopsString) AS s;

	-- If @result is empty, return empty		
	IF @@ROWCOUNT = 0
		RETURN;
	
	-- If not, for all the results, remove if the stops are not in the same order
	DECLARE @journey INT;
	DECLARE @line INT;
	DECLARE @firstS INT;
	DECLARE @lastS INT;
	DECLARE @outbound BIT;
	DECLARE @time TIME;
	DECLARE @nextStop INT;
	DECLARE @stop INT;

	DECLARE journeyCursor CURSOR FOR
	SELECT [id], [idLine], [idFirstStop], [idLastStop], [startTime], [outbound]
	FROM @result;

	OPEN journeyCursor;
	FETCH NEXT FROM journeyCursor INTO @journey, @line, @firstS, @lastS, @time, @outbound;
	
	WHILE @@FETCH_STATUS = 0
		BEGIN
			SET @stop = @firstStop;
			WHILE @stop != @lastS
				BEGIN
					SELECT @nextStop = idNextStop, @time = DATEADD(SECOND, DATEDIFF(SECOND, 0, @time) + DATEDIFF(SECOND, 0, timeToNext), 0)
					FROM [UrbanBus].[line_stop]
					WHERE idLine = @line
					AND idStop = @stop;

					IF @nextStop = @lastStop
						BREAK;
					IF @nextStop IS NULL
						BEGIN
							DELETE FROM @result
							WHERE [id] = @journey;
							BREAK;
						END;
					SET @stop = @nextStop;
				END;
			FETCH NEXT FROM journeyCursor INTO @journey, @line, @firstS, @lastS, @time, @outbound;
		END;

	CLOSE journeyCursor;
	DEALLOCATE journeyCursor;

	RETURN;
END;

