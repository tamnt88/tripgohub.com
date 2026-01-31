SET NOCOUNT ON;

IF NOT EXISTS (SELECT 1 FROM dbo.tgh_vehicle_type WHERE Name = N'Xe 4 chỗ')
    INSERT INTO dbo.tgh_vehicle_type (Name, Capacity, Description, Status, SortOrder, CreatedBy, UpdatedBy)
    VALUES (N'Xe 4 chỗ', 4, N'Sedan tiêu chuẩn', 1, 1, N'seed', N'seed');

IF NOT EXISTS (SELECT 1 FROM dbo.tgh_vehicle_type WHERE Name = N'Xe 7 chỗ')
    INSERT INTO dbo.tgh_vehicle_type (Name, Capacity, Description, Status, SortOrder, CreatedBy, UpdatedBy)
    VALUES (N'Xe 7 chỗ', 7, N'MPV/SUV rộng rãi', 1, 2, N'seed', N'seed');

IF NOT EXISTS (SELECT 1 FROM dbo.tgh_vehicle_type WHERE Name = N'Xe 16 chỗ')
    INSERT INTO dbo.tgh_vehicle_type (Name, Capacity, Description, Status, SortOrder, CreatedBy, UpdatedBy)
    VALUES (N'Xe 16 chỗ', 16, N'Xe khách nhỏ', 1, 3, N'seed', N'seed');

DECLARE @route1 INT;
DECLARE @route2 INT;
DECLARE @route3 INT;

IF NOT EXISTS (SELECT 1 FROM dbo.tgh_route WHERE FromName = N'Sân bay Tân Sơn Nhất' AND ToName = N'Quận 1')
BEGIN
    INSERT INTO dbo.tgh_route (FromName, ToName, DistanceKm, DurationMin, Status, SortOrder, CreatedBy, UpdatedBy)
    VALUES (N'Sân bay Tân Sơn Nhất', N'Quận 1', 8.5, 30, 1, 1, N'seed', N'seed');
END

IF NOT EXISTS (SELECT 1 FROM dbo.tgh_route WHERE FromName = N'Sân bay Tân Sơn Nhất' AND ToName = N'Thủ Đức')
BEGIN
    INSERT INTO dbo.tgh_route (FromName, ToName, DistanceKm, DurationMin, Status, SortOrder, CreatedBy, UpdatedBy)
    VALUES (N'Sân bay Tân Sơn Nhất', N'Thủ Đức', 18.0, 45, 1, 2, N'seed', N'seed');
END

IF NOT EXISTS (SELECT 1 FROM dbo.tgh_route WHERE FromName = N'Quận 1' AND ToName = N'Vũng Tàu')
BEGIN
    INSERT INTO dbo.tgh_route (FromName, ToName, DistanceKm, DurationMin, Status, SortOrder, CreatedBy, UpdatedBy)
    VALUES (N'Quận 1', N'Vũng Tàu', 95.0, 120, 1, 3, N'seed', N'seed');
END

SELECT @route1 = RouteId FROM dbo.tgh_route WHERE FromName = N'Sân bay Tân Sơn Nhất' AND ToName = N'Quận 1';
SELECT @route2 = RouteId FROM dbo.tgh_route WHERE FromName = N'Sân bay Tân Sơn Nhất' AND ToName = N'Thủ Đức';
SELECT @route3 = RouteId FROM dbo.tgh_route WHERE FromName = N'Quận 1' AND ToName = N'Vũng Tàu';

DECLARE @vt4 INT;
DECLARE @vt7 INT;
DECLARE @vt16 INT;

SELECT @vt4 = VehicleTypeId FROM dbo.tgh_vehicle_type WHERE Name = N'Xe 4 chỗ';
SELECT @vt7 = VehicleTypeId FROM dbo.tgh_vehicle_type WHERE Name = N'Xe 7 chỗ';
SELECT @vt16 = VehicleTypeId FROM dbo.tgh_vehicle_type WHERE Name = N'Xe 16 chỗ';

IF NOT EXISTS (SELECT 1 FROM dbo.tgh_route_price WHERE RouteId = @route1 AND VehicleTypeId = @vt4)
    INSERT INTO dbo.tgh_route_price (RouteId, VehicleTypeId, PriceOneWay, PriceRoundTrip, Status, SortOrder, CreatedBy, UpdatedBy)
    VALUES (@route1, @vt4, 180000, 320000, 1, 1, N'seed', N'seed');

