-- SP: step journey instance to next stop
-- Parameters: idJourneyInstance INT

CREATE OR ALTER PROCEDURE stepJourneyInstance
(
    @idJourneyInstance INT
)
AS
BEGIN
    -- Call journeyInstanceEnded
    DECLARE @ended BIT;
    EXEC @ended = journeyInstanceEnded @idJourneyInstance;
    IF @ended = 1
    BEGIN
        RETURN;
    END

    -- Get next stop
    DECLARE @nextStop INT;
    EXEC @nextStop = getNextJourneyInstanceStop @idJourneyInstance;

    -- Insert stop in stop_journeyInstance
    INSERT INTO [UrbanBus].[stop_journeyInstance] ([idJourneyInstance], [idStop], [stopTime])
    VALUES (@idJourneyInstance, @nextStop, GETDATE());

END
