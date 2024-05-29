-- UDF: next buses
-- Parameter: myStop
-- Returns: idJourneyInstance, idLastStopOfJourney, timeToMyStop, timeToLastStopOfJourney, delay

-- myStop should be a stop in the line
-- myStop should not be in exceptions of the journey
-- myStop should not be in the stops_journeyInstance of the journeyInstance
-- myStop should not be the last stop of the journey
-- the delay should be the difference between the expected time to the next stop
-- and the actual time, 0 if it's negative

CREATE OR ALTER FUNCTION nextBuses
(
    @myStop INT
)
RETURNS @result TABLE
(
    [idJourneyInstance] INT,
    [idJourney] INT,
    [idLastStopOfJourney] INT,
    [timeToMyStop] TIME,
    [timeToLastStopOfJourney] TIME,
    [delay] TIME
)
AS
BEGIN
    -- Call searchJourneysByStops
    DECLARE @myStopString VARCHAR(1000);
    SET @myStopString = CAST(@myStop AS VARCHAR(1000));

    DECLARE @journeys TABLE 
    (
        [idJourney] INT,
        [idLine] INT,
        [idFirstStop] INT,
        [idLastStop] INT,
        [startTimeJourney] TIME,
        [outbound] BIT,
        [idJourneyInstance] INT,
        [startTimeJourneyInstance] TIME    
    );
    INSERT INTO @journeys
    SELECT
        j.[id],
        j.[idLine],
        j.[idFirstStop],
        j.[idLastStop],
        j.[startTime],
        j.[outbound],
        ji.[id],
        ji.[startTime]
    FROM searchJourneysByStops(@myStopString) AS j
    JOIN [UrbanBus].[journeyInstance] AS ji
    ON j.[id] = ji.[idJourney]
    WHERE [idLastStop] <> @myStop
    AND NOT EXISTS
    (
        SELECT 1
        FROM [UrbanBus].[stop_journeyInstance] AS sji
        WHERE sji.[idJourneyInstance] = ji.[id]
        AND sji.[idStop] = @myStop
    );

    -- Iterate over the journeys to calculate the time to my stop
    DECLARE @idJourneyInstance INT;
    DECLARE @idJourney INT;
    DECLARE @idLine INT;
    DECLARE @idLastStopOfJourney INT;
    DECLARE @timeToMyStop TIME;
    DECLARE @timeToLastStopOfJourney TIME;
    DECLARE @delay TIME;
    DECLARE @time TIME;
    DECLARE @nextStopTime TIME;
    DECLARE @idStop INT;
    DECLARE @idNextStop INT;
    DECLARE @outbound BIT;
    DECLARE @startTime TIME;
    DECLARE @ended BIT;

    DECLARE journeyCursor CURSOR FOR
    SELECT [idJourneyInstance], [idLastStop], [startTimeJourney], [idJourney], [idLine], [outbound]
    FROM @journeys;

    OPEN journeyCursor;
    FETCH NEXT FROM journeyCursor INTO @idJourneyInstance, @idLastStopOfJourney, @startTime, @idJourney, @idLine, @outbound;
    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Get the time to my stop
        SELECT @time = @startTime;
        SET @ended = 1;
        WHILE @idNextStop <> @idLastStopOfJourney
        BEGIN
            -- Accumulate time and get the next stop
            SELECT @idStop = [idStop], @idNextStop = [idNextStop], @time = DATEADD(SECOND, DATEDIFF(SECOND, 0, [timeToNext]), @time)
            FROM [UrbanBus].[line_stop]
            WHERE [idLine] = @idLine
            AND [idStop] = @idStop
            AND [outbound] = @outbound;

            -- Check if the stop is in exceptions
            IF EXISTS
            (
                SELECT 1
                FROM [UrbanBus].[exceptions]
                WHERE [idJourney] = @idJourney
                AND [idStop] = @idStop
            )
            BEGIN
                -- Add timeModification
                SELECT @time = DATEADD(SECOND, DATEDIFF(SECOND, 0, e.[timeModification]), @time)
                FROM [UrbanBus].[exceptions] AS e
                WHERE e.[idJourney] = @idJourney
                AND e.[idStop] = @idStop;
            END
            ELSE
            BEGIN
                IF @idStop = @myStop
                BEGIN
                    SET @timeToMyStop = @time;
                END;

                -- Check if the stop is in stop_journeyInstance
                IF NOT EXISTS
                (
                    SELECT 1
                    FROM [UrbanBus].[stop_journeyInstance]
                    WHERE [idJourneyInstance] = @idJourneyInstance
                    AND [idStop] = @idStop
                ) AND @ended = 1
                BEGIN
                    SET @ended = 0;

                    -- Get the time of the nextStop
                    SELECT @nextStopTime = DATEADD(SECOND, DATEDIFF(SECOND, 0, [timeToNext]), @time)
                    FROM [UrbanBus].[line_stop]
                    WHERE [idLine] = @idLine
                    AND [idStop] = @idNextStop
                    AND [outbound] = @outbound;

                    -- Calculate delay
                    IF @nextStopTime < @time
                        SET @delay = '00:00:00';
                    ELSE
                        SET @delay = DATEADD(SECOND, DATEDIFF(SECOND, @time, @nextStopTime), '00:00:00');
                END
            END

            SET @idStop = @idNextStop;
        END;

        SELECT @timeToLastStopOfJourney = @time;

        -- Insert the result
        IF @ended = 0
            INSERT INTO @result
            VALUES (@idJourneyInstance, @idJourney, @idLastStopOfJourney, @timeToMyStop, @timeToLastStopOfJourney, @delay);


        FETCH NEXT FROM journeyCursor INTO @idJourneyInstance, @idLastStopOfJourney, @startTime, @idJourney, @idLine, @outbound;
    END;

    RETURN;
END;

    

