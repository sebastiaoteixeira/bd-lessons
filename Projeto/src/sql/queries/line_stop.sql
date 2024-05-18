SELECT s.[name], s.[location], s.[longitude], s.[latitude], ns.[id], ns.[name], ns.[location], ns.[longitude], ns.[latitude], ls.[timeToNext], ls.[outbound]
FROM [UrbanBus].[line_stop] AS ls
JOIN [UrbanBus].[stop] AS s
ON ls.[idStop] = s.[id]
JOIN [UrbanBus].[stop] AS ns
ON ls.[idNextStop] = ns.[id]
WHERE ls.[idLine] = ? AND ls.[idStop] = ?;

