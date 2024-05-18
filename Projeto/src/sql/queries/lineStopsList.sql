DECLARE @line INT = ?;
DECLARE @outbound BIT = ?;

SELECT s.[id], s.[name], s.[location], s.[longitude], s.[latitude]
FROM getOrderedLineStopsList(@line, @outbound) as s;

