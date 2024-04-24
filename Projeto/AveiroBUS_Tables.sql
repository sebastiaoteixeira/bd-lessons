CREATE TABLE [stop] (
  [id] integer PRIMARY KEY,
  [name] nvarchar(255),
  [location] nvarchar(255),
  [longitude] decimal(9,6),
  [latitude] decimal(9,6)
)
GO

CREATE TABLE [line_stop] (
  [idLine] integer,
  [idStop] integer,
  PRIMARY KEY ([idLine], [idStop])
)
GO

CREATE TABLE [line] (
  [number] integer PRIMARY KEY,
  [designation] nvarchar(255),
  [idFirstStop] integer,
  [idLastStop] integer,
  [color] integer
)
GO

CREATE TABLE [exceptions] (
  [idJourney] integer,
  [idStop] integer,
  PRIMARY KEY ([idJourney], [idStop])
)
GO

CREATE TABLE [journey] (
  [id] integer PRIMARY KEY,
  [startTime] datetime,
  [idFirstStop] integer,
  [idLastStop] integer
)
GO

CREATE TABLE [zone] (
  [id] integer PRIMARY KEY,
  [designation] integer
)
GO

CREATE TABLE [zone_stop] (
  [idStop1] integer,
  [idStop2] integer,
  [idZone] integer,
  PRIMARY KEY ([idStop1], [idStop2], [idZone])
)
GO

CREATE TABLE [transportTicket] (
  [number] integer PRIMARY KEY,
  [zoneNumber] integer
)
GO

CREATE TABLE [tripsTicket] (
  [ticketNumber] integer PRIMARY KEY,
  [tripsCount] integer
)
GO

CREATE TABLE [subscriptionTicket] (
  [ticketNumber] integer PRIMARY KEY,
  [expirationDate] date
)
GO

CREATE TABLE [itemTariff] (
  [id] integer PRIMARY KEY,
  [value] integer
)
GO

CREATE TABLE [purchasedItem] (
  [id] integer PRIMARY KEY,
  [idItemPreco] integer,
  [idTransportTicket] integer
)
GO

CREATE TABLE [subscription] (
  [itemId] integer PRIMARY KEY,
  [days] integer
)
GO

CREATE TABLE [trips] (
  [itemId] integer PRIMARY KEY,
  [tripsCount] integer
)
GO

CREATE TABLE [user] (
  [number] integer,
  [numberTransportTicket] integer,
  [name] nvarchar(255),
  [email] nvarchar(255),
  [nif] integer,
  [pHash] integer,
  [salt] nvarchar(255),
  [expiration] date,
  [token] nvarchar(255),
  PRIMARY KEY ([number], [token])
)
GO

CREATE TABLE [validation] (
  [numberTransportTicket] integer,
  [idJourneyInstance] integer,
  [idStop] integer,
  [time] datetime,
  PRIMARY KEY ([numberTransportTicket], [idJourneyInstance], [idStop])
)
GO

CREATE TABLE [stop_journeyInstance] (
  [idJourneyInstance] integer,
  [idStop] integer,
  [stopTime] datetime,
  PRIMARY KEY ([idJourneyInstance], [idStop])
)
GO

CREATE TABLE [journeyInstance] (
  [id] integer,
  [idJourney] integer,
  [startTime] datetime,
  PRIMARY KEY ([id], [idJourney])
)
GO

ALTER TABLE [line] ADD FOREIGN KEY ([idFirstStop]) REFERENCES [stop] ([id])
GO

ALTER TABLE [line] ADD FOREIGN KEY ([idLastStop]) REFERENCES [stop] ([id])
GO

ALTER TABLE [journey] ADD FOREIGN KEY ([idFirstStop]) REFERENCES [stop] ([id])
GO

ALTER TABLE [journey] ADD FOREIGN KEY ([idLastStop]) REFERENCES [stop] ([id])
GO

ALTER TABLE [exceptions] ADD FOREIGN KEY ([idJourney]) REFERENCES [journey] ([id])
GO

ALTER TABLE [exceptions] ADD FOREIGN KEY ([idStop]) REFERENCES [stop] ([id])
GO

ALTER TABLE [line_stop] ADD FOREIGN KEY ([idLine]) REFERENCES [line] ([number])
GO

ALTER TABLE [line_stop] ADD FOREIGN KEY ([idStop]) REFERENCES [stop] ([id])
GO

ALTER TABLE [zone_stop] ADD FOREIGN KEY ([idStop1]) REFERENCES [stop] ([id])
GO

ALTER TABLE [zone_stop] ADD FOREIGN KEY ([idStop2]) REFERENCES [stop] ([id])
GO

ALTER TABLE [zone_stop] ADD FOREIGN KEY ([idZone]) REFERENCES [zone] ([id])
GO

ALTER TABLE [transportTicket] ADD FOREIGN KEY ([zoneNumber]) REFERENCES [zone] ([id])
GO

ALTER TABLE [subscriptionTicket] ADD FOREIGN KEY ([ticketNumber]) REFERENCES [transportTicket] ([number])
GO

ALTER TABLE [tripsTicket] ADD FOREIGN KEY ([ticketNumber]) REFERENCES [transportTicket] ([number])
GO

ALTER TABLE [itemTariff] ADD FOREIGN KEY ([id]) REFERENCES [zone] ([id])
GO

ALTER TABLE [itemTariff] ADD FOREIGN KEY ([id]) REFERENCES [subscription] ([itemId])
GO

ALTER TABLE [itemTariff] ADD FOREIGN KEY ([id]) REFERENCES [trips] ([itemId])
GO

ALTER TABLE [transportTicket] ADD FOREIGN KEY ([number]) REFERENCES [user] ([numberTransportTicket])
GO

ALTER TABLE [stop_journeyInstance] ADD FOREIGN KEY ([idJourneyInstance]) REFERENCES [journeyInstance] ([id])
GO

ALTER TABLE [journeyInstance] ADD FOREIGN KEY ([idJourney]) REFERENCES [journey] ([id])
GO

ALTER TABLE [stop_journeyInstance] ADD FOREIGN KEY ([idStop]) REFERENCES [stop] ([id])
GO

ALTER TABLE [purchasedItem] ADD FOREIGN KEY ([idTransportTicket]) REFERENCES [transportTicket] ([number])
GO

ALTER TABLE [purchasedItem] ADD FOREIGN KEY ([idItemPreco]) REFERENCES [itemTariff] ([id])
GO

ALTER TABLE [stop_journeyInstance] ADD FOREIGN KEY ([idStop]) REFERENCES [validation] ([idStop])
GO

ALTER TABLE [validation] ADD FOREIGN KEY ([idJourneyInstance]) REFERENCES [stop_journeyInstance] ([idJourneyInstance])
GO

ALTER TABLE [transportTicket] ADD FOREIGN KEY ([number]) REFERENCES [validation] ([numberTransportTicket])
GO
