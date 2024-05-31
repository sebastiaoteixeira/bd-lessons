DECLARE @lineId INT = 1;

DECLARE @result TABLE
(
    id INT,
    idLine INT,
    idFirstStop INT,
    idLastStop INT,
    startTime TIME,
    lastStopTime TIME,
    outbound BIT
);

    -- set @result as the result of the query
    INSERT INTO @result
    SELECT j.[id], j.[idLine], j.[idFirstStop], j.[idLastStop], j.[startTime], NULL, j.[outbound]
    FROM [UrbanBus].[journey] AS j
    WHERE j.[idLine] = @lineId;

    -- iterate over the result to get the last stop time
    DECLARE @id INT;
    DECLARE @idFirstStop INT;
    DECLARE @idLastStop INT;
    DECLARE @startTime TIME;
    DECLARE @outbound BIT;
    DECLARE @lastStopTime TIME;
    DECLARE @idStop INT;
    DECLARE @idNextStop INT;
    DECLARE @timeToNext TIME;
    DECLARE @timeModification TIME;

    -- iterate over the result
    DECLARE CURSOR1 CURSOR FOR
    SELECT id, idFirstStop, idLastStop, startTime, outbound
    FROM @result;

    OPEN CURSOR1;
    FETCH NEXT FROM CURSOR1 INTO @id, @idFirstStop, @idLastStop, @startTime, @outbound;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- get the last stop time
        SELECT @idStop = [idStop], @idNextStop = [idNextStop], @timeToNext = [timeToNext]
        FROM [UrbanBus].[line_stop]
        WHERE [idLine] = @lineId
        AND [idStop] = @idFirstStop
        AND [outbound] = @outbound;

        -- time = startTime + timeToNext
        SET @lastStopTime = DATEADD(SECOND, DATEDIFF(SECOND, '00:00:00', @startTime), '00:00:00');

        WHILE @idNextStop IS NOT NULL AND @idNextStop <> @idLastStop
        BEGIN
            -- Get the next stop
            SELECT @idNextStop = [idNextStop], @timeToNext = [timeToNext]
            FROM [UrbanBus].[line_stop]
            WHERE [idLine] = @lineId
            AND [idStop] = @idStop
            AND [outbound] = @outbound;

            -- time = time + timeToNext
            SET @lastStopTime = DATEADD(SECOND, DATEDIFF(SECOND, '00:00:00', @lastStopTime) + DATEDIFF(SECOND, '00:00:00', @timeToNext), '00:00:00');


            -- Verify if the stop is in exceptions
            IF EXISTS (
                SELECT *
                FROM [UrbanBus].[exceptions]
                WHERE [idJourney] = @id
                AND [idStop] = @idStop
            )
            BEGIN
                -- Add the time modification
                SELECT @timeModification = [timeModification]
                FROM [UrbanBus].[exceptions]
                WHERE [idJourney] = @id
                AND [idStop] = @idStop;
                SET @lastStopTime = DATEADD(SECOND, DATEDIFF(SECOND, '00:00:00', @lastStopTime) + DATEDIFF(SECOND, '00:00:00', @timeModification), '00:00:00');
            END;
            

            SET @idStop = @idNextStop;
        END;

        -- set the last stop time
        UPDATE @result
        SET lastStopTime = @lastStopTime
        WHERE id = @id;

        FETCH NEXT FROM CURSOR1 INTO @id, @idFirstStop, @idLastStop, @startTime, @outbound;
    END;

    CLOSE CURSOR1;
    DEALLOCATE CURSOR1;

SELECT * FROM @result;