SET NOCOUNT ON;

IF OBJECT_ID('dbo.tgh_admin_unit_lang', 'U') IS NOT NULL DROP TABLE dbo.tgh_admin_unit_lang;
IF OBJECT_ID('dbo.tgh_admin_unit', 'U') IS NOT NULL DROP TABLE dbo.tgh_admin_unit;
IF OBJECT_ID('dbo.tgh_country_lang', 'U') IS NOT NULL DROP TABLE dbo.tgh_country_lang;
IF OBJECT_ID('dbo.tgh_country', 'U') IS NOT NULL DROP TABLE dbo.tgh_country;
IF OBJECT_ID('dbo.tgh_slug', 'U') IS NOT NULL DROP TABLE dbo.tgh_slug;
IF OBJECT_ID('dbo.tgh_language', 'U') IS NOT NULL DROP TABLE dbo.tgh_language;
IF OBJECT_ID('dbo.tgh_site_setting', 'U') IS NOT NULL DROP TABLE dbo.tgh_site_setting;

CREATE TABLE dbo.tgh_language (
    LangId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    LangCode NVARCHAR(10) NOT NULL,
    Name NVARCHAR(100) NOT NULL,
    NativeName NVARCHAR(100) NULL,
    FlagUrl NVARCHAR(300) NULL,
    IsDefault BIT NOT NULL DEFAULT(0),
    Status TINYINT NOT NULL DEFAULT(1),
    SortOrder INT NOT NULL DEFAULT(0),
    CreatedAt DATETIME2 NOT NULL DEFAULT(SYSUTCDATETIME()),
    CreatedBy NVARCHAR(100) NOT NULL DEFAULT(N'system'),
    UpdatedAt DATETIME2 NOT NULL DEFAULT(SYSUTCDATETIME()),
    UpdatedBy NVARCHAR(100) NOT NULL DEFAULT(N'system')
);

CREATE UNIQUE INDEX UX_tgh_language_Code ON dbo.tgh_language (LangCode);

CREATE TABLE dbo.tgh_slug (
    SlugId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    Lang NVARCHAR(10) NOT NULL,
    Slug NVARCHAR(200) NOT NULL,
    EntityType NVARCHAR(50) NOT NULL,
    EntityId INT NOT NULL,
    Status TINYINT NOT NULL DEFAULT(1),
    SortOrder INT NOT NULL DEFAULT(0),
    CreatedAt DATETIME2 NOT NULL DEFAULT(SYSUTCDATETIME()),
    CreatedBy NVARCHAR(100) NOT NULL DEFAULT(N'system'),
    UpdatedAt DATETIME2 NOT NULL DEFAULT(SYSUTCDATETIME()),
    UpdatedBy NVARCHAR(100) NOT NULL DEFAULT(N'system'),
    CONSTRAINT FK_tgh_slug_language FOREIGN KEY (Lang) REFERENCES dbo.tgh_language (LangCode)
);

CREATE UNIQUE INDEX UX_tgh_slug_Lang_Slug ON dbo.tgh_slug (Lang, Slug);
CREATE INDEX IX_tgh_slug_Entity_Lang ON dbo.tgh_slug (EntityType, EntityId, Lang);

CREATE TABLE dbo.tgh_site_setting (
    SettingId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    SettingKey NVARCHAR(100) NOT NULL,
    SettingValue NVARCHAR(MAX) NULL,
    Description NVARCHAR(500) NULL,
    Status TINYINT NOT NULL DEFAULT(1),
    SortOrder INT NOT NULL DEFAULT(0),
    CreatedAt DATETIME2 NOT NULL DEFAULT(SYSUTCDATETIME()),
    CreatedBy NVARCHAR(100) NOT NULL DEFAULT(N'system'),
    UpdatedAt DATETIME2 NOT NULL DEFAULT(SYSUTCDATETIME()),
    UpdatedBy NVARCHAR(100) NOT NULL DEFAULT(N'system')
);

CREATE UNIQUE INDEX UX_tgh_site_setting_Key ON dbo.tgh_site_setting (SettingKey);

