SET NOCOUNT ON;

IF OBJECT_ID('dbo.tgh_TranslateAdminUnitName', 'FN') IS NOT NULL
    DROP FUNCTION dbo.tgh_TranslateAdminUnitName;
GO
CREATE FUNCTION dbo.tgh_TranslateAdminUnitName(@input NVARCHAR(200))
RETURNS NVARCHAR(200)
AS
BEGIN
    DECLARE @value NVARCHAR(200) = LTRIM(RTRIM(@input));
    IF @value IS NULL OR @value = N'' RETURN @value;

    SET @value = REPLACE(@value, N'Th?nh ph?', N'City');
    SET @value = REPLACE(@value, N'Tp.', N'City');
    SET @value = REPLACE(@value, N'TP.', N'City');
    SET @value = REPLACE(@value, N'Tp', N'City');
    SET @value = REPLACE(@value, N'TP', N'City');
    SET @value = REPLACE(@value, N'T?nh', N'Province');
    SET @value = REPLACE(@value, N'Qu?n', N'District');
    SET @value = REPLACE(@value, N'Huy?n', N'District');
    SET @value = REPLACE(@value, N'Th? x?', N'Town');
    SET @value = REPLACE(@value, N'Th? tr?n', N'Town');
    SET @value = REPLACE(@value, N'Ph??ng', N'Ward');
    SET @value = REPLACE(@value, N'X?', N'Commune');

    RETURN @value;
END;
GO


INSERT INTO dbo.tgh_admin_unit_lang (AdminUnitId, Lang, Name, CreatedAt, CreatedBy, UpdatedAt, UpdatedBy)
SELECT l.AdminUnitId, N'en', dbo.tgh_TranslateAdminUnitName(l.Name), SYSUTCDATETIME(), N'system', SYSUTCDATETIME(), N'system'
FROM dbo.tgh_admin_unit_lang l
WHERE l.Lang = N'vi'
  AND NOT EXISTS (
      SELECT 1 FROM dbo.tgh_admin_unit_lang x
      WHERE x.AdminUnitId = l.AdminUnitId AND x.Lang = N'en'
  );
