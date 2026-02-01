SET NOCOUNT ON;

IF OBJECT_ID('dbo.trf_route_lang', 'U') IS NOT NULL DROP TABLE dbo.trf_route_lang;
IF OBJECT_ID('dbo.trf_vehicle_type_lang', 'U') IS NOT NULL DROP TABLE dbo.trf_vehicle_type_lang;
IF OBJECT_ID('dbo.trf_vehicle_brand_lang', 'U') IS NOT NULL DROP TABLE dbo.trf_vehicle_brand_lang;
IF OBJECT_ID('dbo.trf_vehicle_model_lang', 'U') IS NOT NULL DROP TABLE dbo.trf_vehicle_model_lang;

CREATE TABLE dbo.trf_route_lang (
    RouteLangId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    RouteId INT NOT NULL,
    Lang NVARCHAR(10) NOT NULL,
    FromName NVARCHAR(200) NOT NULL,
    ToName NVARCHAR(200) NOT NULL,
    SeoTitle NVARCHAR(200) NULL,
    SeoDescription NVARCHAR(MAX) NULL,
    SeoKeywords NVARCHAR(500) NULL,
    SlugId INT NULL,
    Status TINYINT NOT NULL DEFAULT(1),
    SortOrder INT NOT NULL DEFAULT(0),
    CreatedAt DATETIME2 NOT NULL DEFAULT(SYSUTCDATETIME()),
    CreatedBy NVARCHAR(100) NOT NULL DEFAULT(N'system'),
    UpdatedAt DATETIME2 NOT NULL DEFAULT(SYSUTCDATETIME()),
    UpdatedBy NVARCHAR(100) NOT NULL DEFAULT(N'system'),
    CONSTRAINT FK_trf_route_lang_route FOREIGN KEY (RouteId) REFERENCES dbo.trf_route (RouteId),
    CONSTRAINT FK_trf_route_lang_slug FOREIGN KEY (SlugId) REFERENCES dbo.tgh_slug (SlugId),
    CONSTRAINT FK_trf_route_lang_language FOREIGN KEY (Lang) REFERENCES dbo.tgh_language (LangCode)
);

CREATE TABLE dbo.trf_vehicle_type_lang (
    VehicleTypeLangId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    VehicleTypeId INT NOT NULL,
    Lang NVARCHAR(10) NOT NULL,
    Name NVARCHAR(100) NOT NULL,
    Description NVARCHAR(MAX) NULL,
    SeoTitle NVARCHAR(200) NULL,
    SeoDescription NVARCHAR(MAX) NULL,
    SeoKeywords NVARCHAR(500) NULL,
    SlugId INT NULL,
    Status TINYINT NOT NULL DEFAULT(1),
    SortOrder INT NOT NULL DEFAULT(0),
    CreatedAt DATETIME2 NOT NULL DEFAULT(SYSUTCDATETIME()),
    CreatedBy NVARCHAR(100) NOT NULL DEFAULT(N'system'),
    UpdatedAt DATETIME2 NOT NULL DEFAULT(SYSUTCDATETIME()),
    UpdatedBy NVARCHAR(100) NOT NULL DEFAULT(N'system'),
    CONSTRAINT FK_trf_vehicle_type_lang_type FOREIGN KEY (VehicleTypeId) REFERENCES dbo.trf_vehicle_type (VehicleTypeId),
    CONSTRAINT FK_trf_vehicle_type_lang_slug FOREIGN KEY (SlugId) REFERENCES dbo.tgh_slug (SlugId),
    CONSTRAINT FK_trf_vehicle_type_lang_language FOREIGN KEY (Lang) REFERENCES dbo.tgh_language (LangCode)
);

CREATE TABLE dbo.trf_vehicle_brand_lang (
    BrandLangId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    BrandId INT NOT NULL,
    Lang NVARCHAR(10) NOT NULL,
    Name NVARCHAR(100) NOT NULL,
    Summary NVARCHAR(MAX) NULL,
    SeoTitle NVARCHAR(200) NULL,
    SeoDescription NVARCHAR(MAX) NULL,
    SeoKeywords NVARCHAR(500) NULL,
    SlugId INT NULL,
    Status TINYINT NOT NULL DEFAULT(1),
    SortOrder INT NOT NULL DEFAULT(0),
    CreatedAt DATETIME2 NOT NULL DEFAULT(SYSUTCDATETIME()),
    CreatedBy NVARCHAR(100) NOT NULL DEFAULT(N'system'),
    UpdatedAt DATETIME2 NOT NULL DEFAULT(SYSUTCDATETIME()),
    UpdatedBy NVARCHAR(100) NOT NULL DEFAULT(N'system'),
    CONSTRAINT FK_trf_vehicle_brand_lang_brand FOREIGN KEY (BrandId) REFERENCES dbo.trf_vehicle_brand (BrandId),
    CONSTRAINT FK_trf_vehicle_brand_lang_slug FOREIGN KEY (SlugId) REFERENCES dbo.tgh_slug (SlugId),
    CONSTRAINT FK_trf_vehicle_brand_lang_language FOREIGN KEY (Lang) REFERENCES dbo.tgh_language (LangCode)
);

CREATE TABLE dbo.trf_vehicle_model_lang (
    ModelLangId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    ModelId INT NOT NULL,
    Lang NVARCHAR(10) NOT NULL,
    Name NVARCHAR(100) NOT NULL,
    SeoTitle NVARCHAR(200) NULL,
    SeoDescription NVARCHAR(MAX) NULL,
    SlugId INT NULL,
    Status TINYINT NOT NULL DEFAULT(1),
    SortOrder INT NOT NULL DEFAULT(0),
    CreatedAt DATETIME2 NOT NULL DEFAULT(SYSUTCDATETIME()),
    CreatedBy NVARCHAR(100) NOT NULL DEFAULT(N'system'),
    UpdatedAt DATETIME2 NOT NULL DEFAULT(SYSUTCDATETIME()),
    UpdatedBy NVARCHAR(100) NOT NULL DEFAULT(N'system'),
    CONSTRAINT FK_trf_vehicle_model_lang_model FOREIGN KEY (ModelId) REFERENCES dbo.trf_vehicle_model (ModelId),
    CONSTRAINT FK_trf_vehicle_model_lang_slug FOREIGN KEY (SlugId) REFERENCES dbo.tgh_slug (SlugId),
    CONSTRAINT FK_trf_vehicle_model_lang_language FOREIGN KEY (Lang) REFERENCES dbo.tgh_language (LangCode)
);

CREATE UNIQUE INDEX UX_trf_route_lang_Route_Lang ON dbo.trf_route_lang (RouteId, Lang);
CREATE UNIQUE INDEX UX_trf_vehicle_type_lang_Type_Lang ON dbo.trf_vehicle_type_lang (VehicleTypeId, Lang);
CREATE UNIQUE INDEX UX_trf_vehicle_brand_lang_Brand_Lang ON dbo.trf_vehicle_brand_lang (BrandId, Lang);
CREATE UNIQUE INDEX UX_trf_vehicle_model_lang_Model_Lang ON dbo.trf_vehicle_model_lang (ModelId, Lang);
