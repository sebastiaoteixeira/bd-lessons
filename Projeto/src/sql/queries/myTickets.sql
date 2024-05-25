-- Query that returns the tickets of a client

DECLARE @token CHAR(64) = ?;
DECLARE @onlyValid BIT = ?;

IF @onlyValid = 0
    SELECT [UrbanBus].[transportTicket].[number], [UrbanBus].[transportTicket].[zoneNumber], [UrbanBus].[subscriptionTicket].[ticketNumber] AS subscriptionNumber, [UrbanBus].[tripsTicket].[ticketNumber] AS tripsNumber
    FROM [UrbanBus].[client]
    JOIN [UrbanBus].[transportTicket]
    ON [UrbanBus].[client].[number] = [UrbanBus].[transportTicket].[clientNumber]
    LEFT JOIN [UrbanBus].[subscriptionTicket]
    ON [UrbanBus].[transportTicket].[number] = [UrbanBus].[subscriptionTicket].[ticketNumber]
    LEFT JOIN [UrbanBus].[tripsTicket]
    ON [UrbanBus].[transportTicket].[number] = [UrbanBus].[tripsTicket].[ticketNumber]
    WHERE [UrbanBus].[client].[token] = @token;
