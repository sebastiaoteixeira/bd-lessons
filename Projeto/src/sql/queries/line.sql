SELECT l.[designation], l.[idFirstStop], l.[idLastStop], l.[color],
    fs.[name], fs.[location], fs.[longitude], fs.[latitude],
    ls.[name], ls.[location], ls.[longitude], ls.[latitude]
FROM [UrbanBus].[line] AS l
JOIN [UrbanBus].[stop] AS fs
ON l.[idFirstStop] = fs.[id]
JOIN [UrbanBus].[stop] AS ls
ON l.[idLastStop] = ls.[id]
WHERE l.[number] = ?;

