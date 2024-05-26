-- Query that returns the tickets of a client

DECLARE @token CHAR(64) = ?;
DECLARE @onlyValid BIT = ?;

IF @onlyValid = 0
        SELECT t.[ticketNumber], t.[zone], t.[expirationDate], t.[tripsLeft]
    FROM getMyTicketsStates(@token) AS t;
ELSE
BEGIN
    SELECT t.[ticketNumber], t.[zone], t.[expirationDate], t.[tripsLeft]
    FROM getMyTicketsStates(@token) AS t
    WHERE (
        t.[tripsLeft] IS NOT NULL
        AND t.[tripsLeft] > 0
    ) OR (
        t.[expirationDate] IS NOT NULL
        AND t.[expirationDate] > GETDATE()
    );
END

