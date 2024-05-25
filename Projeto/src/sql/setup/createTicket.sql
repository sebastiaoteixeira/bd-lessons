-- An SP to create a new ticket for a given user

CREATE OR ALTER PROCEDURE createTicket
    @ticketType VARCHAR(255),
    @zone INT,
    @userToken CHAR(64)
AS
BEGIN
    -- Get user data by token
    DECLARE @userId INT;
    SELECT @userId = [UrbanBus].[client].[number]
    FROM [UrbanBus].[client]
    WHERE [UrbanBus].[client].[token] = @userToken;

    DECLARE @ticketNumber INT;

    -- Verify the ticket type
    IF @ticketType = 'subscription'
    BEGIN
        INSERT INTO [UrbanBus].[transportTicket] ([clientNumber], [zoneNumber])
        VALUES (@userId, @zone);

        -- Get the ticket number
        SELECT @ticketNumber = [UrbanBus].[transportTicket].[number]
        FROM [UrbanBus].[transportTicket]
        WHERE [UrbanBus].[transportTicket].[clientNumber] = @userId

        -- Insert the subscription ticket
        INSERT INTO [UrbanBus].[subscriptionTicket] ([ticketNumber])
        VALUES (@ticketNumber);

    END
    ELSE IF @ticketType = 'trips'
    BEGIN

        INSERT INTO [UrbanBus].[transportTicket] ([clientNumber], [zoneNumber])
        VALUES (@userId, @zone);

        -- Get the ticket number
        SELECT @ticketNumber = [UrbanBus].[transportTicket].[number]
        FROM [UrbanBus].[transportTicket]
        WHERE [UrbanBus].[transportTicket].[clientNumber] = @userId

        -- Insert the trips ticket
        INSERT INTO [UrbanBus].[tripsTicket] ([ticketNumber])
        VALUES (@ticketNumber);

    END
    ELSE
    RAISERROR('Invalid ticket type', 16, 1);

END
