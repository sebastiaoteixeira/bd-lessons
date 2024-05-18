-- Procedure: checkPassword
-- Args: clientID INT, password CHAR(64)
-- Returns: BOOLEAN

CREATE PROCEDURE [checkPassword]
	@clientID INT, @password VARCHAR(255), @result BIT OUTPUT
AS BEGIN
	DECLARE @salt CHAR(16);
	DECLARE @hash BINARY(64);
	DECLARE @tempHash BINARY(64);
	DECLARE @tempPassword VARCHAR(255);
	
	SET @salt = (
		SELECT [UrbanBus].[client].[salt] FROM [UrbanBus].[client] WHERE [UrbanBus].[client].[number] = @clientID
	);
	
	SET @tempPassword = @password + @salt;
	
	SET @tempHash = HASHBYTES('SHA2_512', @tempPassword);
	SET @hash = (
		SELECT [UrbanBus].[client].[pHash] FROM [UrbanBus].[client] WHERE [UrbanBus].[client].[number] = @clientID
	);
	
	IF @tempHash = @hash
	BEGIN
		EXEC [createSession] @clientID;
	END;
END;
