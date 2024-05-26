-- Start a new journey instance

DECLARE @journey INT = ?;

INSERT INTO [UrbanBus].[journeyInstance] ([idJourney], [startTime])
VALUES (@journey, GETDATE());
