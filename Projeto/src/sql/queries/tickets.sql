-- Get all tickets in database

SELECT [UrbanBus].[transportTicket].[number], [UrbanBus].[transportTicket].[zoneNumber], [UrbanBus].[transportTicket].[clientNumber], [UrbanBus].[subscriptionTicket].[ticketNumber], [UrbanBus].[tripsTicket].[ticketNumber]
FROM [UrbanBus].[transportTicket]
LEFT JOIN [UrbanBus].[subscriptionTicket]
ON [UrbanBus].[transportTicket].[number] = [UrbanBus].[subscriptionTicket].[ticketNumber]
LEFT JOIN [UrbanBus].[tripsTicket]
ON [UrbanBus].[transportTicket].[number] = [UrbanBus].[tripsTicket].[ticketNumber];

