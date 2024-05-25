-- Get client data by token

SELECT [UrbanBus].[client].[number], [UrbanBus].[client].[name], [UrbanBus].[client].[email], [UrbanBus].[client].[nif]
FROM [UrbanBus].[client]
WHERE [UrbanBus].[client].[token] = ?;
