-- Returns a list of stops for a line, ordered by stop order

CREATE OR ALTER FUNCTION getOrderedLineStopsList
(
	@lineNumber INT,
	@outbound BIT
)
RETURNS @result TABLE
(
	[id] INT,
	[name] VARCHAR(255),
	[location] VARCHAR(255),
	[longitude] DECIMAL(9,6),
	[latitude] DECIMAL(9,6)
)
AS
BEGIN
	DECLARE @firstStop INT;
	DECLARE @lastStop INT;

	IF @outbound = 0
		SELECT @firstStop = idFirstStop, @lastStop = idLastStop
		FROM [UrbanBus].[line]
		WHERE [number] = @lineNumber;
	ELSE
		SELECT @firstStop = idLastStop, @lastStop = idFirstStop
		FROM [UrbanBus].[line]
		WHERE [number] = @lineNumber;

	-- Get the firstStop
	INSERT INTO @result
	SELECT s.[id], s.[name], s.[location], s.[longitude], s.[latitude]
	FROM [UrbanBus].[stop] AS s
	JOIN [UrbanBus].[line_stop] AS ls
	ON s.id = ls.idStop
	WHERE ls.idLine = @lineNumber
	AND ls.outbound = @outbound
	AND ls.idStop = @firstStop;



	-- Get the rest of the stops
	WHILE @firstStop != @lastStop
		BEGIN
			SELECT @firstStop = idNextStop
			FROM [UrbanBus].[line_stop]
			WHERE idLine = @lineNumber
			AND idStop = @firstStop
			AND outbound = @outbound;

			INSERT INTO @result
			SELECT s.[id], s.[name], s.[location], s.[longitude], s.[latitude]
			FROM [UrbanBus].[stop] AS s
			JOIN [UrbanBus].[line_stop] AS ls
			ON s.id = ls.idStop
			WHERE ls.idLine = @lineNumber
			AND ls.outbound = @outbound
			AND ls.idStop = @firstStop;

		END;
	RETURN;
END;

