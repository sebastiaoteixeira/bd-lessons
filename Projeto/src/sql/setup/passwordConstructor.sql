-- Procedure: passwordConstructor
-- Args: password VARCHAR(255)
-- Returns: passwordHash CHAR(64), passwordSalt VARCHAR(16)

ALTER PROCEDURE [passwordConstructor]
  @password VARCHAR(255), @passwordHash BINARY(64) OUTPUT, @passwordSalt CHAR(16) OUTPUT
AS BEGIN
  DECLARE @CharPool VARCHAR(96) = 'abcdefghijkmnopqrstuvwxyzABCDEFGHIJKLMNPQRSTUVWXYZ0123456789.,-_!$@#%^&*';
  DECLARE @PoolLength INT = len(@CharPool);
  DECLARE @tempSalt VARCHAR(64);
  DECLARE @i INT = 0;

  SET @tempSalt = '';
  WHILE @i < 16
  BEGIN
	SET @tempSalt = @tempSalt + SUBSTRING(@CharPool, CAST(ROUND(RAND() * (@PoolLength - 1), 0) AS INT) + 1, 1);
	SET @i = @i + 1;
  END;
  SET @passwordSalt = @tempSalt;
  SET @passwordHash = HASHBYTES('SHA2_512', @password + @passwordSalt);
END;

