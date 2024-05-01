DECLARE @clientID INT;
SET @clientID = (
	SELECT [UrbanBus.client].[number] FROM [UrbanBus.client] WHERE [UrbanBus.client].[email] = ?
);


DECLARE @token CHAR(256);

EXEC [createSession] @clientID, @token OUTPUT;

