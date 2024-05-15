DECLARE @zone AS INTEGER
DECLARE @value AS DECIMAL(5,2)
DECLARE @tripsCount AS INTEGER
DECLARE @days AS INTEGER

SET @zone = ?
SET @value = ?
SET @tripsCount = ?
SET @days = ?

EXEC insertItemTariff @zone, @value, @tripsCount, @days