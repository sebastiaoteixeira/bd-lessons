-- UDF: getMyTicketsStates
-- Description: Get the state of all the tickets of the user

CREATE OR ALTER FUNCTION getMyTicketsStates
    (@token CHAR(64))
RETURNS @result TABLE
(
    [ticketNumber] INT,
    [zone] INT,
    [expirationDate] DATE,
    [tripsLeft] INT
)
AS
BEGIN
    -- Get the user id
    DECLARE @userId INT;
    SELECT @userId = [UrbanBus].[client].[number]
    FROM [UrbanBus].[client]
    WHERE [UrbanBus].[client].[token] = @token;

    -- Call the getTicketState UDF for each ticket
    DECLARE @ticketNumber INT;
    DECLARE @zone INT;
    DECLARE @expirationDate DATE;
    DECLARE @tripsLeft INT;

    DECLARE @ticketsTable TABLE (ticketNumber INT, zone INT);
    INSERT INTO @ticketsTable
    SELECT [UrbanBus].[transportTicket].[number], [UrbanBus].[transportTicket].[zoneNumber]
    FROM [UrbanBus].[transportTicket]
    WHERE [UrbanBus].[transportTicket].[clientNumber] = @userId;

    DECLARE ticketCursor CURSOR FOR
    SELECT [ticketNumber], [zone]
    FROM @ticketsTable;

    OPEN ticketCursor;
    FETCH NEXT FROM ticketCursor INTO @ticketNumber, @zone;

    WHILE @@FETCH_STATUS = 0
        BEGIN
            INSERT INTO @result
            SELECT ts.[ticketNumber], ts.[zone], ts.[expirationDate], ts.[tripsLeft]
            FROM getTicketState(@ticketNumber) AS ts;

            FETCH NEXT FROM ticketCursor INTO @ticketNumber, @zone;
        END;

    CLOSE ticketCursor;
    DEALLOCATE ticketCursor;

    RETURN;
END

