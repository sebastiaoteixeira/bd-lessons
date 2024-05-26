-- Call the sp createLine

DECLARE @idLine INT = 18;
DECLARE @designation NVARCHAR(255) = 'L18';
DECLARE @color INT = 16711680;
DECLARE @inboundStops VARCHAR(1000) = '1,2,3';
DECLARE @inboundTimes VARCHAR(1000) = '00:05:00,00:10:00,00:15:00';
DECLARE @outboundStops VARCHAR(1000) = '3,2,1';
DECLARE @outboundTimes VARCHAR(1000) = '00:05:00,00:10:00,00:15:00';

EXEC createLine @idLine, @designation, @color, @inboundStops, @inboundTimes, @outboundStops, @outboundTimes;
