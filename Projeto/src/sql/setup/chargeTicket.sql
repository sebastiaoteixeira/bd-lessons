-- An SP to charge a ticket

CREATE OR ALTER PROCEDURE chargeTicket
    @ticketNumber INT,
    @item INT
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

    -- Verify if ticketNumber and item are from the same zone
    IF NOT EXISTS (
        SELECT *
        FROM [UrbanBus].[itemTariff]
        JOIN [UrbanBus].[transportTicket]
        ON [UrbanBus].[itemTariff].[zoneNumber] = [UrbanBus].[transportTicket].[zoneNumber]
        WHERE [UrbanBus].[itemTariff].[id] = @item
        )
        RAISERROR('Invalid item', 16, 1);
    
    IF EXISTS (SELECT * FROM @ticketTypeTable WHERE idSubscription IS NOT NULL)
    BEGIN
        -- Verify if the item exists in the subscription
        IF EXISTS (SELECT * FROM [UrbanBus].[itemTariff] WHERE [UrbanBus].[itemTariff].[id] = @item)
            -- Insert the subscription item in the purchasedItem table
            INSERT INTO [UrbanBus].[purchasedItem] ([idItemPreco], [idTransportTicket], [date])
            VALUES
            (
                @item,
                @ticketNumber,
                GETDATE()
            );
        ELSE
            RAISERROR('Invalid item', 16, 1);
    END
    ELSE IF EXISTS (SELECT * FROM @ticketTypeTable WHERE idTrips IS NOT NULL)
    BEGIN
        -- Verify if the item exists in the trips
        IF EXISTS (SELECT * FROM [UrbanBus].[itemTariff] WHERE [UrbanBus].[itemTariff].[id] = @item)
            -- Insert the trips item in the purchasedItem table
            INSERT INTO [UrbanBus].[purchasedItem] ([idItemPreco], [idTransportTicket], [date])
            VALUES
            (
                @item,
                @ticketNumber,
                GETDATE()
            );
        ELSE
            RAISERROR('Invalid item', 16, 1);
    END
    ELSE
    BEGIN
        RAISERROR('Invalid ticket number', 16, 1);
    END
END
