INSERT INTO [UrbanBus].[line] ([number], [designation], [idFirstStop], [idLastStop], [color])
VALUES
	(1, 'L1', 49, 18, 14878482),
	(2, 'L2', 49, 18, 9680588),
	(3, 'L3', 49, 18, 2041941),
	(4, 'L4', 49, 18, 15073406),
	(5, 'L5', 49, 18, 12373760),
	(6, 'L6', 49, 18, 5880509),
	(7, 'L7', 49, 18, 1464705),
	(8, 'L8', 49, 18, 15626755),
	(10, 'L10', 49, 18, 1012608),
	(11, 'L11', 49, 18, 6903456),
	(12, 'L12', 49, 18, 15060480);
GO

INSERT INTO [UrbanBus].[line_stop] ([idLine], [idStop], [idNextStop], [timeToNext], [outbound])
VALUES 
	-- L1
	--ida
		-- Z2
		(1, 49, 41, '00:05:00', 1),
		(1, 41, 42, '00:05:00', 1),
		(1, 42, 13, '00:05:00', 1),
		-- Z1
		(1, 13, 14, '00:05:00', 1),
		(1, 14, 16, '00:05:00', 1),
		(1, 16, 37, '00:05:00', 1),
		(1, 37, 2, '00:05:00', 1),
		(1, 2, 3, '00:05:00', 1),
		(1, 3, 4, '00:05:00', 1),
		(1, 4, 5, '00:05:00', 1),
		(1, 5, 9, '00:05:00', 1),
		(1, 9, 12, '00:05:00', 1),
		(1, 12, 18, '00:05:00', 1),
		(1, 18, null, '00:00:00', 1),
	-- volta
		(1, 18, 19, '00:05:00', 0),
		(1, 19, 11, '00:05:00', 0),
		(1, 11, 10, '00:05:00', 0),
		(1, 10, 6, '00:05:00', 0),
		(1, 6, 4, '00:05:00', 0),
		(1, 4, 3, '00:05:00', 0),
		(1, 3, 1, '00:05:00', 0),
		(1, 1, 38, '00:05:00', 0),
		(1, 38, 17, '00:05:00', 0),
		(1, 17, 15, '00:05:00', 0),
		(1, 15, 13, '00:05:00', 0),
		-- Z2
		(1, 13, 43, '00:05:00', 0),
		(1, 43, 69, '00:05:00', 0),
		(1, 69, 46, '00:05:00', 0),
		(1, 46, null, '00:00:00', 0);
GO
