SET NOCOUNT ON;

IF OBJECT_ID('dbo.trf_transfer_booking_assign', 'U') IS NOT NULL DROP TABLE dbo.trf_transfer_booking_assign;
IF OBJECT_ID('dbo.trf_transfer_booking', 'U') IS NOT NULL DROP TABLE dbo.trf_transfer_booking;
IF OBJECT_ID('dbo.trf_route_price', 'U') IS NOT NULL DROP TABLE dbo.trf_route_price;
IF OBJECT_ID('dbo.trf_route', 'U') IS NOT NULL DROP TABLE dbo.trf_route;
IF OBJECT_ID('dbo.trf_driver', 'U') IS NOT NULL DROP TABLE dbo.trf_driver;
IF OBJECT_ID('dbo.trf_vehicle', 'U') IS NOT NULL DROP TABLE dbo.trf_vehicle;
IF OBJECT_ID('dbo.trf_vehicle_model', 'U') IS NOT NULL DROP TABLE dbo.trf_vehicle_model;
IF OBJECT_ID('dbo.trf_vehicle_brand', 'U') IS NOT NULL DROP TABLE dbo.trf_vehicle_brand;
IF OBJECT_ID('dbo.trf_vehicle_type', 'U') IS NOT NULL DROP TABLE dbo.trf_vehicle_type;

CREATE TABLE dbo.trf_vehicle_type (
    VehicleTypeId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    Capacity INT NOT NULL DEFAULT(4),
    Description NVARCHAR(MAX) NULL,
    Status TINYINT NOT NULL DEFAULT(1),
    SortOrder INT NOT NULL DEFAULT(0),
    CreatedAt DATETIME2 NOT NULL DEFAULT(SYSUTCDATETIME()),
    CreatedBy NVARCHAR(100) NOT NULL DEFAULT(N'system'),
    UpdatedAt DATETIME2 NOT NULL DEFAULT(SYSUTCDATETIME()),
    UpdatedBy NVARCHAR(100) NOT NULL DEFAULT(N'system')
);

CREATE TABLE dbo.trf_vehicle_brand (
    BrandId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    Slug NVARCHAR(120) NOT NULL,
    LogoUrl NVARCHAR(300) NULL,
    LogoAlt NVARCHAR(200) NULL,
    Summary NVARCHAR(MAX) NULL,
    SeoTitle NVARCHAR(200) NULL,
    SeoDescription NVARCHAR(MAX) NULL,
    SeoKeywords NVARCHAR(500) NULL,
    Status TINYINT NOT NULL DEFAULT(1),
    SortOrder INT NOT NULL DEFAULT(0),
    CreatedAt DATETIME2 NOT NULL DEFAULT(SYSUTCDATETIME()),
    CreatedBy NVARCHAR(100) NOT NULL DEFAULT(N'system'),
    UpdatedAt DATETIME2 NOT NULL DEFAULT(SYSUTCDATETIME()),
    UpdatedBy NVARCHAR(100) NOT NULL DEFAULT(N'system')
);

CREATE UNIQUE INDEX UX_trf_vehicle_brand_Slug ON dbo.trf_vehicle_brand (Slug);

CREATE TABLE dbo.trf_vehicle_model (
    ModelId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    BrandId INT NOT NULL,
    Name NVARCHAR(100) NOT NULL,
    Slug NVARCHAR(120) NOT NULL,
    YearFrom INT NULL,
    YearTo INT NULL,
    SeoTitle NVARCHAR(200) NULL,
    SeoDescription NVARCHAR(MAX) NULL,
    Status TINYINT NOT NULL DEFAULT(1),
    SortOrder INT NOT NULL DEFAULT(0),
    CreatedAt DATETIME2 NOT NULL DEFAULT(SYSUTCDATETIME()),
    CreatedBy NVARCHAR(100) NOT NULL DEFAULT(N'system'),
    UpdatedAt DATETIME2 NOT NULL DEFAULT(SYSUTCDATETIME()),
    UpdatedBy NVARCHAR(100) NOT NULL DEFAULT(N'system'),
    CONSTRAINT FK_trf_vehicle_model_brand FOREIGN KEY (BrandId) REFERENCES dbo.trf_vehicle_brand (BrandId)
);

