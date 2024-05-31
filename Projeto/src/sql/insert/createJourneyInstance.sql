-- Start a new journey instance

DECLARE @journey INT = ?;

IF EXISTS (
    SELECT [idJourney] FROM [UrbanBus].[journeyInstance]
    WHERE [idJourney] = @journey
    -- startTime must be greater than now - 1 hour
    AND [startTime] > DATEADD(HOUR, -1, GETDATE())
    )
BEGIN
    RAISERROR('Journey not found or already started', 16, 1);
    RETURN;
END

INSERT INTO [UrbanBus].[journeyInstance] ([idJourney], [startTime])
VALUES (@journey, GETDATE());
