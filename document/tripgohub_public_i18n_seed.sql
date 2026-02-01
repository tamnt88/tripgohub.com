SET NOCOUNT ON;

DELETE FROM dbo.trf_route_lang;
DELETE FROM dbo.trf_vehicle_type_lang;
DELETE FROM dbo.trf_vehicle_brand_lang;
DELETE FROM dbo.trf_vehicle_model_lang;
DELETE FROM dbo.tgh_slug WHERE EntityType IN (N'route', N'vehicle_type', N'vehicle_brand', N'vehicle_model');

-- Route slugs
INSERT INTO dbo.tgh_slug (Lang, Slug, EntityType, EntityId, Status, SortOrder, CreatedAt, CreatedBy, UpdatedAt, UpdatedBy)
SELECT N'vi', N'route-' + CAST(RouteId AS NVARCHAR(20)), N'route', RouteId, 1, 0, SYSUTCDATETIME(), N'system', SYSUTCDATETIME(), N'system'
FROM dbo.trf_route;

INSERT INTO dbo.tgh_slug (Lang, Slug, EntityType, EntityId, Status, SortOrder, CreatedAt, CreatedBy, UpdatedAt, UpdatedBy)
SELECT N'en', N'route-' + CAST(RouteId AS NVARCHAR(20)), N'route', RouteId, 1, 0, SYSUTCDATETIME(), N'system', SYSUTCDATETIME(), N'system'
FROM dbo.trf_route;

-- Vehicle type slugs
INSERT INTO dbo.tgh_slug (Lang, Slug, EntityType, EntityId, Status, SortOrder, CreatedAt, CreatedBy, UpdatedAt, UpdatedBy)
SELECT N'vi', N'vehicle-type-' + CAST(VehicleTypeId AS NVARCHAR(20)), N'vehicle_type', VehicleTypeId, 1, 0, SYSUTCDATETIME(), N'system', SYSUTCDATETIME(), N'system'
FROM dbo.trf_vehicle_type;

INSERT INTO dbo.tgh_slug (Lang, Slug, EntityType, EntityId, Status, SortOrder, CreatedAt, CreatedBy, UpdatedAt, UpdatedBy)
SELECT N'en', N'vehicle-type-' + CAST(VehicleTypeId AS NVARCHAR(20)), N'vehicle_type', VehicleTypeId, 1, 0, SYSUTCDATETIME(), N'system', SYSUTCDATETIME(), N'system'
FROM dbo.trf_vehicle_type;

-- Vehicle brand slugs (prefer existing slug)
INSERT INTO dbo.tgh_slug (Lang, Slug, EntityType, EntityId, Status, SortOrder, CreatedAt, CreatedBy, UpdatedAt, UpdatedBy)
SELECT N'vi', ISNULL(NULLIF(Slug, N''), N'brand-' + CAST(BrandId AS NVARCHAR(20))), N'vehicle_brand', BrandId, 1, 0, SYSUTCDATETIME(), N'system', SYSUTCDATETIME(), N'system'
FROM dbo.trf_vehicle_brand;

INSERT INTO dbo.tgh_slug (Lang, Slug, EntityType, EntityId, Status, SortOrder, CreatedAt, CreatedBy, UpdatedAt, UpdatedBy)
SELECT N'en', ISNULL(NULLIF(Slug, N''), N'brand-' + CAST(BrandId AS NVARCHAR(20))), N'vehicle_brand', BrandId, 1, 0, SYSUTCDATETIME(), N'system', SYSUTCDATETIME(), N'system'
FROM dbo.trf_vehicle_brand;

-- Vehicle model slugs
INSERT INTO dbo.tgh_slug (Lang, Slug, EntityType, EntityId, Status, SortOrder, CreatedAt, CreatedBy, UpdatedAt, UpdatedBy)
SELECT N'vi', ISNULL(NULLIF(Slug, N''), N'model-' + CAST(ModelId AS NVARCHAR(20))), N'vehicle_model', ModelId, 1, 0, SYSUTCDATETIME(), N'system', SYSUTCDATETIME(), N'system'
FROM dbo.trf_vehicle_model;

INSERT INTO dbo.tgh_slug (Lang, Slug, EntityType, EntityId, Status, SortOrder, CreatedAt, CreatedBy, UpdatedAt, UpdatedBy)
SELECT N'en', ISNULL(NULLIF(Slug, N''), N'model-' + CAST(ModelId AS NVARCHAR(20))), N'vehicle_model', ModelId, 1, 0, SYSUTCDATETIME(), N'system', SYSUTCDATETIME(), N'system'
FROM dbo.trf_vehicle_model;

-- Route lang
INSERT INTO dbo.trf_route_lang (RouteId, Lang, FromName, ToName, SeoTitle, SeoDescription, SeoKeywords, SlugId, Status, SortOrder, CreatedAt, CreatedBy, UpdatedAt, UpdatedBy)
SELECT r.RouteId, N'vi', r.FromName, r.ToName, NULL, NULL, NULL,
       s.SlugId, 1, r.SortOrder, SYSUTCDATETIME(), N'system', SYSUTCDATETIME(), N'system'
FROM dbo.trf_route r
LEFT JOIN dbo.tgh_slug s ON s.EntityType = N'route' AND s.EntityId = r.RouteId AND s.Lang = N'vi';

