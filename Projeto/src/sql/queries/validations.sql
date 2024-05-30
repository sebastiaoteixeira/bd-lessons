-- Count validations by stop

SELECT
    s.id, s.name, s.location, s.longitude, s.latitude,
    COUNT(v.numberTransportTicket) AS validations
FROM
    UrbanBus.stop AS s
    LEFT JOIN UrbanBus.validation AS v ON s.id = v.idStop
GROUP BY
    s.name;
