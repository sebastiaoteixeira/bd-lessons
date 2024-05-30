-- Call getCurrentJourneyInstanceStop

DECLARE @idJourneyInstance INT = ?;
DECLARE @currentStop INT;
EXEC @currentStop = getCurrentJourneyInstanceStop @idJourneyInstance;

IF @currentStop IS NULL
BEGIN
    RAISERROR('Journey instance not started yet', 16, 1);
    RETURN;
END

SELECT s.[id], s.[name], s.[location], s.[latitude], s.[longitude], sj.[stopTime]
FROM [UrbanBus].[stop] AS s
JOIN [UrbanBus].[stop_journeyInstance] AS sj
ON s.[id] = sj.[idStop]
WHERE sj.[idJourneyInstance] = @idJourneyInstance
AND s.[id] = @currentStop;