-- Get stop_journeyInstance by idJourneyInstance
SELECT [UrbanBus].[stop_journeyInstance].[idStop],
    [UrbanBus].[stop_journeyInstance].[stopTime],
    s.[name], s.[location], s.[latitude], s.[longitude]
FROM [UrbanBus].[stop_journeyInstance]
JOIN [UrbanBus].[stop] AS s
ON s.[id] = [UrbanBus].[stop_journeyInstance].[idStop]
WHERE [UrbanBus].[stop_journeyInstance].[idJourneyInstance] = ?;