INSERT INTO dbo.trf_route_lang (RouteId, Lang, FromName, ToName, SeoTitle, SeoDescription, SeoKeywords, SlugId, Status, SortOrder, CreatedAt, CreatedBy, UpdatedAt, UpdatedBy)
SELECT r.RouteId, N'en', r.FromName, r.ToName, NULL, NULL, NULL,
       s.SlugId, 1, r.SortOrder, SYSUTCDATETIME(), N'system', SYSUTCDATETIME(), N'system'
FROM dbo.trf_route r
LEFT JOIN dbo.tgh_slug s ON s.EntityType = N'route' AND s.EntityId = r.RouteId AND s.Lang = N'en';

-- Vehicle type lang
INSERT INTO dbo.trf_vehicle_type_lang (VehicleTypeId, Lang, Name, Description, SeoTitle, SeoDescription, SeoKeywords, SlugId, Status, SortOrder, CreatedAt, CreatedBy, UpdatedAt, UpdatedBy)
SELECT t.VehicleTypeId, N'vi', t.Name, t.Description, NULL, NULL, NULL,
       s.SlugId, 1, t.SortOrder, SYSUTCDATETIME(), N'system', SYSUTCDATETIME(), N'system'
FROM dbo.trf_vehicle_type t
LEFT JOIN dbo.tgh_slug s ON s.EntityType = N'vehicle_type' AND s.EntityId = t.VehicleTypeId AND s.Lang = N'vi';

INSERT INTO dbo.trf_vehicle_type_lang (VehicleTypeId, Lang, Name, Description, SeoTitle, SeoDescription, SeoKeywords, SlugId, Status, SortOrder, CreatedAt, CreatedBy, UpdatedAt, UpdatedBy)
SELECT t.VehicleTypeId, N'en', t.Name, t.Description, NULL, NULL, NULL,
       s.SlugId, 1, t.SortOrder, SYSUTCDATETIME(), N'system', SYSUTCDATETIME(), N'system'
FROM dbo.trf_vehicle_type t
LEFT JOIN dbo.tgh_slug s ON s.EntityType = N'vehicle_type' AND s.EntityId = t.VehicleTypeId AND s.Lang = N'en';

-- Vehicle brand lang
INSERT INTO dbo.trf_vehicle_brand_lang (BrandId, Lang, Name, Summary, SeoTitle, SeoDescription, SeoKeywords, SlugId, Status, SortOrder, CreatedAt, CreatedBy, UpdatedAt, UpdatedBy)
SELECT b.BrandId, N'vi', b.Name, b.Summary, b.SeoTitle, b.SeoDescription, b.SeoKeywords,
       s.SlugId, 1, b.SortOrder, SYSUTCDATETIME(), N'system', SYSUTCDATETIME(), N'system'
FROM dbo.trf_vehicle_brand b
LEFT JOIN dbo.tgh_slug s ON s.EntityType = N'vehicle_brand' AND s.EntityId = b.BrandId AND s.Lang = N'vi';

INSERT INTO dbo.trf_vehicle_brand_lang (BrandId, Lang, Name, Summary, SeoTitle, SeoDescription, SeoKeywords, SlugId, Status, SortOrder, CreatedAt, CreatedBy, UpdatedAt, UpdatedBy)
SELECT b.BrandId, N'en', b.Name, b.Summary, b.SeoTitle, b.SeoDescription, b.SeoKeywords,
       s.SlugId, 1, b.SortOrder, SYSUTCDATETIME(), N'system', SYSUTCDATETIME(), N'system'
FROM dbo.trf_vehicle_brand b
LEFT JOIN dbo.tgh_slug s ON s.EntityType = N'vehicle_brand' AND s.EntityId = b.BrandId AND s.Lang = N'en';

-- Vehicle model lang
INSERT INTO dbo.trf_vehicle_model_lang (ModelId, Lang, Name, SeoTitle, SeoDescription, SlugId, Status, SortOrder, CreatedAt, CreatedBy, UpdatedAt, UpdatedBy)
SELECT m.ModelId, N'vi', m.Name, m.SeoTitle, m.SeoDescription,
       s.SlugId, 1, m.SortOrder, SYSUTCDATETIME(), N'system', SYSUTCDATETIME(), N'system'
FROM dbo.trf_vehicle_model m
LEFT JOIN dbo.tgh_slug s ON s.EntityType = N'vehicle_model' AND s.EntityId = m.ModelId AND s.Lang = N'vi';

INSERT INTO dbo.trf_vehicle_model_lang (ModelId, Lang, Name, SeoTitle, SeoDescription, SlugId, Status, SortOrder, CreatedAt, CreatedBy, UpdatedAt, UpdatedBy)
SELECT m.ModelId, N'en', m.Name, m.SeoTitle, m.SeoDescription,
       s.SlugId, 1, m.SortOrder, SYSUTCDATETIME(), N'system', SYSUTCDATETIME(), N'system'
FROM dbo.trf_vehicle_model m
LEFT JOIN dbo.tgh_slug s ON s.EntityType = N'vehicle_model' AND s.EntityId = m.ModelId AND s.Lang = N'en';
