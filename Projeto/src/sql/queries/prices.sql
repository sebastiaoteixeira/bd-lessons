DECLARE @firstStop INT = ?;
DECLARE @lastStop INT = ?;

SELECT tariff.[value] AS price, z.[designation] AS zone
FROM [UrbanBus].[zone_stop] AS zs
JOIN [UrbanBus].[zone] AS z
ON z.[id] = zs.[idZone]
JOIN [UrbanBus].[itemTariff] AS tariff
ON tariff.[zoneNumber] = zs.[idZone]
WHERE zs.[idStop1] = @firstStop AND zs.[idStop2] = @lastStop
OR zs.[idStop1] = @lastStop AND zs.[idStop2] = @firstStop;

