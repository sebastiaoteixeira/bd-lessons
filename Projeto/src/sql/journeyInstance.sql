SELECT [UrbanBus.journeyInstance].[startTime], [UrbanBus.journey].[id], [UrbanBus.journey].[idLine], [UrbanBus.journey].[idFirstStop], [UrbanBus.journey].[idLastStop], [UrbanBus.journey].[startTime]
FROM [UrbanBus.journeyInstance]
JOIN [UrbanBus.journey] ON [UrbanBus.journey].[id] = [UrbanBus.journeyInstance].[idJourney]
WHERE [UrbanBus.journeyInstance].[id] = ?;
