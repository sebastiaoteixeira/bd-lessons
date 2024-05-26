-- An SP to create a new line
-- Parameters: @number, @designation, @color, @inboundStops, @inboundTimes
-- @outboundStops, @outboundTimes

CREATE OR ALTER PROCEDURE [createLine]
    @number integer,
    @designation nvarchar(255),
    @color integer,
    @inboundStops varchar(1000),
    @inboundTimes varchar(1000),
    @outboundStops varchar(1000),
    @outboundTimes varchar(1000)
AS
BEGIN
    -- Convert varchars into tables
    DECLARE @inboundStopsTable TABLE (id integer IDENTITY(1,1), idStop integer);
    DECLARE @inboundTimesTable TABLE (id integer IDENTITY(1,1), timeToNext time);
    DECLARE @outboundStopsTable TABLE (id integer IDENTITY(1,1), idStop integer);
    DECLARE @outboundTimesTable TABLE (id integer IDENTITY(1,1), timeToNext time);

    -- Inbound tables
    INSERT INTO @inboundStopsTable
    SELECT value
    FROM STRING_SPLIT(@inboundStops, ',');

    INSERT INTO @inboundTimesTable
    SELECT value
    FROM STRING_SPLIT(@inboundTimes, ',');

    -- Outbound tables
    INSERT INTO @outboundStopsTable
    SELECT value
    FROM STRING_SPLIT(@outboundStops, ',');

    INSERT INTO @outboundTimesTable
    SELECT value
    FROM STRING_SPLIT(@outboundTimes, ',');

    -- Check if the number is already in use
    IF EXISTS (SELECT * FROM [UrbanBus].[line] WHERE [number] = @number)
    BEGIN
        RAISERROR ('The line number is already in use.', 16, 1);
        RETURN;
    END

    -- Insert line
    BEGIN TRANSACTION;
    BEGIN TRY
        INSERT INTO [UrbanBus].[line] ([number], [designation], [idFirstStop], [idLastStop], [color])
        VALUES (@number, @designation, (SELECT TOP 1 idStop FROM @inboundStopsTable), (SELECT TOP 1 idStop FROM @outboundStopsTable), @color);


        -- Insert stops in line_stop
        DECLARE @idStop integer;
        DECLARE @idNextStop integer;
        DECLARE @timeToNext time;
        DECLARE @timeToNext2 time;
        DECLARE @outbound bit;

        -- Inbound
        DECLARE inboundCursor CURSOR FOR
        SELECT idStop, timeToNext
        FROM @inboundStopsTable AS inboundStopsTable
        JOIN @inboundTimesTable AS inboundTimesTable
        ON inboundStopsTable.id = inboundTimesTable.id

        OPEN inboundCursor;
        FETCH NEXT FROM inboundCursor INTO @idStop, @timeToNext;
        WHILE 1 = 1
        BEGIN
            -- Fetch next stop
            FETCH NEXT FROM inboundCursor INTO @idNextStop, @timeToNext2;
            IF @@FETCH_STATUS <> 0
            BEGIN
                BREAK;
            END

            -- Insert stop
            INSERT INTO [UrbanBus].[line_stop] ([idLine], [idStop], [idNextStop], [timeToNext], [outbound])
            VALUES (@number, @idStop, @idNextStop, @timeToNext, 1);

            -- Move to next stop
            SET @idStop = @idNextStop;
            SET @timeToNext = @timeToNext2;
        END
        -- Insert last stop
        INSERT INTO [UrbanBus].[line_stop] ([idLine], [idStop], [idNextStop], [timeToNext], [outbound])
        VALUES (@number, @idStop, NULL, NULL, 1);

        CLOSE inboundCursor;
        DEALLOCATE inboundCursor;

        -- Outbound
        DECLARE outboundCursor CURSOR FOR
        SELECT idStop, timeToNext
        FROM @outboundStopsTable AS outboundStopsTable
        JOIN @outboundTimesTable AS outboundTimesTable
        ON outboundStopsTable.id = outboundTimesTable.id

        OPEN outboundCursor;
        FETCH NEXT FROM outboundCursor INTO @idStop, @timeToNext;
        WHILE 1 = 1
        BEGIN
            -- Fetch next stop
            FETCH NEXT FROM outboundCursor INTO @idNextStop, @timeToNext2;
            IF @@FETCH_STATUS <> 0
            BEGIN
                BREAK;
            END
            
            -- Insert stop
            INSERT INTO [UrbanBus].[line_stop] ([idLine], [idStop], [idNextStop], [timeToNext], [outbound])
            VALUES (@number, @idStop, @idNextStop, @timeToNext, 0);

            -- Move to next stop
            SET @idStop = @idNextStop;
            SET @timeToNext = @timeToNext2;
        END
        -- Insert last stop
        INSERT INTO [UrbanBus].[line_stop] ([idLine], [idStop], [idNextStop], [timeToNext], [outbound])
        VALUES (@number, @idStop, NULL, NULL, 0);

        CLOSE outboundCursor;
        DEALLOCATE outboundCursor;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        RAISERROR ('An error occurred while creating the line.', 16, 1);
    END CATCH;
END;    




