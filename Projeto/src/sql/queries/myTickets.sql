-- Query that returns the tickets of a client

DECLARE @token CHAR(64) = ?;
DECLARE @onlyValid BIT = ?;

IF @onlyValid = 0
    SELECT t.[ticketNumber], t.[zone], t.[expirationDate], t.[tripsLeft], [UrbanBus].[subscriptionTicket].[ticketNumber], [UrbanBus].[tripsTicket].[ticketNumber]
    FROM getMyTicketsStates(@token) AS t
    LEFT JOIN [UrbanBus].[subscriptionTicket]
    ON t.[ticketNumber] = [UrbanBus].[subscriptionTicket].[ticketNumber]
    LEFT JOIN [UrbanBus].[tripsTicket]
    ON t.[ticketNumber] = [UrbanBus].[tripsTicket].[ticketNumber];
ELSE
BEGIN
    SELECT t.[ticketNumber], t.[zone], t.[expirationDate], t.[tripsLeft], [UrbanBus].[subscriptionTicket].[ticketNumber], [UrbanBus].[tripsTicket].[ticketNumber]
    FROM getMyTicketsStates(@token) AS t
    LEFT JOIN [UrbanBus].[subscriptionTicket]
    ON t.[ticketNumber] = [UrbanBus].[subscriptionTicket].[ticketNumber]
    LEFT JOIN [UrbanBus].[tripsTicket]
    ON t.[ticketNumber] = [UrbanBus].[tripsTicket].[ticketNumber]
    WHERE (
        t.[tripsLeft] IS NOT NULL
        AND t.[tripsLeft] > 0
    ) OR (
        t.[expirationDate] IS NOT NULL
        AND t.[expirationDate] > GETDATE()
    );
END

