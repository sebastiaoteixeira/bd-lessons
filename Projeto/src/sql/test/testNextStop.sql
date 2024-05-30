DECLARE @idJourneyInstance INT = 33;
DECLARE @nextStop INT;
EXEC @nextStop = getNextJourneyInstanceStop @idJourneyInstance;

SELECT @idJourneyInstance;
SELECT @nextStop;

IF @nextStop IS NULL
BEGIN
    RAISERROR('Journey instance not started yet', 16, 1);
    RETURN;
END

SELECT s.[id], s.[name], s.[location], s.[latitude], s.[longitude]
FROM [UrbanBus].[stop] AS s
WHERE s.[id] = @nextStop;