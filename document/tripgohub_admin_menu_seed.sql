SET NOCOUNT ON;

DELETE FROM dbo.adm_menu_lang;
DELETE FROM dbo.adm_menu;
DELETE FROM dbo.tgh_slug WHERE EntityType = N'admin_menu';

INSERT INTO dbo.adm_menu (ParentId, Code, IconClass, IsGroup, Target, Status, SortOrder, CreatedAt, CreatedBy, UpdatedAt, UpdatedBy)
VALUES
(NULL, N'dashboard', N'fa-solid fa-gauge', 0, NULL, 1, 0, SYSUTCDATETIME(), N'system', SYSUTCDATETIME(), N'system'),
(NULL, N'transfer', N'fa-solid fa-car', 1, NULL, 1, 10, SYSUTCDATETIME(), N'system', SYSUTCDATETIME(), N'system'),
(NULL, N'system', N'fa-solid fa-gear', 1, NULL, 1, 20, SYSUTCDATETIME(), N'system', SYSUTCDATETIME(), N'system');

DECLARE @transferId INT = (SELECT MenuId FROM dbo.adm_menu WHERE Code = N'transfer');
DECLARE @systemId INT = (SELECT MenuId FROM dbo.adm_menu WHERE Code = N'system');

INSERT INTO dbo.adm_menu (ParentId, Code, IconClass, IsGroup, Target, Status, SortOrder, CreatedAt, CreatedBy, UpdatedAt, UpdatedBy)
VALUES
(@transferId, N'transfer_bookings', NULL, 0, NULL, 1, 0, SYSUTCDATETIME(), N'system', SYSUTCDATETIME(), N'system'),
(@transferId, N'transfer_routes', NULL, 0, NULL, 1, 10, SYSUTCDATETIME(), N'system', SYSUTCDATETIME(), N'system'),
(@transferId, N'transfer_route_prices', NULL, 0, NULL, 1, 20, SYSUTCDATETIME(), N'system', SYSUTCDATETIME(), N'system'),
(@transferId, N'transfer_vehicles', NULL, 0, NULL, 1, 30, SYSUTCDATETIME(), N'system', SYSUTCDATETIME(), N'system'),
(@transferId, N'vehicle_brands', NULL, 0, NULL, 1, 40, SYSUTCDATETIME(), N'system', SYSUTCDATETIME(), N'system'),
(@transferId, N'vehicle_models', NULL, 0, NULL, 1, 50, SYSUTCDATETIME(), N'system', SYSUTCDATETIME(), N'system'),
(@transferId, N'transfer_drivers', NULL, 0, NULL, 1, 60, SYSUTCDATETIME(), N'system', SYSUTCDATETIME(), N'system'),
(@systemId, N'system_countries', NULL, 0, NULL, 1, -10, SYSUTCDATETIME(), N'system', SYSUTCDATETIME(), N'system'),
(@systemId, N'system_admin_units', NULL, 0, NULL, 1, -5, SYSUTCDATETIME(), N'system', SYSUTCDATETIME(), N'system'),
(@systemId, N'system_admin_menus', NULL, 0, NULL, 1, 20, SYSUTCDATETIME(), N'system', SYSUTCDATETIME(), N'system');

INSERT INTO dbo.tgh_slug (Lang, Slug, EntityType, EntityId, Status, SortOrder, CreatedAt, CreatedBy, UpdatedAt, UpdatedBy)
SELECT N'vi',
       CASE Code
           WHEN N'dashboard' THEN N'dashboard'
           WHEN N'transfer' THEN N'dat-xe'
           WHEN N'system' THEN N'cau-hinh-he-thong'
           WHEN N'transfer_bookings' THEN N'booking'
           WHEN N'transfer_routes' THEN N'tuyen'
           WHEN N'transfer_route_prices' THEN N'gia-tuyen'
           WHEN N'transfer_vehicles' THEN N'xe'
           WHEN N'vehicle_brands' THEN N'hang-xe'
           WHEN N'vehicle_models' THEN N'model-xe'
           WHEN N'transfer_drivers' THEN N'tai-xe'
           WHEN N'system_countries' THEN N'quoc-gia'
           WHEN N'system_admin_units' THEN N'don-vi-hanh-chinh'
           WHEN N'system_admin_menus' THEN N'menu-admin'
       END,
       N'admin_menu',
       MenuId,
       1, 0, SYSUTCDATETIME(), N'system', SYSUTCDATETIME(), N'system'
FROM dbo.adm_menu;

INSERT INTO dbo.tgh_slug (Lang, Slug, EntityType, EntityId, Status, SortOrder, CreatedAt, CreatedBy, UpdatedAt, UpdatedBy)
SELECT N'en',
       CASE Code
           WHEN N'dashboard' THEN N'dashboard'
           WHEN N'transfer' THEN N'transfers'
           WHEN N'system' THEN N'system-settings'
           WHEN N'transfer_bookings' THEN N'bookings'
           WHEN N'transfer_routes' THEN N'routes'
           WHEN N'transfer_route_prices' THEN N'route-prices'
           WHEN N'transfer_vehicles' THEN N'vehicles'
           WHEN N'vehicle_brands' THEN N'vehicle-brands'
           WHEN N'vehicle_models' THEN N'vehicle-models'
           WHEN N'transfer_drivers' THEN N'drivers'
           WHEN N'system_countries' THEN N'countries'
           WHEN N'system_admin_units' THEN N'admin-units'
           WHEN N'system_admin_menus' THEN N'admin-menus'
       END,
       N'admin_menu',
       MenuId,
       1, 0, SYSUTCDATETIME(), N'system', SYSUTCDATETIME(), N'system'
