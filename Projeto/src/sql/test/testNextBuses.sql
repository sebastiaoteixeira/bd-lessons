-- Call nextBuses

DECLARE @myStop INT = 13;

-- DECLARE table @result
DECLARE @result TABLE
(
    [idJourneyInstance] INT,
    [idJourney] INT,
    [idLastStopOfJourney] INT,
    [timeToMyStop] TIME,
    [timeToLastStopOfJourney] TIME,
    [delay] TIME
);

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
    DECLARE @idFirstStop INT;
    DECLARE @idLastStop INT;
    DECLARE @timeToMyStop TIME;
    DECLARE @delay TIME;
    DECLARE @time TIME;
    DECLARE @previousStopTime TIME;
    DECLARE @previousStopDateTime DATETIME;
    DECLARE @previousStop INT;
    DECLARE @stopTime DATETIME;
    DECLARE @idStop INT;
    DECLARE @idNextStop INT;
    DECLARE @outbound BIT;
    DECLARE @startTime TIME;
    DECLARE @ended BIT;

    DECLARE journeyCursor CURSOR FOR
    SELECT [idJourneyInstance], [idFirstStop], [idLastStop], [startTimeJourney], [idJourney], [idLine], [outbound]
    FROM @journeys;

    OPEN journeyCursor;
    FETCH NEXT FROM journeyCursor INTO @idJourneyInstance, @idFirstStop, @idLastStop, @startTime, @idJourney, @idLine, @outbound;
    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Get the time to my stop
        SET @time = @startTime;
        SET @ended = 1
        SET @idStop = @idFirstStop;

        -- Get the first stop
            SELECT @idNextStop = [idNextStop], @time = DATEADD(SECOND, DATEDIFF(SECOND, 0, [timeToNext]), @time)
            FROM [UrbanBus].[line_stop]
            WHERE [idLine] = @idLine
            AND [idStop] = @idStop
            AND [outbound] = @outbound;

        WHILE @idNextStop IS NOT NULL AND @idNextStop <> @idLastStop
        BEGIN
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
                SELECT @time = DATEADD(MINUTE, [timeModification], @time)
                FROM [UrbanBus].[exceptions] AS e
                WHERE e.[idJourney] = @idJourney
                AND e.[idStop] = @idStop;
            END
            --ELSE
            --BEGIN
                IF @idStop = @myStop
                BEGIN
                    SET @timeToMyStop = @time;
                END;

                -- Check if the stop is in stop_journeyInstance
                IF (NOT EXISTS
                (
                    SELECT 1
                    FROM [UrbanBus].[stop_journeyInstance]
                    WHERE [idJourneyInstance] = @idJourneyInstance
                    AND [idStop] = @idStop
                ) AND @ended = 1)
                BEGIN
                    SET @ended = 0

                    -- Get the stopTime
                    SELECT @stopTime = [stopTime]
                    FROM [UrbanBus].[stop_journeyInstance]
                    WHERE [idJourneyInstance] = @idJourneyInstance
                    AND [idStop] = @previousStop;

                    -- Convert previousTime to datetime with the date today
                    SET @previousStopDateTime = CAST(CAST(GETDATE() AS DATE) AS DATETIME) + CAST(@previousStopTime AS DATETIME);

                    -- Calculate delay
                    IF @stopTime < @previousStopDateTime
                        SET @delay = '00:00:00';
                    ELSE
                        -- Cast the difference to time to prevent overflow
                        BEGIN TRY
                            SET @delay = CAST(DATEADD(SECOND, DATEDIFF(SECOND, @previousStopDateTime, @stopTime), '00:00:00') AS TIME);
                        END TRY
                        BEGIN CATCH
                            SET @delay = NULL;
                        END CATCH;
                END
            --END;


            SET @previousStop = @idStop;
            SET @previousStopTime = @time;
            SET @idStop = @idNextStop;

            -- Accumulate time and get the next stop
            SELECT @idNextStop = [idNextStop], @time = DATEADD(SECOND, DATEDIFF(SECOND, 0, [timeToNext]), @time)
            FROM [UrbanBus].[line_stop]
            WHERE [idLine] = @idLine
            AND [idStop] = @idStop
            AND [outbound] = @outbound;
        END;

        -- Insert the result
        --IF @ended = 0
            INSERT INTO @result
            VALUES (@idJourneyInstance, @idJourney, @idLastStop, @timeToMyStop, @time, @delay);


        FETCH NEXT FROM journeyCursor INTO @idJourneyInstance, @idFirstStop, @idLastStop, @startTime, @idJourney, @idLine, @outbound;
    END;


SELECT nb.[idJourneyInstance], j.[idLine], nb.[idJourney],
    s.[name], s.[location], s.[longitude], s.[latitude],
    nb.[timeToMyStop], nb.[delay],
    ls.[id], ls.[name], ls.[location], ls.[longitude], ls.[latitude], nb.[timeToLastStopOfJourney],
    j.[outbound]
FROM @result AS nb
JOIN [UrbanBus].[stop] AS s
ON s.[id] = @myStop
JOIN [UrbanBus].[stop] AS ls
ON ls.[id] = nb.[idLastStopOfJourney]
JOIN [UrbanBus].[journey] AS j
ON j.[id] = nb.[idJourney];

