INSERT INTO [UrbanBus].[itemTariff] ([zoneNumber], [value])
VALUES
-- Z1
(1, 11),
(1, 1),
-- Z2
(2, 22),
(2, 2);

GO

INSERT INTO [UrbanBus].[subscription] ([itemId], [days])
VALUES
(1, 30),
(3, 30);

GO

INSERT INTO [UrbanBus].[trips] ([itemId], [tripsCount])
VALUES
(2, 10),
(4, 10);