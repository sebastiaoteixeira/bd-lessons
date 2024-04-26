CREATE TABLE [UrbanBus.stop] (
  [id] integer PRIMARY KEY,
  [name] nvarchar(255),
  [location] nvarchar(255),
  [longitude] decimal(9,6) CHECK (longitude BETWEEN -180 AND 180),
  [latitude] decimal(9,6) CHECK (latitude BETWEEN -180 AND 180)
)
GO

CREATE TABLE [UrbanBus.line_stop] (
  [idLine] integer,
  [idStop] integer,
  PRIMARY KEY ([idLine], [idStop])
)
GO

CREATE TABLE [UrbanBus.line] (
  [number] integer PRIMARY KEY,
  [designation] nvarchar(255),
  [idFirstStop] integer,
  [idLastStop] integer,
  [color] integer CHECK (color BETWEEN 0 AND 16777215)
)
GO

CREATE TABLE [UrbanBus.exceptions] (
  [idJourney] integer,
  [idStop] integer,
  PRIMARY KEY ([idJourney], [idStop])
)
GO

CREATE TABLE [UrbanBus.journey] (
  [id] integer PRIMARY KEY,
  [startTime] datetime,
  [idFirstStop] integer,
  [idLastStop] integer
)
GO

CREATE TABLE [UrbanBus.zone] (
  [id] integer PRIMARY KEY,
  [designation] integer
)
GO

CREATE TABLE [UrbanBus.zone_stop] (
  [idStop1] integer,
  [idStop2] integer,
  [idZone] integer,
  PRIMARY KEY ([idStop1], [idStop2], [idZone])
)
GO

CREATE TABLE [UrbanBus.transportTicket] (
  [number] integer PRIMARY KEY,
  [clientNumber] integer,
  [zoneNumber] integer
)
GO

CREATE TABLE [UrbanBus.tripsTicket] (
  [ticketNumber] integer PRIMARY KEY,
  [tripsCount] integer
)
GO

CREATE TABLE [UrbanBus.subscriptionTicket] (
  [ticketNumber] integer PRIMARY KEY,
  [expirationDate] date
)
GO

CREATE TABLE [UrbanBus.itemTariff] (
  [id] integer PRIMARY KEY,
  [value] integer
)
GO

CREATE TABLE [UrbanBus.purchasedItem] (
  [id] integer PRIMARY KEY,
  [idItemPreco] integer,
  [idTransportTicket] integer
)
GO

CREATE TABLE [UrbanBus.subscription] (
  [itemId] integer PRIMARY KEY,
  [days] integer
)
GO

CREATE TABLE [UrbanBus.trips] (
  [itemId] integer PRIMARY KEY,
  [tripsCount] integer
)
GO

CREATE TABLE [UrbanBus.client] (
  [number] integer,
  [name] nvarchar(255),
  [email] nvarchar(255),
  [nif] integer,
  [pHash] integer,
  [salt] nvarchar(255),
  [expiration] date,
  [token] nvarchar(255),
  PRIMARY KEY ([number])
)
GO

CREATE TABLE [UrbanBus.validation] (
  [numberTransportTicket] integer,
  [idJourneyInstance] integer,
  [idStop] integer,
  [time] datetime,
  PRIMARY KEY ([numberTransportTicket], [idJourneyInstance], [idStop])
)
GO

CREATE TABLE [UrbanBus.stop_journeyInstance] (
  [idJourneyInstance] integer,
  [idStop] integer,
  [stopTime] datetime,
  PRIMARY KEY ([idJourneyInstance], [idStop])
)
GO

CREATE TABLE [UrbanBus.journeyInstance] (
  [id] integer,
  [idJourney] integer,
  [startTime] datetime,
  PRIMARY KEY ([id])
)
GO

ALTER TABLE [UrbanBus.line] ADD FOREIGN KEY ([idFirstStop]) REFERENCES [UrbanBus.stop] ([id])
GO

ALTER TABLE [UrbanBus.line] ADD FOREIGN KEY ([idLastStop]) REFERENCES [UrbanBus.stop] ([id])
GO

