SELECT s.[id], s.[name], s.[location], s.[longitude], s.[latitude], ns.[id], ns.[name], ns.[location], ns.[longitude], ns.[latitude], nls.[timeToNext], nls.[outbound]
FROM [UrbanBus].[line_stop] AS ls
JOIN [UrbanBus].[line_stop] AS nls
ON ls.[idNextStop] = nls.[idStop]
JOIN [UrbanBus].[stop] AS s
ON nls.[idStop] = s.[id]
JOIN [UrbanBus].[stop] AS ns
ON nls.[idNextStop] = ns.[id]
WHERE ls.[idLine] = ? AND ls.[idStop] = ? AND ls.[outbound] = ?;