IF NOT EXISTS (SELECT 1 FROM dbo.tgh_route_price WHERE RouteId = @route1 AND VehicleTypeId = @vt7)
    INSERT INTO dbo.tgh_route_price (RouteId, VehicleTypeId, PriceOneWay, PriceRoundTrip, Status, SortOrder, CreatedBy, UpdatedBy)
    VALUES (@route1, @vt7, 230000, 420000, 1, 2, N'seed', N'seed');

IF NOT EXISTS (SELECT 1 FROM dbo.tgh_route_price WHERE RouteId = @route1 AND VehicleTypeId = @vt16)
    INSERT INTO dbo.tgh_route_price (RouteId, VehicleTypeId, PriceOneWay, PriceRoundTrip, Status, SortOrder, CreatedBy, UpdatedBy)
    VALUES (@route1, @vt16, 380000, 700000, 1, 3, N'seed', N'seed');

IF NOT EXISTS (SELECT 1 FROM dbo.tgh_route_price WHERE RouteId = @route2 AND VehicleTypeId = @vt4)
    INSERT INTO dbo.tgh_route_price (RouteId, VehicleTypeId, PriceOneWay, PriceRoundTrip, Status, SortOrder, CreatedBy, UpdatedBy)
    VALUES (@route2, @vt4, 240000, 430000, 1, 1, N'seed', N'seed');

IF NOT EXISTS (SELECT 1 FROM dbo.tgh_route_price WHERE RouteId = @route2 AND VehicleTypeId = @vt7)
    INSERT INTO dbo.tgh_route_price (RouteId, VehicleTypeId, PriceOneWay, PriceRoundTrip, Status, SortOrder, CreatedBy, UpdatedBy)
    VALUES (@route2, @vt7, 300000, 540000, 1, 2, N'seed', N'seed');

IF NOT EXISTS (SELECT 1 FROM dbo.tgh_route_price WHERE RouteId = @route3 AND VehicleTypeId = @vt4)
    INSERT INTO dbo.tgh_route_price (RouteId, VehicleTypeId, PriceOneWay, PriceRoundTrip, Status, SortOrder, CreatedBy, UpdatedBy)
    VALUES (@route3, @vt4, 1300000, 2300000, 1, 1, N'seed', N'seed');

IF NOT EXISTS (SELECT 1 FROM dbo.tgh_route_price WHERE RouteId = @route3 AND VehicleTypeId = @vt7)
    INSERT INTO dbo.tgh_route_price (RouteId, VehicleTypeId, PriceOneWay, PriceRoundTrip, Status, SortOrder, CreatedBy, UpdatedBy)
    VALUES (@route3, @vt7, 1600000, 2800000, 1, 2, N'seed', N'seed');

IF NOT EXISTS (SELECT 1 FROM dbo.tgh_vehicle WHERE LicensePlate = N'51F-123.45')
    INSERT INTO dbo.tgh_vehicle (VehicleTypeId, LicensePlate, Brand, Model, Year, SeatCount, Status, SortOrder, CreatedBy, UpdatedBy)
    VALUES (@vt4, N'51F-123.45', N'Toyota', N'Vios', 2020, 4, 1, 1, N'seed', N'seed');

IF NOT EXISTS (SELECT 1 FROM dbo.tgh_vehicle WHERE LicensePlate = N'51G-678.90')
    INSERT INTO dbo.tgh_vehicle (VehicleTypeId, LicensePlate, Brand, Model, Year, SeatCount, Status, SortOrder, CreatedBy, UpdatedBy)
    VALUES (@vt7, N'51G-678.90', N'Kia', N'Sedona', 2021, 7, 1, 2, N'seed', N'seed');

IF NOT EXISTS (SELECT 1 FROM dbo.tgh_driver WHERE Phone = N'0900000001')
    INSERT INTO dbo.tgh_driver (FullName, Phone, Email, LicenseNumber, Status, SortOrder, CreatedBy, UpdatedBy)
    VALUES (N'Nguyễn Văn An', N'0900000001', N'an.driver@tripgohub.local', N'B2-000001', 1, 1, N'seed', N'seed');

IF NOT EXISTS (SELECT 1 FROM dbo.tgh_driver WHERE Phone = N'0900000002')
    INSERT INTO dbo.tgh_driver (FullName, Phone, Email, LicenseNumber, Status, SortOrder, CreatedBy, UpdatedBy)
    VALUES (N'Trần Thị Bình', N'0900000002', N'binh.driver@tripgohub.local', N'B2-000002', 1, 2, N'seed', N'seed');
