-- UDF: Get the current stop of a journey instance
-- Parameters: idJourneyInstance INT
-- Returns: idStop INT

CREATE OR ALTER FUNCTION getNextJourneyInstanceStop
(
    @idJourneyInstance INT
)
RETURNS INT
AS
BEGIN
    DECLARE @journey INT;
    DECLARE @line INT;  
    DECLARE @firstS INT;
    DECLARE @lastS INT;
    DECLARE @outbound BIT;
    DECLARE @time TIME;
    DECLARE @nextStop INT;
    DECLARE @stop INT;

    SELECT @journey = [idJourney]
    FROM [UrbanBus].[journeyInstance]
    WHERE [id] = @idJourneyInstance;

    SELECT @line = [idLine], @firstS = [idFirstStop], @lastS = [idLastStop]
    FROM [UrbanBus].[journey]
    WHERE [id] = @journey;

    SELECT @outbound = [outbound]
    FROM [UrbanBus].[line_stop]
    WHERE [idLine] = @line AND [idStop] = @lastS;

    -- Declare variables to iterate over stops
    DECLARE @idStop INT;
    DECLARE @idNextStop INT;
    DECLARE @timeToNext TIME;

    IF @outbound = 0
    BEGIN
    
        -- Iterate over stops in line_stop to get the last stop
        SELECT @idStop = [idStop], @idNextStop = [idNextStop], @timeToNext = [timeToNext]
        FROM [UrbanBus].[line_stop]
        WHERE [idLine] = @line
        AND [idStop] = @firstS
        AND [outbound] = 0;

        WHILE @idNextStop IS NOT NULL
        BEGIN
            -- Verify if the stop is not in exceptions
            IF NOT EXISTS (
                SELECT *
                FROM [UrbanBus].[exceptions]
                WHERE [idJourney] = @journey
                AND [idStop] = @idStop
            )
            BEGIN
                -- Verify if the stop is in stop_journeyInstance
                IF NOT EXISTS (
                    SELECT *
                    FROM [UrbanBus].[stop_journeyInstance]
                    WHERE [idJourneyInstance] = @idJourneyInstance
                    AND [idStop] = @idStop
                ) RETURN @idStop;
            END;

            -- Get next stop
            SELECT @idStop = [idStop], @idNextStop = [idNextStop], @timeToNext = [timeToNext]
            FROM [UrbanBus].[line_stop]
            WHERE [idLine] = @line
            AND [idStop] = @idNextStop
            AND [outbound] = 0;
        END;
        
        -- Verify last stop
        IF NOT EXISTS (
            SELECT *
            FROM [UrbanBus].[exceptions]
            WHERE [idJourney] = @journey
            AND [idStop] = @idStop
        )
            IF NOT EXISTS (
                SELECT *
                FROM [UrbanBus].[stop_journeyInstance]
                WHERE [idJourneyInstance] = @idJourneyInstance
                AND [idStop] = @idStop
            ) RETURN @idStop;
            ELSE
                RETURN NULL;
        ELSE
            RETURN NULL;

    END
    ELSE
    BEGIN

        -- Iterate over stops in line_stop to get the last stop
        SELECT @idStop = [idStop], @idNextStop = [idNextStop], @timeToNext = [timeToNext]
        FROM [UrbanBus].[line_stop]
        WHERE [idLine] = @line
        AND [idStop] = @lastS
        AND [outbound] = 1;

        WHILE @idNextStop IS NOT NULL
        BEGIN
            -- Verify if the stop is not in exceptions
            IF NOT EXISTS (
                SELECT *
                FROM [UrbanBus].[exceptions]
                WHERE [idJourney] = @journey
                AND [idStop] = @idStop
            )
            BEGIN
                -- Verify if the stop is in stop_journeyInstance
                IF NOT EXISTS (
                    SELECT *
                    FROM [UrbanBus].[stop_journeyInstance]
                    WHERE [idJourneyInstance] = @idJourneyInstance
                    AND [idStop] = @idStop
                ) RETURN @idStop;
            END;

            -- Get next stop
            SELECT @idStop = [idStop], @idNextStop = [idNextStop], @timeToNext = [timeToNext]
            FROM [UrbanBus].[line_stop]
            WHERE [idLine] = @line
            AND [idStop] = @idNextStop
            AND [outbound] = 1;
        END;

        -- Verify last stop
        IF NOT EXISTS (
            SELECT *
            FROM [UrbanBus].[exceptions]
            WHERE [idJourney] = @journey
            AND [idStop] = @idStop
        )
            IF NOT EXISTS (
                SELECT *
                FROM [UrbanBus].[stop_journeyInstance]
                WHERE [idJourneyInstance] = @idJourneyInstance
                AND [idStop] = @idStop
            ) RETURN @idStop;
            ELSE
                RETURN NULL;
        ELSE
            RETURN NULL;

    END;

    RETURN NULL;
END;

