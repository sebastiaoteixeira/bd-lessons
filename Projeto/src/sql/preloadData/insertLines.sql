INSERT INTO [UrbanBus.line] ([number], [designation], [idFirstStop], [idLastStop], [color])
VALUES ('1', 'L1', 1, 6, 1000000);
GO

INSERT INTO [UrbanBus.line_stop] ([idLine], [idStop], [idNextStop], [timeToNext], [outbound])
VALUES (1, 1, 3, '00:05:00', 0),
	   (1, 3, 4, '00:05:00', 0),
	   (1, 4, 6, '00:05:00', 0),
	   (1, 6, 5, '00:05:00', 1),
	   (1, 5, 3, '00:05:00', 1),
	   (1, 3, 2, '00:05:00', 1),
	   (1, 2, 1, '00:05:00', 1);
GO
