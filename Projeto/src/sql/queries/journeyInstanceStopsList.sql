DECLARE @journeyInstance int = ?;

SELECT s.[id], s.[name], s.[location], s.[longitude], s.[latitude], s.[time]
FROM getOrderedJourneyStopsList(SELECT ji.[journey] FROM [UrbanBus].[journeyInstance] AS ji) as s;