ALTER PROCEDURE insertItemTariff (@zone INTEGER, @value DECIMAL(5,2), @tripsCount INTEGER = NULL, @days INTEGER = NULL)
AS

-- Check if tripsCount is not null or days is not null
IF (@tripsCount IS NOT NULL AND @days IS NOT NULL)
    RAISERROR('Only one of tripsCount or days can be not null', 16, 1);
-- Check if tripsCount is null and days is null
IF (@tripsCount IS NULL AND @days IS NULL)
    RAISERROR('tripsCount or days must be not null', 16, 1);

-- Insert itemTariff
INSERT INTO [UrbanBus.itemTariff] ([zoneNumber], [value]) VALUES (@zone, @value);

DECLARE @lastId AS INTEGER
SELECT @lastId = SCOPE_IDENTITY();
-- Check if tripsCount is not null
IF (@tripsCount IS NOT NULL)
    INSERT INTO [UrbanBus.trips] (itemId, tripsCount) VALUES (@lastId, @tripsCount);
-- Check if days is not null
IF (@days IS NOT NULL)
    INSERT INTO [UrbanBus.subscription] (itemId, days) VALUES (@lastId, @days);

