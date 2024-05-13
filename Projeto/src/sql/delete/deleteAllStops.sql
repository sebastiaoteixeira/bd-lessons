-- delete all rows from the table UrbanBus.stop
DELETE FROM [UrbanBus.stop];

-- reset id to 1
DBCC CHECKIDENT ('[UrbanBus.stop]', RESEED, 0);