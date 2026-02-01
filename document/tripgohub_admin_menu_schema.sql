SET NOCOUNT ON;

IF OBJECT_ID('dbo.adm_menu_lang', 'U') IS NOT NULL DROP TABLE dbo.adm_menu_lang;
IF OBJECT_ID('dbo.adm_menu', 'U') IS NOT NULL DROP TABLE dbo.adm_menu;

CREATE TABLE dbo.adm_menu (
    MenuId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    ParentId INT NULL,
    Code NVARCHAR(60) NOT NULL,
    IconClass NVARCHAR(100) NULL,
    IsGroup BIT NOT NULL DEFAULT(0),
    Target NVARCHAR(20) NULL,
    Status TINYINT NOT NULL DEFAULT(1),
    SortOrder INT NOT NULL DEFAULT(0),
    CreatedAt DATETIME2 NOT NULL DEFAULT(SYSUTCDATETIME()),
    CreatedBy NVARCHAR(100) NOT NULL DEFAULT(N'system'),
    UpdatedAt DATETIME2 NOT NULL DEFAULT(SYSUTCDATETIME()),
    UpdatedBy NVARCHAR(100) NOT NULL DEFAULT(N'system'),
    CONSTRAINT FK_adm_menu_parent FOREIGN KEY (ParentId) REFERENCES dbo.adm_menu (MenuId)
);

CREATE TABLE dbo.adm_menu_lang (
    MenuLangId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    MenuId INT NOT NULL,
    Lang NVARCHAR(10) NOT NULL,
    Title NVARCHAR(150) NOT NULL,
    Url NVARCHAR(300) NULL,
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
    CONSTRAINT FK_adm_menu_lang_menu FOREIGN KEY (MenuId) REFERENCES dbo.adm_menu (MenuId),
    CONSTRAINT FK_adm_menu_lang_slug FOREIGN KEY (SlugId) REFERENCES dbo.tgh_slug (SlugId),
    CONSTRAINT FK_adm_menu_lang_language FOREIGN KEY (Lang) REFERENCES dbo.tgh_language (LangCode)
);

CREATE UNIQUE INDEX UX_adm_menu_Code ON dbo.adm_menu (Code);
CREATE INDEX IX_adm_menu_Parent_Sort ON dbo.adm_menu (ParentId, SortOrder);
CREATE UNIQUE INDEX UX_adm_menu_lang_Menu_Lang ON dbo.adm_menu_lang (MenuId, Lang);
