CREATE TABLE airport (
    code VARCHAR(255) PRIMARY KEY,
    city VARCHAR(255) NOT NULL,
    state VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL
);

CREATE TABLE flight (
    number VARCHAR(255) PRIMARY KEY,
    airline VARCHAR(255) NOT NULL,
    weekdays INT NOT NULL
);

CREATE TABLE flightLeg (
    flight_Number VARCHAR(255) NOT NULL,
    LegNo INT NOT NULL,
    airportdep_code VARCHAR(255) NOT NULL,
    airportarr_code VARCHAR(255) NOT NULL,
    sch_deptime TIME NOT NULL,
    sch_arrtime TIME NOT NULL,
    PRIMARY KEY (flight_Number, LegNo),
    FOREIGN KEY (flight_Number) REFERENCES flight(number),
    FOREIGN KEY (airportdep_code) REFERENCES airport(code),
    FOREIGN KEY (airportarr_code) REFERENCES airport(code)
);

CREATE TABLE legInstance (
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
    FOREIGN KEY (flightLeg_flightNumber, flightLeg_LegNo) REFERENCES flightLeg(flight_Number, LegNo),
    FOREIGN KEY (airportdep_code) REFERENCES airport(code),
    FOREIGN KEY (airportarr_code) REFERENCES airport(code)
);

CREATE TABLE seat (
    legInstance_flightLeg_flightNumber VARCHAR(255) NOT NULL,
    legInstance_flightLeg_LegNo INT NOT NULL,
    legInstance_Date DATE NOT NULL,
    seatNo VARCHAR(255) NOT NULL,
    costumerName VARCHAR(255),
    Cphone VARCHAR(255),
    PRIMARY KEY (legInstance_flightLeg_flightNumber, legInstance_flightLeg_LegNo, legInstance_Date, seatNo),
    FOREIGN KEY (legInstance_flightLeg_flightNumber, legInstance_flightLeg_LegNo, legInstance_Date) REFERENCES legInstance(flightLeg_flightNumber, flightLeg_LegNo, Date)
);

CREATE TABLE airplaneType (
    Typename VARCHAR(255) PRIMARY KEY,
    Maxseats INT NOT NULL,
    Company VARCHAR(255)
);

CREATE TABLE airplane (
    airplane_Id INT PRIMARY KEY,
    totalSeats INT NOT NULL,
    airplaneType_Typename VARCHAR(255) NOT NULL,
    FOREIGN KEY (airplaneType_Typename) REFERENCES airplaneType(Typename)
);

CREATE TABLE canLand (
    airport_code VARCHAR(255) NOT NULL,
    airplaneType_Typename VARCHAR(255) NOT NULL,
    PRIMARY KEY (airport_code, airplaneType_Typename),
    FOREIGN KEY (airport_code) REFERENCES airport(code),
    FOREIGN KEY (airplaneType_Typename) REFERENCES airplaneType(Typename)
);

CREATE TABLE fare (
    flight_Number VARCHAR(255) NOT NULL,
    code VARCHAR(255) NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    restrictions VARCHAR(255),
    PRIMARY KEY (flight_Number, code),
    FOREIGN KEY (flight_Number) REFERENCES flight(number)
);
