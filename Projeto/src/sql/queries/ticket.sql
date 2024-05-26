-- Get a ticket state

DECLARE @ticketNumber INT = ?;

SELECT ts.[ticketNumber], ts.[zone], ts.[expirationDate], ts.[tripsLeft], [UrbanBus].[transportTicket].[clientNumber]
FROM getTicketState(@ticketNumber) AS ts
JOIN [UrbanBus].[transportTicket]
ON ts.[ticketNumber] = [UrbanBus].[transportTicket].[number];