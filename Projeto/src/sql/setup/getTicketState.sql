-- UDF: getTicketState
-- Description: Verify if the ticket is valid
--              and return the expiration date (if it is a subscription ticket, else null)
--              and the number of trips left (if it is a trips ticket, else null)
--              Should also return the ticket attributes
-- Parameters: ticketNumber INT

CREATE OR ALTER FUNCTION getTicketState
    (@ticketNumber INT)
RETURNS @result TABLE
(
    [ticketNumber] INT,
    [zone] INT,
    [expirationDate] DATE,
    [tripsLeft] INT
)
AS
BEGIN
    -- Get the ticket type
    DECLARE @ticketTypeTable TABLE (idSubscription INT, idTrips INT);
    INSERT INTO @ticketTypeTable
    SELECT [UrbanBus].[subscriptionTicket].[ticketNumber], [UrbanBus].[tripsTicket].[ticketNumber]
    FROM [UrbanBus].[transportTicket]
    LEFT JOIN [UrbanBus].[subscriptionTicket]
    ON [UrbanBus].[transportTicket].[number] = [UrbanBus].[subscriptionTicket].[ticketNumber]
    LEFT JOIN [UrbanBus].[tripsTicket]
    ON [UrbanBus].[transportTicket].[number] = [UrbanBus].[tripsTicket].[ticketNumber]
    WHERE [UrbanBus].[transportTicket].[number] = @ticketNumber;
    
    -- Get the zone of the ticket
    DECLARE @zone INT;
    SELECT @zone = [UrbanBus].[transportTicket].[zoneNumber]
    FROM [UrbanBus].[transportTicket]
    WHERE [UrbanBus].[transportTicket].[number] = @ticketNumber;
    
    -- Verify if the ticket is a subscription
    IF EXISTS (SELECT * FROM @ticketTypeTable WHERE idSubscription IS NOT NULL)
    BEGIN
        -- Get the last charge date and the number of days of the subscription
        DECLARE @lastChargeDate DATE;
        DECLARE @subscriptionDays INT;

        -- Get the last charge date
        SELECT @lastChargeDate = MAX([UrbanBus].[purchasedItem].[date])
        FROM [UrbanBus].[purchasedItem]
        JOIN [UrbanBus].[itemTariff]
        ON [UrbanBus].[purchasedItem].[idItemPreco] = [UrbanBus].[itemTariff].[id]
        JOIN [UrbanBus].[subscription]
        ON [UrbanBus].[itemTariff].[id] = [UrbanBus].[subscription].[itemId]
        WHERE [UrbanBus].[purchasedItem].[idTransportTicket] = @ticketNumber;

        -- Get the number of days of the subscription
        SELECT @subscriptionDays = [UrbanBus].[subscription].[days]
        FROM [UrbanBus].[subscription]
        JOIN [UrbanBus].[itemTariff]
        ON [UrbanBus].[subscription].[itemId] = [UrbanBus].[itemTariff].[id]
        JOIN [UrbanBus].[purchasedItem]
        ON [UrbanBus].[itemTariff].[id] = [UrbanBus].[purchasedItem].[idItemPreco]
        WHERE [UrbanBus].[purchasedItem].[idTransportTicket] = @ticketNumber;

        -- Calculate the expiration date
        DECLARE @expirationDate DATE;
        SET @expirationDate = DATEADD(DAY, @subscriptionDays, @lastChargeDate);

        INSERT INTO @result
        SELECT @ticketNumber, @zone, @expirationDate, NULL;
        
    END
    ELSE IF EXISTS (SELECT * FROM @ticketTypeTable WHERE idTrips IS NOT NULL)
    BEGIN
        -- Get the number of trips left
        DECLARE @totalTrips INT;

        -- Get the sum of all trips bought
        SELECT @totalTrips = SUM([UrbanBus].[trips].[tripsCount])
        FROM [UrbanBus].[trips]
        JOIN [UrbanBus].[purchasedItem]
        ON [UrbanBus].[trips].[itemId] = [UrbanBus].[purchasedItem].[idItemPreco]
        WHERE [UrbanBus].[purchasedItem].[idTransportTicket] = @ticketNumber;

        -- Get the sum of all trips used in validations table
        DECLARE @usedTrips INT;
        SELECT @usedTrips = COUNT(*)
        FROM [UrbanBus].[validation]
        WHERE [UrbanBus].[validation].[numberTransportTicket] = @ticketNumber;

        DECLARE @tripsLeft INT;
        SET @tripsLeft = @totalTrips - @usedTrips;

        INSERT INTO @result
        SELECT @ticketNumber, @zone, NULL, @tripsLeft;
    END

    RETURN;
END