CREATE UNIQUE INDEX UX_trf_vehicle_model_Brand_Slug ON dbo.trf_vehicle_model (BrandId, Slug);

CREATE TABLE dbo.trf_vehicle (
    VehicleId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    VehicleTypeId INT NOT NULL,
    BrandId INT NULL,
    ModelId INT NULL,
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
    CONSTRAINT FK_trf_vehicle_vehicle_type FOREIGN KEY (VehicleTypeId) REFERENCES dbo.trf_vehicle_type (VehicleTypeId),
    CONSTRAINT FK_trf_vehicle_brand FOREIGN KEY (BrandId) REFERENCES dbo.trf_vehicle_brand (BrandId),
    CONSTRAINT FK_trf_vehicle_model FOREIGN KEY (ModelId) REFERENCES dbo.trf_vehicle_model (ModelId)
);

CREATE UNIQUE INDEX UX_trf_vehicle_LicensePlate ON dbo.trf_vehicle (LicensePlate);

CREATE TABLE dbo.trf_driver (
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

CREATE TABLE dbo.trf_route (
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

CREATE TABLE dbo.trf_route_price (
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
    CONSTRAINT FK_trf_route_price_route FOREIGN KEY (RouteId) REFERENCES dbo.trf_route (RouteId),
    CONSTRAINT FK_trf_route_price_vehicle_type FOREIGN KEY (VehicleTypeId) REFERENCES dbo.trf_vehicle_type (VehicleTypeId)
);

CREATE UNIQUE INDEX UX_trf_route_price_Route_VehicleType ON dbo.trf_route_price (RouteId, VehicleTypeId);

CREATE TABLE dbo.trf_transfer_booking (
    BookingId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    BookingCode NVARCHAR(30) NOT NULL,
    CustomerName NVARCHAR(200) NOT NULL,
    CustomerPhone NVARCHAR(30) NOT NULL,
    CustomerEmail NVARCHAR(200) NULL,
    RouteId INT NOT NULL,
    VehicleTypeId INT NOT NULL,
    PickupTime DATETIME2 NOT NULL,
    ReturnTime DATETIME2 NULL,
    TripType TINYINT NOT NULL,
    PaymentType TINYINT NOT NULL,
    PaymentStatus TINYINT NOT NULL DEFAULT(0),
    TotalAmount DECIMAL(18,2) NOT NULL,
    Note NVARCHAR(MAX) NULL,
    Status TINYINT NOT NULL DEFAULT(1),
    SortOrder INT NOT NULL DEFAULT(0),
    CreatedAt DATETIME2 NOT NULL DEFAULT(SYSUTCDATETIME()),
    CreatedBy NVARCHAR(100) NOT NULL DEFAULT(N'system'),
    UpdatedAt DATETIME2 NOT NULL DEFAULT(SYSUTCDATETIME()),
    UpdatedBy NVARCHAR(100) NOT NULL DEFAULT(N'system'),
    CONSTRAINT FK_trf_transfer_booking_route FOREIGN KEY (RouteId) REFERENCES dbo.trf_route (RouteId),
    CONSTRAINT FK_trf_transfer_booking_vehicle_type FOREIGN KEY (VehicleTypeId) REFERENCES dbo.trf_vehicle_type (VehicleTypeId)
);

CREATE UNIQUE INDEX UX_trf_transfer_booking_BookingCode ON dbo.trf_transfer_booking (BookingCode);

CREATE TABLE dbo.trf_transfer_booking_assign (
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
    CONSTRAINT FK_trf_transfer_booking_assign_booking FOREIGN KEY (BookingId) REFERENCES dbo.trf_transfer_booking (BookingId),
    CONSTRAINT FK_trf_transfer_booking_assign_vehicle FOREIGN KEY (VehicleId) REFERENCES dbo.trf_vehicle (VehicleId),
    CONSTRAINT FK_trf_transfer_booking_assign_driver FOREIGN KEY (DriverId) REFERENCES dbo.trf_driver (DriverId)
);
