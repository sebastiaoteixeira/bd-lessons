-- Call getNextJourneyInstanceStop

DECLARE @idJourneyInstance INT = ?;
DECLARE @nextStop INT;
EXEC @nextStop = getNextJourneyInstanceStop @idJourneyInstance;

IF @nextStop IS NULL
BEGIN
    RAISERROR('Journey instance not started yet', 16, 1);
    RETURN;
END

SELECT s.[id], s.[name], s.[location], s.[latitude], s.[longitude]
FROM [UrbanBus].[stop] AS s
WHERE s.[id] = @nextStop;