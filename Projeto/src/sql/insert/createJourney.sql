-- call createJourney

DECLARE @idLine INT = ?;
DECLARE @exceptions VARCHAR(1000) = ?;
DECLARE @timeModifiers VARCHAR(1000) = ?;
DECLARE @startTime TIME = ?;
DECLARE @outbound BIT = ?;

EXEC createJourney @idLine, @exceptions, @timeModifiers, @startTime, @outbound;
