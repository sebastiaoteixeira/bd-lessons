CREATE TRIGGER [UrbanBus].[trips_itemTariff] ON [UrbanBus].[trips]
INSTEAD OF INSERT
AS
BEGIN
    DECLARE @tripsCount AS integer
    DECLARE @itemId AS integer
    SELECT @tripsCount = tripsCount, @itemId = itemId FROM inserted

    IF (SELECT COUNT(*) FROM [UrbanBus].[itemTariff] WHERE id = @itemId) = 0
        RAISERROR('Item not found', 16, 1);
    ELSE
        INSERT INTO [UrbanBus].[trips] (itemId, tripsCount) VALUES (@itemId, @tripsCount);
END