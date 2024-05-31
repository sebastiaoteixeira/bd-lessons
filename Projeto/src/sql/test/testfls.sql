
DECLARE @firstStop INT = 49;
DECLARE @lastStop INT = 16;
DECLARE @result TABLE (
    [id] INT,
	[idLine] INT,
	[idFirstStop] INT,
	[idLastStop] INT,
	[startTime] TIME,
	[firstStopTime] TIME,
	[lastStopTime] TIME,
	[outbound] BIT
);

    DECLARE @stopsString VARCHAR(1000) = CAST(@firstStop AS VARCHAR(10)) + ',' + CAST(@lastStop AS VARCHAR(10));

	-- Verify if both stops are in the same line calling the function searchJourneysByStops
	INSERT INTO @result
	SELECT s.[id], s.[idLine], s.[idFirstStop], s.[idLastStop], s.[startTime], null, null, s.[outbound]
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
    DECLARE @startTime TIME;
	DECLARE @time TIME;
	DECLARE @nextStop INT;
	DECLARE @stop INT;

	DECLARE journeyCursor CURSOR FOR
	SELECT [id], [idLine], [idFirstStop], [idLastStop], [startTime], [outbound]
	FROM @result;

	OPEN journeyCursor;
	FETCH NEXT FROM journeyCursor INTO @journey, @line, @firstS, @lastS, @startTime, @outbound;

	DECLARE @firstStopFound BIT;
	
	WHILE @@FETCH_STATUS = 0
		BEGIN
			SELECT @firstStopFound = 0;
			SET @stop = @firstS;
            SET @time = @startTime;
			WHILE 1 = 1
				BEGIN
					IF @stop = @firstStop
                    BEGIN
						SET @firstStopFound = 1;
						UPDATE @result
						SET [firstStopTime] = @time
						WHERE [id] = @journey;
                    END;

					SELECT @nextStop = ls.[idNextStop], @time = DATEADD(SECOND, DATEDIFF(SECOND, 0, @time) + DATEDIFF(SECOND, 0, ls.[timeToNext]), 0)
					FROM [UrbanBus].[line_stop] AS ls
					WHERE ls.[idLine] = @line
					AND ls.[idStop] = @stop
                    AND ls.[outbound] = @outbound;
					
					-- If stop is in exceptions, add timeModifier to @time
					SELECT @time = DATEADD(SECOND, DATEDIFF(SECOND, 0, @time) + DATEDIFF(SECOND, 0, timeModification), 0)
					FROM [UrbanBus].[exceptions]
					WHERE idJourney = @journey
					AND idStop = @stop;

					IF @nextStop = @lastStop AND @firstStopFound = 1
                    BEGIN
						UPDATE @result
						SET [lastStopTime] = @time
						WHERE [id] = @journey;
						BREAK;
                    END;
					IF @nextStop IS NULL
						BEGIN
							DELETE FROM @result
							WHERE [id] = @journey;
							BREAK;
						END;
					SET @stop = @nextStop;
				END;
			FETCH NEXT FROM journeyCursor INTO @journey, @line, @firstS, @lastS, @startTime, @outbound;
		END;

	CLOSE journeyCursor;
	DEALLOCATE journeyCursor;

SELECT * FROM @result;