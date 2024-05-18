DECLARE @journey INT = ?;

SELECT s.[id], s.[name], s.[location], s.[longitude], s.[latitude], s.[time]
FROM getOrderedJourneyStopsList(@journey) as s;
