SET NOCOUNT ON;

IF OBJECT_ID('dbo.tgh_transfer_booking_assign', 'U') IS NOT NULL DROP TABLE dbo.tgh_transfer_booking_assign;
IF OBJECT_ID('dbo.tgh_transfer_booking', 'U') IS NOT NULL DROP TABLE dbo.tgh_transfer_booking;
IF OBJECT_ID('dbo.tgh_route_price', 'U') IS NOT NULL DROP TABLE dbo.tgh_route_price;
IF OBJECT_ID('dbo.tgh_route', 'U') IS NOT NULL DROP TABLE dbo.tgh_route;
IF OBJECT_ID('dbo.tgh_driver', 'U') IS NOT NULL DROP TABLE dbo.tgh_driver;
IF OBJECT_ID('dbo.tgh_vehicle', 'U') IS NOT NULL DROP TABLE dbo.tgh_vehicle;
IF OBJECT_ID('dbo.tgh_vehicle_type', 'U') IS NOT NULL DROP TABLE dbo.tgh_vehicle_type;

CREATE TABLE dbo.tgh_vehicle_type (
    VehicleTypeId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    Capacity INT NOT NULL DEFAULT(4),
    Description NVARCHAR(500) NULL,
    Status TINYINT NOT NULL DEFAULT(1),
    SortOrder INT NOT NULL DEFAULT(0),
    CreatedAt DATETIME2 NOT NULL DEFAULT(SYSUTCDATETIME()),
    CreatedBy NVARCHAR(100) NOT NULL DEFAULT(N'system'),
    UpdatedAt DATETIME2 NOT NULL DEFAULT(SYSUTCDATETIME()),
    UpdatedBy NVARCHAR(100) NOT NULL DEFAULT(N'system')
);

CREATE TABLE dbo.tgh_vehicle (
    VehicleId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    VehicleTypeId INT NOT NULL,
    LicensePlate NVARCHAR(20) NOT NULL,
    Brand NVARCHAR(100) NULL,
    Model NVARCHAR(100) NULL,
    Year INT NULL,
    SeatCount INT NOT NULL DEFAULT(4),
    Status TINYINT NOT NULL DEFAULT(1),
    SortOrder INT NOT NULL DEFAULT(0),
    CreatedAt DATETIME2 NOT NULL DEFAULT(SYSUTCDATETIME()),
    CreatedBy NVARCHAR(100) NOT NULL DEFAULT(N'system'),
    UpdatedAt DATETIME2 NOT NULL DEFAULT(SYSUTCDATETIME()),
    UpdatedBy NVARCHAR(100) NOT NULL DEFAULT(N'system'),
    CONSTRAINT FK_tgh_vehicle_vehicle_type FOREIGN KEY (VehicleTypeId) REFERENCES dbo.tgh_vehicle_type (VehicleTypeId)
);

CREATE UNIQUE INDEX UX_tgh_vehicle_LicensePlate ON dbo.tgh_vehicle (LicensePlate);

CREATE TABLE dbo.tgh_driver (
    DriverId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    FullName NVARCHAR(200) NOT NULL,
    Phone NVARCHAR(30) NOT NULL,
    Email NVARCHAR(200) NULL,
    LicenseNumber NVARCHAR(50) NULL,
    Status TINYINT NOT NULL DEFAULT(1),
    SortOrder INT NOT NULL DEFAULT(0),
    CreatedAt DATETIME2 NOT NULL DEFAULT(SYSUTCDATETIME()),
    CreatedBy NVARCHAR(100) NOT NULL DEFAULT(N'system'),
    UpdatedAt DATETIME2 NOT NULL DEFAULT(SYSUTCDATETIME()),
    UpdatedBy NVARCHAR(100) NOT NULL DEFAULT(N'system')
);

CREATE TABLE dbo.tgh_route (
    RouteId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    FromName NVARCHAR(200) NOT NULL,
    ToName NVARCHAR(200) NOT NULL,
    DistanceKm DECIMAL(10,2) NULL,
    DurationMin INT NULL,
    Status TINYINT NOT NULL DEFAULT(1),
    SortOrder INT NOT NULL DEFAULT(0),
    CreatedAt DATETIME2 NOT NULL DEFAULT(SYSUTCDATETIME()),
    CreatedBy NVARCHAR(100) NOT NULL DEFAULT(N'system'),
    UpdatedAt DATETIME2 NOT NULL DEFAULT(SYSUTCDATETIME()),
    UpdatedBy NVARCHAR(100) NOT NULL DEFAULT(N'system')
);

