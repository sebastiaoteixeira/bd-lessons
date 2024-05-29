SELECT [UrbanBus].[journey].[idLine], [UrbanBus].[journey].[idFirstStop], [UrbanBus].[journey].[idLastStop], [UrbanBus].[journey].[startTime], [UrbanBus].[journey].[outbound],
    fs.[name] AS firstStopName, fs.[location] AS firstStopLocation, fs.[longitude] AS firstStopLongitude, fs.[latitude] AS firstStopLatitude,
    ls.[name] AS lastStopName, ls.[location] AS lastStopLocation, ls.[longitude] AS lastStopLongitude, ls.[latitude] AS lastStopLatitude,
    l.[designation] AS lineDesignation, l.[color] AS lineColor
FROM [UrbanBus].[journey]
JOIN [UrbanBus].[stop] AS fs
ON [UrbanBus].[journey].[idFirstStop] = fs.[id]
JOIN [UrbanBus].[stop] AS ls
ON [UrbanBus].[journey].[idLastStop] = ls.[id]
JOIN [UrbanBus].[line] AS l
ON [UrbanBus].[journey].[idLine] = l.[number]
WHERE [UrbanBus].[journey].[id] = ?;
