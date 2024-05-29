SELECT [number], [designation], [idFirstStop], [idLastStop], [color],
    fs.[designation], fs.[location], fs.[longitude], fs.[latitude],
    ls.[designation], ls.[location], ls.[longitude], ls.[latitude]
FROM [UrbanBus].[line] AS l
JOIN [UrbanBus].[stop] AS fs
ON l.[idFirstStop] = fs.[id]
JOIN [UrbanBus].[stop] AS ls
ON l.[idLastStop] = ls.[id];