CREATE TABLE dbo.tgh_route_price (
    RoutePriceId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    RouteId INT NOT NULL,
    VehicleTypeId INT NOT NULL,
    PriceOneWay DECIMAL(18,2) NOT NULL,
    PriceRoundTrip DECIMAL(18,2) NOT NULL,
    Status TINYINT NOT NULL DEFAULT(1),
    SortOrder INT NOT NULL DEFAULT(0),
    CreatedAt DATETIME2 NOT NULL DEFAULT(SYSUTCDATETIME()),
    CreatedBy NVARCHAR(100) NOT NULL DEFAULT(N'system'),
    UpdatedAt DATETIME2 NOT NULL DEFAULT(SYSUTCDATETIME()),
    UpdatedBy NVARCHAR(100) NOT NULL DEFAULT(N'system'),
    CONSTRAINT FK_tgh_route_price_route FOREIGN KEY (RouteId) REFERENCES dbo.tgh_route (RouteId),
    CONSTRAINT FK_tgh_route_price_vehicle_type FOREIGN KEY (VehicleTypeId) REFERENCES dbo.tgh_vehicle_type (VehicleTypeId)
);

CREATE UNIQUE INDEX UX_tgh_route_price_Route_VehicleType ON dbo.tgh_route_price (RouteId, VehicleTypeId);

CREATE TABLE dbo.tgh_transfer_booking (
    BookingId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    BookingCode NVARCHAR(30) NOT NULL,
    CustomerName NVARCHAR(200) NOT NULL,
    CustomerPhone NVARCHAR(30) NOT NULL,
    CustomerEmail NVARCHAR(200) NULL,
    RouteId INT NOT NULL,
    VehicleTypeId INT NOT NULL,
    PickupTime DATETIME2 NOT NULL,
    ReturnTime DATETIME2 NULL,
    TripType TINYINT NOT NULL, -- 1: OneWay, 2: RoundTrip
    PaymentType TINYINT NOT NULL, -- 1: Online, 2: Hold
    PaymentStatus TINYINT NOT NULL DEFAULT(0), -- 0: Unpaid, 1: Paid, 2: Refunded
    TotalAmount DECIMAL(18,2) NOT NULL,
    Note NVARCHAR(1000) NULL,
    Status TINYINT NOT NULL DEFAULT(1),
    SortOrder INT NOT NULL DEFAULT(0),
    CreatedAt DATETIME2 NOT NULL DEFAULT(SYSUTCDATETIME()),
    CreatedBy NVARCHAR(100) NOT NULL DEFAULT(N'system'),
    UpdatedAt DATETIME2 NOT NULL DEFAULT(SYSUTCDATETIME()),
    UpdatedBy NVARCHAR(100) NOT NULL DEFAULT(N'system'),
    CONSTRAINT FK_tgh_transfer_booking_route FOREIGN KEY (RouteId) REFERENCES dbo.tgh_route (RouteId),
    CONSTRAINT FK_tgh_transfer_booking_vehicle_type FOREIGN KEY (VehicleTypeId) REFERENCES dbo.tgh_vehicle_type (VehicleTypeId)
);

CREATE UNIQUE INDEX UX_tgh_transfer_booking_BookingCode ON dbo.tgh_transfer_booking (BookingCode);

CREATE TABLE dbo.tgh_transfer_booking_assign (
    AssignId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    BookingId INT NOT NULL,
    VehicleId INT NOT NULL,
    DriverId INT NOT NULL,
    AssignedAt DATETIME2 NOT NULL DEFAULT(SYSUTCDATETIME()),
    Status TINYINT NOT NULL DEFAULT(1),
    SortOrder INT NOT NULL DEFAULT(0),
    CreatedAt DATETIME2 NOT NULL DEFAULT(SYSUTCDATETIME()),
    CreatedBy NVARCHAR(100) NOT NULL DEFAULT(N'system'),
    UpdatedAt DATETIME2 NOT NULL DEFAULT(SYSUTCDATETIME()),
    UpdatedBy NVARCHAR(100) NOT NULL DEFAULT(N'system'),
    CONSTRAINT FK_tgh_transfer_booking_assign_booking FOREIGN KEY (BookingId) REFERENCES dbo.tgh_transfer_booking (BookingId),
    CONSTRAINT FK_tgh_transfer_booking_assign_vehicle FOREIGN KEY (VehicleId) REFERENCES dbo.tgh_vehicle (VehicleId),
    CONSTRAINT FK_tgh_transfer_booking_assign_driver FOREIGN KEY (DriverId) REFERENCES dbo.tgh_driver (DriverId)
);
