SELECT COUNT(*)
FROM [UrbanBus.client]
WHERE [token] = ? AND [expiration] > GETDATE();

