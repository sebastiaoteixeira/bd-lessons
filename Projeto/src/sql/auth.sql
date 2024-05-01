DECLARE @clientID INT;
SET @clientID = (
	SELECT [UrbanBus.client].[number] FROM [UrbanBus.client] WHERE [UrbanBus.client].[email] = ?
);

DECLARE @result BIT;

EXEC [checkPassword] @clientID, ?, @result OUTPUT;

SELECT @result;
