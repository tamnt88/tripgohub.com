SET NOCOUNT ON;

IF OBJECT_ID('dbo.tgh_AdminUser', 'U') IS NOT NULL DROP TABLE dbo.tgh_AdminUser;

CREATE TABLE dbo.tgh_AdminUser (
    Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    Username NVARCHAR(100) NOT NULL UNIQUE,
    PasswordHash VARBINARY(64) NOT NULL,
    PasswordSalt VARBINARY(16) NOT NULL,
    FullName NVARCHAR(200) NULL,
    Role NVARCHAR(50) NOT NULL DEFAULT(N'admin'),
    Status TINYINT NOT NULL DEFAULT(1),
    SortOrder INT NOT NULL DEFAULT(0),
    CreatedAt DATETIME2 NOT NULL DEFAULT(SYSUTCDATETIME()),
    CreatedBy NVARCHAR(100) NOT NULL DEFAULT(N'system'),
    UpdatedAt DATETIME2 NOT NULL DEFAULT(SYSUTCDATETIME()),
    UpdatedBy NVARCHAR(100) NOT NULL DEFAULT(N'system')
);

DECLARE @salt VARBINARY(16) = CRYPT_GEN_RANDOM(16);
DECLARE @hash VARBINARY(64) = HASHBYTES('SHA2_512', @salt + CONVERT(VARBINARY(4000), N'123456'));

IF NOT EXISTS (SELECT 1 FROM dbo.tgh_AdminUser WHERE Username = N'admin')
BEGIN
    INSERT INTO dbo.tgh_AdminUser (Username, PasswordHash, PasswordSalt, FullName, Role, Status, SortOrder, CreatedBy, UpdatedBy)
    VALUES (N'admin', @hash, @salt, N'Administrator', N'admin', 1, 0, N'system', N'system');
END;
