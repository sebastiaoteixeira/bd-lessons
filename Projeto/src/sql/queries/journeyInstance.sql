-- Get journey instance
SELECT [UrbanBus].[JourneyInstance].[startTime], [UrbanBus].[Journey].[id], [UrbanBus].[Journey].[idLine], [UrbanBus].[Journey].[idFirstStop], [UrbanBus].[Journey].[idLastStop], [UrbanBus].[Journey].[outbound],
    fs.[name] AS firstStopName, fs.[location] AS firstStopLocation, fs.[longitude] AS firstStopLongitude, fs.[latitude] AS firstStopLatitude,
    ls.[name] AS lastStopName, ls.[location] AS lastStopLocation, ls.[longitude] AS lastStopLongitude, ls.[latitude] AS lastStopLatitude,
    l.[designation] AS lineDesignation, l.[color] AS lineColor
FROM [UrbanBus].[journeyInstance]
JOIN [UrbanBus].[journey]
ON [UrbanBus].[journey].[id] = [UrbanBus].[journeyInstance].[idJourney]
JOIN [UrbanBus].[stop] AS fs
ON [UrbanBus].[journey].[idFirstStop] = fs.[id]
JOIN [UrbanBus].[stop] AS ls
ON [UrbanBus].[journey].[idLastStop] = ls.[id]
JOIN [UrbanBus].[line] AS l
ON [UrbanBus].[journey].[idLine] = l.[number]
WHERE [UrbanBus].[journeyInstance].[id] = ?;