ALTER TABLE [UrbanBus.journey] ADD FOREIGN KEY ([idFirstStop]) REFERENCES [UrbanBus.stop] ([id])
GO

ALTER TABLE [UrbanBus.journey] ADD FOREIGN KEY ([idLastStop]) REFERENCES [UrbanBus.stop] ([id])
GO

ALTER TABLE [UrbanBus.exceptions] ADD FOREIGN KEY ([idJourney]) REFERENCES [UrbanBus.journey] ([id])
GO

ALTER TABLE [UrbanBus.exceptions] ADD FOREIGN KEY ([idStop]) REFERENCES [UrbanBus.stop] ([id])
GO

ALTER TABLE [UrbanBus.line_stop] ADD FOREIGN KEY ([idLine]) REFERENCES [UrbanBus.line] ([number])
GO

ALTER TABLE [UrbanBus.line_stop] ADD FOREIGN KEY ([idStop]) REFERENCES [UrbanBus.stop] ([id])
GO

ALTER TABLE [UrbanBus.zone_stop] ADD FOREIGN KEY ([idStop1]) REFERENCES [UrbanBus.stop] ([id])
GO

ALTER TABLE [UrbanBus.zone_stop] ADD FOREIGN KEY ([idStop2]) REFERENCES [UrbanBus.stop] ([id])
GO

ALTER TABLE [UrbanBus.zone_stop] ADD FOREIGN KEY ([idZone]) REFERENCES [UrbanBus.zone] ([id])
GO

ALTER TABLE [UrbanBus.transportTicket] ADD FOREIGN KEY ([zoneNumber]) REFERENCES [UrbanBus.zone] ([id])
GO

ALTER TABLE [UrbanBus.subscriptionTicket] ADD FOREIGN KEY ([ticketNumber]) REFERENCES [UrbanBus.transportTicket] ([number])
GO

ALTER TABLE [UrbanBus.tripsTicket] ADD FOREIGN KEY ([ticketNumber]) REFERENCES [UrbanBus.transportTicket] ([number])
GO

ALTER TABLE [UrbanBus.itemTariff] ADD FOREIGN KEY ([id]) REFERENCES [UrbanBus.zone] ([id])
GO

ALTER TABLE [UrbanBus.subscription] ADD FOREIGN KEY ([itemId]) REFERENCES [UrbanBus.itemTariff] ([id])
GO

ALTER TABLE [UrbanBus.trips] ADD FOREIGN KEY ([itemId]) REFERENCES [UrbanBus.itemTariff] ([id])
GO

ALTER TABLE [UrbanBus.transportTicket] ADD FOREIGN KEY ([clientNumber]) REFERENCES [UrbanBus.client] ([number])
GO

ALTER TABLE [UrbanBus.stop_journeyInstance] ADD FOREIGN KEY ([idJourneyInstance]) REFERENCES [UrbanBus.journeyInstance] ([id])
GO

ALTER TABLE [UrbanBus.journeyInstance] ADD FOREIGN KEY ([idJourney]) REFERENCES [UrbanBus.journey] ([id])
GO

ALTER TABLE [UrbanBus.stop_journeyInstance] ADD FOREIGN KEY ([idStop]) REFERENCES [UrbanBus.stop] ([id])
GO

ALTER TABLE [UrbanBus.purchasedItem] ADD FOREIGN KEY ([idTransportTicket]) REFERENCES [UrbanBus.transportTicket] ([number])
GO

ALTER TABLE [UrbanBus.purchasedItem] ADD FOREIGN KEY ([idItemPreco]) REFERENCES [UrbanBus.itemTariff] ([id])
GO

ALTER TABLE [UrbanBus.validation] ADD FOREIGN KEY ([idJourneyInstance], [idStop]) REFERENCES [UrbanBus.stop_journeyInstance] ([idJourneyInstance], [idStop])
GO

ALTER TABLE [UrbanBus.validation] ADD FOREIGN KEY ([numberTransportTicket]) REFERENCES [UrbanBus.transportTicket] ([number])
GO

