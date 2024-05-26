-- SP: validate
-- Parameters: idJourneyInstance INT
--             ticketId INT

CREATE OR ALTER PROCEDURE validate
(
    @idJourneyInstance INT,
    @ticketId INT
)
AS
BEGIN
    -- Call journeyInstanceEnded
    DECLARE @ended BIT;
    EXEC @ended = journeyInstanceEnded @idJourneyInstance;
    IF @ended = 1
    BEGIN
        RAISERROR('Journey instance ended', 16, 1);
        RETURN;
    END

    -- Call getCurrentJourneyInstanceStop
    DECLARE @currentStop INT;
    EXEC @currentStop = getCurrentJourneyInstanceStop @idJourneyInstance;

    IF @currentStop IS NULL
    BEGIN
        RAISERROR('Journey instance not started yet', 16, 1);
        RETURN;
    END

    -- Insert in validation
    INSERT INTO [UrbanBus].[validation] ([idJourneyInstance], [idStop], [numberTransportTicket], [time])
    VALUES (@idJourneyInstance, @currentStop, @ticketId, GETDATE());
END;
