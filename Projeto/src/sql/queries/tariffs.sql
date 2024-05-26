-- Query all tariffs

SELECT [UrbanBus].[itemTariff].[id], [UrbanBus].[itemTariff].[value], [UrbanBus].[itemTariff].[zoneNumber], [UrbanBus].[subscription].[days], [UrbanBus].[trips].[tripsCount]
FROM [UrbanBus].[itemTariff]
LEFT JOIN [UrbanBus].[subscription]
ON [UrbanBus].[itemTariff].[id] = [UrbanBus].[subscription].[itemId]
LEFT JOIN [UrbanBus].[trips]
ON [UrbanBus].[itemTariff].[id] = [UrbanBus].[trips].[itemId];
