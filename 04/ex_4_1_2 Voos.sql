IF OBJECT_ID('Voos_fare', 'U') IS NOT NULL
    DROP TABLE dbo.Voos_fare
IF OBJECT_ID('Voos_canLand', 'U') IS NOT NULL
    DROP TABLE dbo.Voos_canLand
IF OBJECT_ID('Voos_airplane', 'U') IS NOT NULL
    DROP TABLE dbo.Voos_airplane
IF OBJECT_ID('Voos_airplaneType', 'U') IS NOT NULL
    DROP TABLE dbo.Voos_airplaneType
IF OBJECT_ID('Voos_seat', 'U') IS NOT NULL
    DROP TABLE dbo.Voos_seat
IF OBJECT_ID('Voos_legInstance', 'U') IS NOT NULL
    DROP TABLE dbo.Voos_legInstance
IF OBJECT_ID('Voos_flightLeg', 'U') IS NOT NULL
    DROP TABLE dbo.Voos_flightLeg
IF OBJECT_ID('Voos_flight', 'U') IS NOT NULL
    DROP TABLE dbo.Voos_flght
IF OBJECT_ID('Voos_airport', 'U') IS NOT NULL
    DROP TABLE dbo.Voos_airport

CREATE TABLE Voos_airport (
    code VARCHAR(255) PRIMARY KEY,
    city VARCHAR(255) NOT NULL,
    state VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL
);

CREATE TABLE Voos_flight (
    number VARCHAR(255) PRIMARY KEY,
    airline VARCHAR(255) NOT NULL,
    weekdays INT NOT NULL
);

CREATE TABLE Voos_flightLeg (
    flight_Number VARCHAR(255) NOT NULL,
    LegNo INT NOT NULL,
    airportdep_code VARCHAR(255) NOT NULL,
    airportarr_code VARCHAR(255) NOT NULL,
    sch_deptime TIME NOT NULL,
    sch_arrtime TIME NOT NULL,
    PRIMARY KEY (flight_Number, LegNo),
    FOREIGN KEY (flight_Number) REFERENCES Voos_flight(number),
    FOREIGN KEY (airportdep_code) REFERENCES Voos_airport(code),
    FOREIGN KEY (airportarr_code) REFERENCES Voos_airport(code)
);

CREATE TABLE Voos_legInstance (
    flightLeg_flightNumber VARCHAR(255) NOT NULL,
    flightLeg_LegNo INT NOT NULL,
    Date DATE NOT NULL,
    airplane_Id INT NOT NULL,
    noOfAvailableSeats INT NOT NULL,
    airportdep_code VARCHAR(255) NOT NULL,
    airportarr_code VARCHAR(255) NOT NULL,
    deptime TIME NOT NULL,
    arrtime TIME NOT NULL,
    PRIMARY KEY (flightLeg_flightNumber, flightLeg_LegNo, Date),
    FOREIGN KEY (flightLeg_flightNumber, flightLeg_LegNo) REFERENCES Voos_flightLeg(flight_Number, LegNo),
    FOREIGN KEY (airportdep_code) REFERENCES Voos_airport(code),
    FOREIGN KEY (airportarr_code) REFERENCES Voos_airport(code)
);

CREATE TABLE Voos_seat (
    legInstance_flightLeg_flightNumber VARCHAR(255) NOT NULL,
    legInstance_flightLeg_LegNo INT NOT NULL,
    legInstance_Date DATE NOT NULL,
    seatNo VARCHAR(255) NOT NULL,
    costumerName VARCHAR(255),
    Cphone VARCHAR(255),
    PRIMARY KEY (legInstance_flightLeg_flightNumber, legInstance_flightLeg_LegNo, legInstance_Date, seatNo),
    FOREIGN KEY (legInstance_flightLeg_flightNumber, legInstance_flightLeg_LegNo, legInstance_Date) REFERENCES Voos_legInstance(flightLeg_flightNumber, flightLeg_LegNo, Date)
);

CREATE TABLE Voos_airplaneType (
    Typename VARCHAR(255) PRIMARY KEY,
    Maxseats INT NOT NULL,
    Company VARCHAR(255)
);

CREATE TABLE Voos_airplane (
    airplane_Id INT PRIMARY KEY,
    totalSeats INT NOT NULL,
    airplaneType_Typename VARCHAR(255) NOT NULL,
    FOREIGN KEY (airplaneType_Typename) REFERENCES Voos_airplaneType(Typename)
);

CREATE TABLE Voos_canLand (
    airport_code VARCHAR(255) NOT NULL,
    airplaneType_Typename VARCHAR(255) NOT NULL,
    PRIMARY KEY (airport_code, airplaneType_Typename),
    FOREIGN KEY (airport_code) REFERENCES Voos_airport(code),
    FOREIGN KEY (airplaneType_Typename) REFERENCES Voos_airplaneType(Typename)
);

CREATE TABLE Voos_fare (
    flight_Number VARCHAR(255) NOT NULL,
    code VARCHAR(255) NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    restrictions VARCHAR(255),
    PRIMARY KEY (flight_Number, code),
    FOREIGN KEY (flight_Number) REFERENCES Voos_flight(number)
);
