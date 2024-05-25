CREATE OR ALTER TRIGGER [UrbanBus].[subscription_itemTariff] ON [UrbanBus].[subscription]
INSTEAD OF INSERT
AS
BEGIN
    DECLARE @days AS integer
    DECLARE @itemId AS integer
    SELECT @days = [days], @itemId = [itemId] FROM inserted

    IF (SELECT COUNT(*) FROM [UrbanBus].[itemTariff] WHERE id = @itemId) = 0
        RAISERROR('Item not found', 16, 1);
    ELSE
        INSERT INTO [UrbanBus].[subscription] ([itemId], [days]) VALUES (@itemId, @days);
END