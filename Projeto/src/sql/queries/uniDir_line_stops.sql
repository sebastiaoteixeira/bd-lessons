SELECT [UrbanBus].[line_stop].[idStop], [UrbanBus].[line_stop].[idNextStop], [UrbanBus].[line_stop].[outbound]
FROM [UrbanBus].[line_stop]
WHERE [UrbanBus].[line_stop].[idLine] = ? AND [UrbanBus].[line_stop].[outbound] = ?;

