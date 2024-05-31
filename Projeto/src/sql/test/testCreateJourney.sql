    DECLARE @idLine INT = 1;
   DECLARE @exceptions VARCHAR(1000) = '';
   DECLARE @timeModifiers VARCHAR(1000) = '';
   DECLARE @startTime TIME = '12:41:00';
   DECLARE @outbound BIT = 0;



    -- convert exceptions varchar into table
    DECLARE @exceptionsTable TABLE (id integer IDENTITY(1,1), idStop integer);
    INSERT INTO @exceptionsTable
    SELECT value
    FROM STRING_SPLIT(@exceptions, ',')
    WHERE value <> '';

    -- convert timeModifiers varchar into table
    DECLARE @timeModifiersTable TABLE (id integer IDENTITY(1,1), [value] time);
    INSERT INTO @timeModifiersTable
    SELECT value
    FROM STRING_SPLIT(@timeModifiers, ',')
    WHERE value <> '';


    DECLARE @firstStopFound BIT = 0;

    DECLARE @idFirstStop INT;
    DECLARE @idLastStop INT;
    DECLARE @idStop INT;
    DECLARE @idNextStop INT;
    DECLARE @timeModification INT;

    -- get the first stop of the line
    IF @outbound = 0
    BEGIN
        SET @idStop = (SELECT idFirstStop FROM [UrbanBus].[line] AS l WHERE l.number = @idLine);
    END
    ELSE
    BEGIN
        SET @idStop = (SELECT idLastStop FROM [UrbanBus].[line] AS l WHERE l.number = @idLine);
    END

    -- verify if the first stop is an exception
    IF NOT EXISTS (SELECT * FROM @exceptionsTable WHERE idStop = @idStop)
    BEGIN
        SET @idFirstStop = @idStop;

        SET @firstStopFound = 1;
    END;


    -- get the first next stop
    SELECT @idNextStop = [idNextStop]
    FROM [UrbanBus].[line_stop]
    WHERE idLine = @idLine AND idStop = @idStop AND outbound = @outbound;


    WHILE @idNextStop IS NOT NULL
    BEGIN

        -- check if the stop is an exception
        IF NOT EXISTS (SELECT * FROM @exceptionsTable WHERE idStop = @idNextStop)
        BEGIN
            IF @firstStopFound = 0
            BEGIN
                SET @idFirstStop = @idNextStop;
                SET @firstStopFound = 1;
            END;

            SET @idLastStop = @idNextStop;
        END

        -- get the next stop
        SELECT @idNextStop = [idNextStop]
        FROM [UrbanBus].[line_stop]
        WHERE idLine = @idLine AND idStop = @idStop AND outbound = @outbound;

        -- update @idStop
        SET @idStop = @idNextStop;
    END

    -- insert journey
    INSERT INTO [UrbanBus].[journey] (idLine, idFirstStop, idLastStop, startTime, outbound)
    VALUES (@idLine, @idFirstStop, @idLastStop, @startTime, @outbound);

    -- Get id
    DECLARE @idJourney INT;
    SET @idJourney = (SELECT MAX(id) FROM [UrbanBus].[journey]);

    -- insert exceptions
    INSERT INTO [UrbanBus].[exceptions] (idJourney, idStop, timeModification)
    SELECT @idJourney, e.idStop, t.value
    FROM @exceptionsTable as e
    JOIN @timeModifiersTable as t
    ON e.id = t.id;