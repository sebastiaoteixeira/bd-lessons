DECLARE @journeyInstance INT = ?;
DECLARE @ticketId INT = ?;

-- Call validate
EXEC validate @journeyInstance, @ticketId;


