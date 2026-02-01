SET NOCOUNT ON;

DELETE FROM dbo.tgh_admin_unit_lang;
DELETE FROM dbo.tgh_admin_unit;
DELETE FROM dbo.tgh_country_lang;
DELETE FROM dbo.tgh_country;
DELETE FROM dbo.tgh_language;
DELETE FROM dbo.tgh_site_setting;

INSERT INTO dbo.tgh_language (LangCode, Name, NativeName, FlagUrl, IsDefault, Status, SortOrder, CreatedAt, CreatedBy, UpdatedAt, UpdatedBy)
VALUES
(N'vi', N'Vietnamese', N'Tiếng Việt', N'/lang/vietnam.png', 1, 1, 0, SYSUTCDATETIME(), N'system', SYSUTCDATETIME(), N'system'),
(N'en', N'English', N'English', N'/lang/english.png', 0, 1, 10, SYSUTCDATETIME(), N'system', SYSUTCDATETIME(), N'system');

INSERT INTO dbo.tgh_site_setting (SettingKey, SettingValue, Description, Status, SortOrder, CreatedAt, CreatedBy, UpdatedAt, UpdatedBy)
VALUES
(N'site_name', N'TripGoHub', N'Tên website', 1, 0, SYSUTCDATETIME(), N'system', SYSUTCDATETIME(), N'system'),
(N'logo_url', N'/logo.png', N'Logo website', 1, 10, SYSUTCDATETIME(), N'system', SYSUTCDATETIME(), N'system'),
(N'favicon_url', N'/fav.png', N'Favicon', 1, 20, SYSUTCDATETIME(), N'system', SYSUTCDATETIME(), N'system'),
(N'company_address', N'', N'Địa chỉ công ty', 1, 30, SYSUTCDATETIME(), N'system', SYSUTCDATETIME(), N'system'),
(N'hotline', N'', N'Hotline', 1, 40, SYSUTCDATETIME(), N'system', SYSUTCDATETIME(), N'system'),
(N'system_email', N'', N'Email hệ thống', 1, 50, SYSUTCDATETIME(), N'system', SYSUTCDATETIME(), N'system');

INSERT INTO dbo.tgh_country (Iso2, Iso3, PhoneCode, IsDefault, Status, SortOrder, CreatedAt, CreatedBy, UpdatedAt, UpdatedBy)
VALUES
(N'VN', N'VNM', N'+84', 1, 1, 0, SYSUTCDATETIME(), N'system', SYSUTCDATETIME(), N'system');

DECLARE @vnId INT = (SELECT CountryId FROM dbo.tgh_country WHERE Iso2 = N'VN');

INSERT INTO dbo.tgh_country_lang (CountryId, Lang, Name, NativeName, CreatedAt, CreatedBy, UpdatedAt, UpdatedBy)
VALUES
(@vnId, N'vi', N'Việt Nam', N'Việt Nam', SYSUTCDATETIME(), N'system', SYSUTCDATETIME(), N'system'),
(@vnId, N'en', N'Vietnam', N'Vietnam', SYSUTCDATETIME(), N'system', SYSUTCDATETIME(), N'system');
