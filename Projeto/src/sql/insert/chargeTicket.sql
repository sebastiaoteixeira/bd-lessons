-- Charge ticket
DECLARE @ticketNumber INT = ?;
DECLARE @item INT = ?;

-- Call the SP
EXEC chargeTicket @ticketNumber, @item;