FROM dbo.adm_menu;

INSERT INTO dbo.adm_menu_lang (MenuId, Lang, Title, Url, SeoTitle, SeoDescription, SeoKeywords, SlugId, Status, SortOrder, CreatedAt, CreatedBy, UpdatedAt, UpdatedBy)
SELECT m.MenuId,
       N'vi',
       CASE m.Code
           WHEN N'dashboard' THEN N'Dashboard'
           WHEN N'transfer' THEN N'�?t xe'
           WHEN N'system' THEN N'C?u h�nh h? th?ng'
           WHEN N'transfer_bookings' THEN N'Booking'
           WHEN N'transfer_routes' THEN N'Tuy?n'
           WHEN N'transfer_route_prices' THEN N'Gi� tuy?n'
           WHEN N'transfer_vehicles' THEN N'Xe'
           WHEN N'vehicle_brands' THEN N'H�ng xe'
           WHEN N'vehicle_models' THEN N'Model xe'
           WHEN N'transfer_drivers' THEN N'T�i x?'
           WHEN N'system_provinces' THEN N'T?nh/Th�nh'
           WHEN N'system_wards' THEN N'Phu?ng/X�'
           WHEN N'system_countries' THEN N'Quốc gia'
           WHEN N'system_admin_menus' THEN N'Menu admin'
       END,
       CASE m.Code
           WHEN N'dashboard' THEN N'default.aspx'
           WHEN N'transfer_bookings' THEN N'transfer/transfer_bookings.aspx'
           WHEN N'transfer_routes' THEN N'transfer/transfer_routes.aspx'
           WHEN N'transfer_route_prices' THEN N'transfer/transfer_route_prices.aspx'
           WHEN N'transfer_vehicles' THEN N'transfer/transfer_vehicles.aspx'
           WHEN N'vehicle_brands' THEN N'transfer/vehicle_brands.aspx'
           WHEN N'vehicle_models' THEN N'transfer/vehicle_models.aspx'
           WHEN N'transfer_drivers' THEN N'transfer/transfer_drivers.aspx'
           WHEN N'system_countries' THEN N'system/countries.aspx'
           WHEN N'system_countries' THEN N'system/countries.aspx'
           WHEN N'system_admin_units' THEN N'system/admin_units.aspx'
           WHEN N'system_admin_units' THEN N'system/admin_units.aspx'
           WHEN N'system_admin_menus' THEN N'system/admin_menus.aspx'
           ELSE NULL
       END,
       NULL,
       NULL,
       NULL,
       s.SlugId,
       1, 0, SYSUTCDATETIME(), N'system', SYSUTCDATETIME(), N'system'
FROM dbo.adm_menu m
LEFT JOIN dbo.tgh_slug s
    ON s.EntityType = N'admin_menu'
   AND s.EntityId = m.MenuId
   AND s.Lang = N'vi';

INSERT INTO dbo.adm_menu_lang (MenuId, Lang, Title, Url, SeoTitle, SeoDescription, SeoKeywords, SlugId, Status, SortOrder, CreatedAt, CreatedBy, UpdatedAt, UpdatedBy)
SELECT m.MenuId,
       N'en',
       CASE m.Code
           WHEN N'dashboard' THEN N'Dashboard'
           WHEN N'transfer' THEN N'Transfers'
           WHEN N'system' THEN N'System Settings'
           WHEN N'transfer_bookings' THEN N'Bookings'
           WHEN N'transfer_routes' THEN N'Routes'
           WHEN N'transfer_route_prices' THEN N'Route Prices'
           WHEN N'transfer_vehicles' THEN N'Vehicles'
           WHEN N'vehicle_brands' THEN N'Vehicle Brands'
           WHEN N'vehicle_models' THEN N'Vehicle Models'
           WHEN N'transfer_drivers' THEN N'Drivers'
           WHEN N'system_countries' THEN N'Countries'
           WHEN N'system_admin_units' THEN N'Administrative Units'
           WHEN N'system_countries' THEN N'Countries'
           WHEN N'system_admin_menus' THEN N'Admin Menus'
       END,
       CASE m.Code
           WHEN N'dashboard' THEN N'default.aspx'
           WHEN N'transfer_bookings' THEN N'transfer/transfer_bookings.aspx'
           WHEN N'transfer_routes' THEN N'transfer/transfer_routes.aspx'
           WHEN N'transfer_route_prices' THEN N'transfer/transfer_route_prices.aspx'
           WHEN N'transfer_vehicles' THEN N'transfer/transfer_vehicles.aspx'
           WHEN N'vehicle_brands' THEN N'transfer/vehicle_brands.aspx'
           WHEN N'vehicle_models' THEN N'transfer/vehicle_models.aspx'
           WHEN N'transfer_drivers' THEN N'transfer/transfer_drivers.aspx'
           WHEN N'system_countries' THEN N'system/countries.aspx'
           WHEN N'system_countries' THEN N'system/countries.aspx'
           WHEN N'system_admin_units' THEN N'system/admin_units.aspx'
           WHEN N'system_admin_units' THEN N'system/admin_units.aspx'
           WHEN N'system_admin_menus' THEN N'system/admin_menus.aspx'
           ELSE NULL
       END,
       NULL,
       NULL,
       NULL,
       s.SlugId,
       1, 0, SYSUTCDATETIME(), N'system', SYSUTCDATETIME(), N'system'
FROM dbo.adm_menu m
LEFT JOIN dbo.tgh_slug s
    ON s.EntityType = N'admin_menu'
   AND s.EntityId = m.MenuId
   AND s.Lang = N'en';





