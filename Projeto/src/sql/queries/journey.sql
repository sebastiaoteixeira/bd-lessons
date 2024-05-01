SELECT [UrbanBus.journey].[idLine], [UrbanBus.journey].[idFirstStop], [UrbanBus.journey].[idLastStop], [UrbanBus.journey].[startTime], [UrbanBus.journey].[outbound]
FROM [UrbanBus.journey]
WHERE [UrbanBus.journey].[id] = ?
