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

IF NOT EXISTS (SELECT 1 FROM dbo.tgh_vehicle_brand WHERE Slug = N'toyota')
    INSERT INTO dbo.tgh_vehicle_brand (Name, Slug, LogoUrl, LogoAlt, Summary, SeoTitle, SeoDescription, SeoKeywords, Status, SortOrder, CreatedBy, UpdatedBy)
    VALUES (N'Toyota', N'toyota', N'/Content/brands/toyota.png', N'Logo Toyota', N'Hãng xe Toyota', N'Toyota - TripGoHub', N'Hãng xe Toyota chính hãng', N'toyota, hang xe, xe toyota', 1, 1, N'seed', N'seed');

IF NOT EXISTS (SELECT 1 FROM dbo.tgh_vehicle_brand WHERE Slug = N'kia')
    INSERT INTO dbo.tgh_vehicle_brand (Name, Slug, LogoUrl, LogoAlt, Summary, SeoTitle, SeoDescription, SeoKeywords, Status, SortOrder, CreatedBy, UpdatedBy)
    VALUES (N'Kia', N'kia', N'/Content/brands/kia.png', N'Logo Kia', N'Hãng xe Kia', N'Kia - TripGoHub', N'Hãng xe Kia chính hãng', N'kia, hang xe, xe kia', 1, 2, N'seed', N'seed');

DECLARE @brandToyota INT;
DECLARE @brandKia INT;
SELECT @brandToyota = BrandId FROM dbo.tgh_vehicle_brand WHERE Slug = N'toyota';
SELECT @brandKia = BrandId FROM dbo.tgh_vehicle_brand WHERE Slug = N'kia';

IF NOT EXISTS (SELECT 1 FROM dbo.tgh_vehicle_model WHERE BrandId = @brandToyota AND Slug = N'vios')
    INSERT INTO dbo.tgh_vehicle_model (BrandId, Name, Slug, YearFrom, YearTo, SeoTitle, SeoDescription, Status, SortOrder, CreatedBy, UpdatedBy)
    VALUES (@brandToyota, N'Vios', N'vios', 2018, NULL, N'Toyota Vios', N'Mẫu xe Toyota Vios', 1, 1, N'seed', N'seed');

IF NOT EXISTS (SELECT 1 FROM dbo.tgh_vehicle_model WHERE BrandId = @brandKia AND Slug = N'sedona')
    INSERT INTO dbo.tgh_vehicle_model (BrandId, Name, Slug, YearFrom, YearTo, SeoTitle, SeoDescription, Status, SortOrder, CreatedBy, UpdatedBy)
    VALUES (@brandKia, N'Sedona', N'sedona', 2017, NULL, N'Kia Sedona', N'Mẫu xe Kia Sedona', 1, 1, N'seed', N'seed');

DECLARE @modelVios INT;
DECLARE @modelSedona INT;
SELECT @modelVios = ModelId FROM dbo.tgh_vehicle_model WHERE BrandId = @brandToyota AND Slug = N'vios';
SELECT @modelSedona = ModelId FROM dbo.tgh_vehicle_model WHERE BrandId = @brandKia AND Slug = N'sedona';

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

UPDATE dbo.tgh_vehicle
SET BrandId = @brandToyota, ModelId = @modelVios
WHERE LicensePlate = N'51F-123.45' AND (BrandId IS NULL OR ModelId IS NULL);

UPDATE dbo.tgh_vehicle
SET BrandId = @brandKia, ModelId = @modelSedona
WHERE LicensePlate = N'51G-678.90' AND (BrandId IS NULL OR ModelId IS NULL);

IF NOT EXISTS (SELECT 1 FROM dbo.tgh_driver WHERE Phone = N'0900000001')
    INSERT INTO dbo.tgh_driver (FullName, Phone, Email, LicenseNumber, Status, SortOrder, CreatedBy, UpdatedBy)
    VALUES (N'Nguyễn Văn An', N'0900000001', N'an.driver@tripgohub.local', N'B2-000001', 1, 1, N'seed', N'seed');

IF NOT EXISTS (SELECT 1 FROM dbo.tgh_driver WHERE Phone = N'0900000002')
    INSERT INTO dbo.tgh_driver (FullName, Phone, Email, LicenseNumber, Status, SortOrder, CreatedBy, UpdatedBy)
    VALUES (N'Trần Thị Bình', N'0900000002', N'binh.driver@tripgohub.local', N'B2-000002', 1, 2, N'seed', N'seed');

DECLARE @routes TABLE (
    FromName NVARCHAR(200),
    ToName NVARCHAR(200),
    DistanceKm DECIMAL(10,2),
    DurationMin INT,
    SortOrder INT
);

