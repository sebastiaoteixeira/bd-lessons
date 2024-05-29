--  Get all validations in a given journeyInstances
SELECT v.numberTransportTicket, v.idJourneyInstance, v.idStop, v.time
FROM [UrbanBus].[validation] AS v
WHERE v.idJourneyInstance = ?;

