SELECT [UrbanBus.client].[token]
FROM [UrbanBus.client]
WHERE [UrbanBus.client].[email] = ? AND [UrbanBus.client].[expiration] > GETDATE();