CREATE TABLE dbo.tgh_country (
    CountryId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    Iso2 NVARCHAR(2) NOT NULL,
    Iso3 NVARCHAR(3) NULL,
    PhoneCode NVARCHAR(10) NULL,
    IsDefault BIT NOT NULL DEFAULT(0),
    Status TINYINT NOT NULL DEFAULT(1),
    SortOrder INT NOT NULL DEFAULT(0),
    CreatedAt DATETIME2 NOT NULL DEFAULT(SYSUTCDATETIME()),
    CreatedBy NVARCHAR(100) NOT NULL DEFAULT(N'system'),
    UpdatedAt DATETIME2 NOT NULL DEFAULT(SYSUTCDATETIME()),
    UpdatedBy NVARCHAR(100) NOT NULL DEFAULT(N'system')
);

CREATE UNIQUE INDEX UX_tgh_country_Iso2 ON dbo.tgh_country (Iso2);

CREATE TABLE dbo.tgh_country_lang (
    CountryLangId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    CountryId INT NOT NULL,
    Lang NVARCHAR(10) NOT NULL,
    Name NVARCHAR(200) NOT NULL,
    NativeName NVARCHAR(200) NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT(SYSUTCDATETIME()),
    CreatedBy NVARCHAR(100) NOT NULL DEFAULT(N'system'),
    UpdatedAt DATETIME2 NOT NULL DEFAULT(SYSUTCDATETIME()),
    UpdatedBy NVARCHAR(100) NOT NULL DEFAULT(N'system'),
    CONSTRAINT FK_tgh_country_lang_country FOREIGN KEY (CountryId) REFERENCES dbo.tgh_country (CountryId) ON DELETE CASCADE,
    CONSTRAINT FK_tgh_country_lang_language FOREIGN KEY (Lang) REFERENCES dbo.tgh_language (LangCode)
);

CREATE UNIQUE INDEX UX_tgh_country_lang ON dbo.tgh_country_lang (CountryId, Lang);

CREATE TABLE dbo.tgh_admin_unit (
    AdminUnitId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    CountryId INT NOT NULL,
    ParentId INT NULL,
    LevelType NVARCHAR(30) NOT NULL,
    Code NVARCHAR(50) NULL,
    Status TINYINT NOT NULL DEFAULT(1),
    SortOrder INT NOT NULL DEFAULT(0),
    CreatedAt DATETIME2 NOT NULL DEFAULT(SYSUTCDATETIME()),
    CreatedBy NVARCHAR(100) NOT NULL DEFAULT(N'system'),
    UpdatedAt DATETIME2 NOT NULL DEFAULT(SYSUTCDATETIME()),
    UpdatedBy NVARCHAR(100) NOT NULL DEFAULT(N'system'),
    CONSTRAINT FK_tgh_admin_unit_country FOREIGN KEY (CountryId) REFERENCES dbo.tgh_country (CountryId),
    CONSTRAINT FK_tgh_admin_unit_parent FOREIGN KEY (ParentId) REFERENCES dbo.tgh_admin_unit (AdminUnitId)
);

CREATE INDEX IX_tgh_admin_unit_country ON dbo.tgh_admin_unit (CountryId);
CREATE INDEX IX_tgh_admin_unit_parent ON dbo.tgh_admin_unit (ParentId);
CREATE INDEX IX_tgh_admin_unit_level ON dbo.tgh_admin_unit (LevelType);

CREATE TABLE dbo.tgh_admin_unit_lang (
    AdminUnitLangId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    AdminUnitId INT NOT NULL,
    Lang NVARCHAR(10) NOT NULL,
    Name NVARCHAR(200) NOT NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT(SYSUTCDATETIME()),
    CreatedBy NVARCHAR(100) NOT NULL DEFAULT(N'system'),
    UpdatedAt DATETIME2 NOT NULL DEFAULT(SYSUTCDATETIME()),
    UpdatedBy NVARCHAR(100) NOT NULL DEFAULT(N'system'),
    CONSTRAINT FK_tgh_admin_unit_lang_admin_unit FOREIGN KEY (AdminUnitId) REFERENCES dbo.tgh_admin_unit (AdminUnitId) ON DELETE CASCADE,
    CONSTRAINT FK_tgh_admin_unit_lang_language FOREIGN KEY (Lang) REFERENCES dbo.tgh_language (LangCode)
);

CREATE UNIQUE INDEX UX_tgh_admin_unit_lang ON dbo.tgh_admin_unit_lang (AdminUnitId, Lang);
