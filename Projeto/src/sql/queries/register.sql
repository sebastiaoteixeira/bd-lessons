DECLARE @email NVARCHAR(255) = ?;
DECLARE @password NVARCHAR(255) = ?;
DECLARE @name NVARCHAR(255) = ?;
DECLARE @nif INT = ?;

DECLARE @passwordHash BINARY(64);
DECLARE @passwordSalt CHAR(16);

EXEC [passwordConstructor] @password, @passwordHash OUTPUT, @passwordSalt OUTPUT;

INSERT INTO [UrbanBus.client] ([name], [email], [nif], [pHash], [salt])
VALUES (@name, @email, @nif, @passwordHash, @passwordSalt);


DECLARE @clientID INT;
SET @clientID = (
	SELECT [UrbanBus.client].[number] FROM [UrbanBus.client] WHERE [UrbanBus.client].[email] = @email
);

EXEC [createSession] @clientID;