INSERT INTO @routes (FromName, ToName, DistanceKm, DurationMin, SortOrder)
VALUES
    (N'Sân bay Tân Sơn Nhất', N'Quận 3', 7.5, 25, 10),
    (N'Sân bay Tân Sơn Nhất', N'Quận 7', 12.0, 40, 11),
    (N'Sân bay Tân Sơn Nhất', N'Phú Nhuận', 6.0, 20, 12),
    (N'Sân bay Tân Sơn Nhất', N'Gò Vấp', 5.0, 18, 13),
    (N'Sân bay Tân Sơn Nhất', N'Bình Thạnh', 8.0, 28, 14),
    (N'Sân bay Tân Sơn Nhất', N'Tân Bình', 3.5, 12, 15),
    (N'Sân bay Tân Sơn Nhất', N'Tân Phú', 9.0, 30, 16),
    (N'Sân bay Tân Sơn Nhất', N'Quận 5', 9.5, 32, 17),
    (N'Sân bay Tân Sơn Nhất', N'Quận 10', 7.0, 24, 18),
    (N'Sân bay Tân Sơn Nhất', N'Bình Tân', 16.0, 45, 19),
    (N'Quận 1', N'Quận 3', 2.5, 12, 20),
    (N'Quận 1', N'Quận 7', 6.5, 25, 21),
    (N'Quận 1', N'Quận 2', 5.0, 20, 22),
    (N'Quận 1', N'Quận 5', 4.0, 18, 23),
    (N'Quận 1', N'Phú Nhuận', 4.5, 20, 24),
    (N'Quận 1', N'Bình Thạnh', 5.5, 22, 25),
    (N'Quận 1', N'Thủ Đức', 15.0, 45, 26),
    (N'Quận 1', N'Quận 9', 18.0, 55, 27),
    (N'Quận 1', N'Nhà Bè', 14.0, 45, 28),
    (N'Quận 1', N'Củ Chi', 35.0, 70, 29),
    (N'Quận 1', N'Dĩ An', 18.0, 50, 30),
    (N'Quận 1', N'Thuận An', 20.0, 55, 31),
    (N'Quận 1', N'Biên Hòa', 32.0, 70, 32),
    (N'Quận 1', N'Long Thành', 45.0, 75, 33),
    (N'Quận 1', N'Trảng Bom', 55.0, 85, 34),
    (N'Quận 1', N'Long Khánh', 70.0, 100, 35),
    (N'Quận 1', N'Bến Tre', 85.0, 115, 36),
    (N'Quận 1', N'Mỹ Tho', 75.0, 100, 37),
    (N'Quận 1', N'Cần Thơ', 170.0, 180, 38),
    (N'Quận 1', N'Đà Lạt', 310.0, 360, 39),
    (N'Quận 1', N'Nha Trang', 430.0, 480, 40),
    (N'Quận 1', N'Phan Thiết', 200.0, 210, 41),
    (N'Quận 1', N'Cam Ranh', 420.0, 470, 42),
    (N'Quận 1', N'Bảo Lộc', 190.0, 220, 43),
    (N'Quận 1', N'Tây Ninh', 95.0, 130, 44),
    (N'Quận 1', N'Châu Đốc', 240.0, 260, 45),
    (N'Quận 1', N'Rạch Giá', 270.0, 300, 46),
    (N'Quận 1', N'Hà Tiên', 320.0, 360, 47),
    (N'Quận 1', N'Sóc Trăng', 230.0, 260, 48),
    (N'Quận 1', N'Bạc Liêu', 280.0, 320, 49),
    (N'Quận 1', N'Cà Mau', 350.0, 400, 50),
    (N'Sân bay Nội Bài', N'Hoàn Kiếm', 30.0, 45, 51),
    (N'Sân bay Nội Bài', N'Cầu Giấy', 25.0, 40, 52),
    (N'Sân bay Nội Bài', N'Ba Đình', 28.0, 42, 53),
    (N'Sân bay Nội Bài', N'Long Biên', 32.0, 50, 54),
    (N'Sân bay Nội Bài', N'Thanh Xuân', 35.0, 55, 55),
    (N'Sân bay Đà Nẵng', N'Hải Châu', 4.5, 15, 56),
    (N'Sân bay Đà Nẵng', N'Sơn Trà', 6.0, 18, 57),
    (N'Sân bay Đà Nẵng', N'Ngũ Hành Sơn', 7.5, 22, 58),
    (N'Sân bay Phú Quốc', N'Dương Đông', 10.0, 20, 59),
    (N'Sân bay Phú Quốc', N'An Thới', 25.0, 40, 60);

INSERT INTO dbo.tgh_route (FromName, ToName, DistanceKm, DurationMin, Status, SortOrder, CreatedBy, UpdatedBy)
SELECT r.FromName, r.ToName, r.DistanceKm, r.DurationMin, 1, r.SortOrder, N'seed', N'seed'
FROM @routes r
WHERE NOT EXISTS (
    SELECT 1 FROM dbo.tgh_route t
    WHERE t.FromName = r.FromName AND t.ToName = r.ToName
);

DECLARE @newRoutes TABLE (RouteId INT, FromName NVARCHAR(200), ToName NVARCHAR(200), DistanceKm DECIMAL(10,2));
INSERT INTO @newRoutes (RouteId, FromName, ToName, DistanceKm)
SELECT RouteId, FromName, ToName, DistanceKm
FROM dbo.tgh_route
WHERE EXISTS (
    SELECT 1 FROM @routes r
    WHERE r.FromName = dbo.tgh_route.FromName AND r.ToName = dbo.tgh_route.ToName
);

INSERT INTO dbo.tgh_route_price (RouteId, VehicleTypeId, PriceOneWay, PriceRoundTrip, Status, SortOrder, CreatedBy, UpdatedBy)
SELECT r.RouteId, vt.VehicleTypeId,
       CAST(150000 + (r.DistanceKm * 2500) AS DECIMAL(18,2)) AS PriceOneWay,
       CAST(150000 + (r.DistanceKm * 4500) AS DECIMAL(18,2)) AS PriceRoundTrip,
       1, 0, N'seed', N'seed'
FROM @newRoutes r
CROSS JOIN dbo.tgh_vehicle_type vt
WHERE vt.Name IN (N'Xe 4 chỗ', N'Xe 7 chỗ', N'Xe 16 chỗ')
AND NOT EXISTS (
    SELECT 1 FROM dbo.tgh_route_price p
    WHERE p.RouteId = r.RouteId AND p.VehicleTypeId = vt.VehicleTypeId
);
