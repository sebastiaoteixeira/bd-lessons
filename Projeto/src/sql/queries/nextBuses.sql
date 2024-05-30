-- Call nextBuses

DECLARE @myStop INT = ?;

SELECT nb.[idJourneyInstance], j.[idLine], nb.[idJourney],
    s.[name], s.[location], s.[longitude], s.[latitude],
    nb.[timeToMyStop], nb.[delay],
    ls.[id], ls.[name], ls.[location], ls.[longitude], ls.[latitude], nb.[timeToLastStopOfJourney],
    j.[outbound]
FROM nextBuses(@myStop) AS nb
JOIN [UrbanBus].[stop] AS s
ON s.[id] = @myStop
JOIN [UrbanBus].[stop] AS ls
ON ls.[id] = nb.[idLastStopOfJourney]
JOIN [UrbanBus].[journey] AS j
ON j.[id] = nb.[idJourney];

