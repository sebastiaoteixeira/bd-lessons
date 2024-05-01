SELECT COUNT(*)
FROM [UrbanBus.client]
WHERE [token] = @token AND [expiration] > GETDATE();

