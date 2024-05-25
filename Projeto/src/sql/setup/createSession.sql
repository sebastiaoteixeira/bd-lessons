-- Procedure: createSession
-- Args: clientID INT
-- Returns: sessionID INT

CREATE OR ALTER PROCEDURE [createSession]
	@clientID INT
AS BEGIN
  	DECLARE @CharPool VARCHAR(96) = 'abcdefghijkmnopqrstuvwxyzABCDEFGHIJKLMNPQRSTUVWXYZ0123456789.,-_!$@#%^&*';
  	DECLARE @PoolLength INT = len(@CharPool);
	DECLARE @i INT = 0;
	DECLARE @token CHAR(64);
	DECLARE @tempToken VARCHAR(64);

	SET @tempToken = '';
	WHILE @i < 64
	BEGIN
		SET @tempToken = @tempToken + SUBSTRING(@CharPool, CAST(ROUND(RAND() * (@PoolLength - 1), 0) AS INT) + 1, 1);
		SET @i = @i + 1;
	END;

	SET @token = @tempToken;

	UPDATE [UrbanBus].[client]
		SET [token] = @token
		WHERE [number] = @clientID;

	DECLARE @validityDate DATE;
	SET @validityDate = DATEADD(DAY, 30, GETDATE());

	UPDATE [UrbanBus].[client]
		SET [expiration] = @validityDate
		WHERE [number] = @clientID;
	
	
END;
