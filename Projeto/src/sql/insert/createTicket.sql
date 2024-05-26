-- Create a new ticket

DECLARE @ticketType VARCHAR(255) = ?;
DECLARE @zone INT = ?;
DECLARE @userToken CHAR(64) = ?;

-- Call the SP
EXEC createTicket @ticketType, @zone, @userToken;

