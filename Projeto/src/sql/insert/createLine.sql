DECLARE @idLine INT = ?;
DECLARE @designation NVARCHAR(255) = ?;
DECLARE @color INT = ?;
DECLARE @inboundStops VARCHAR(1000) = ?;
DECLARE @inboundTimes VARCHAR(1000) = ?;
DECLARE @outboundStops VARCHAR(1000) = ?;
DECLARE @outboundTimes VARCHAR(1000) = ?;

IF EXISTS (SELECT * FROM [UrbanBus].[line] WHERE [number] = @idLine)
BEGIN
    RAISERROR ('The line number is already in use.', 16, 1);
    RETURN;
END

-- Call the procedure
BEGIN TRY
    EXEC createLine @idLine, @designation, @color, @inboundStops, @inboundTimes, @outboundStops, @outboundTimes;
END TRY
BEGIN CATCH
    RAISERROR ('An error occurred while creating the line.', 16, 1);
END CATCH;

