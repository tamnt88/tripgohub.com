SET NOCOUNT ON;

DELETE FROM dbo.pub_menu_lang;
DELETE FROM dbo.pub_menu;
DELETE FROM dbo.tgh_slug WHERE EntityType = N'pub_menu';

INSERT INTO dbo.pub_menu (ParentId, Code, IconClass, IsGroup, Target, Status, SortOrder, CreatedAt, CreatedBy, UpdatedAt, UpdatedBy)
VALUES
(NULL, N'sim', N'fa-solid fa-sim-card', 0, NULL, 1, 0, SYSUTCDATETIME(), N'system', SYSUTCDATETIME(), N'system'),
(NULL, N'visit', N'fa-solid fa-ticket', 0, NULL, 1, 10, SYSUTCDATETIME(), N'system', SYSUTCDATETIME(), N'system'),
(NULL, N'transfer', N'fa-solid fa-car', 0, NULL, 1, 20, SYSUTCDATETIME(), N'system', SYSUTCDATETIME(), N'system'),
(NULL, N'homestay', N'fa-solid fa-house', 0, NULL, 1, 30, SYSUTCDATETIME(), N'system', SYSUTCDATETIME(), N'system'),
(NULL, N'tour', N'fa-solid fa-map-location-dot', 0, NULL, 1, 40, SYSUTCDATETIME(), N'system', SYSUTCDATETIME(), N'system'),
(NULL, N'flight', N'fa-solid fa-plane', 0, NULL, 1, 50, SYSUTCDATETIME(), N'system', SYSUTCDATETIME(), N'system'),
(NULL, N'hotel', N'fa-solid fa-hotel', 0, NULL, 1, 60, SYSUTCDATETIME(), N'system', SYSUTCDATETIME(), N'system');

INSERT INTO dbo.tgh_slug (Lang, Slug, EntityType, EntityId, Status, SortOrder, CreatedAt, CreatedBy, UpdatedAt, UpdatedBy)
SELECT N'vi',
       CASE Code
           WHEN N'sim' THEN N'sim-du-lich'
           WHEN N'visit' THEN N've-tham-quan'
           WHEN N'transfer' THEN N'xe-di-chuyen'
           WHEN N'homestay' THEN N'homestay'
           WHEN N'tour' THEN N'tour'
           WHEN N'flight' THEN N've-may-bay'
           WHEN N'hotel' THEN N'phong-khach-san'
       END,
       N'pub_menu',
       MenuId,
       1, 0, SYSUTCDATETIME(), N'system', SYSUTCDATETIME(), N'system'
FROM dbo.pub_menu;

INSERT INTO dbo.tgh_slug (Lang, Slug, EntityType, EntityId, Status, SortOrder, CreatedAt, CreatedBy, UpdatedAt, UpdatedBy)
SELECT N'en',
       CASE Code
           WHEN N'sim' THEN N'travel-sim'
           WHEN N'visit' THEN N'attractions'
           WHEN N'transfer' THEN N'transfer'
           WHEN N'homestay' THEN N'homestay'
           WHEN N'tour' THEN N'tours'
           WHEN N'flight' THEN N'flights'
           WHEN N'hotel' THEN N'hotels'
       END,
       N'pub_menu',
       MenuId,
       1, 0, SYSUTCDATETIME(), N'system', SYSUTCDATETIME(), N'system'
FROM dbo.pub_menu;

INSERT INTO dbo.pub_menu_lang (MenuId, Lang, Title, Url, SeoTitle, SeoDescription, SeoKeywords, SlugId, Status, SortOrder, CreatedAt, CreatedBy, UpdatedAt, UpdatedBy)
SELECT m.MenuId,
       N'vi',
       CASE m.Code
           WHEN N'sim' THEN N'Sim du l?ch'
           WHEN N'visit' THEN N'Vé tham quan'
           WHEN N'transfer' THEN N'Xe di chuy?n'
           WHEN N'homestay' THEN N'Homestay'
           WHEN N'tour' THEN N'Tour'
           WHEN N'flight' THEN N'Ve´ máy bay'
           WHEN N'hotel' THEN N'Phòng khách s?n'
       END,
       CASE m.Code
           WHEN N'transfer' THEN N'/vi/transfer/booking'
           ELSE N'#'
       END,
       NULL,
       NULL,
       NULL,
       s.SlugId,
       1, 0, SYSUTCDATETIME(), N'system', SYSUTCDATETIME(), N'system'
FROM dbo.pub_menu m
LEFT JOIN dbo.tgh_slug s
    ON s.EntityType = N'pub_menu'
   AND s.EntityId = m.MenuId
   AND s.Lang = N'vi';

INSERT INTO dbo.pub_menu_lang (MenuId, Lang, Title, Url, SeoTitle, SeoDescription, SeoKeywords, SlugId, Status, SortOrder, CreatedAt, CreatedBy, UpdatedAt, UpdatedBy)
SELECT m.MenuId,
       N'en',
       CASE m.Code
           WHEN N'sim' THEN N'Travel SIM'
           WHEN N'visit' THEN N'Attractions'
           WHEN N'transfer' THEN N'Transfers'
           WHEN N'homestay' THEN N'Homestay'
           WHEN N'tour' THEN N'Tours'
           WHEN N'flight' THEN N'Flights'
           WHEN N'hotel' THEN N'Hotels'
       END,
       CASE m.Code
           WHEN N'transfer' THEN N'/en/transfer/booking'
           ELSE N'#'
       END,
       NULL,
       NULL,
       NULL,
       s.SlugId,
       1, 0, SYSUTCDATETIME(), N'system', SYSUTCDATETIME(), N'system'
FROM dbo.pub_menu m
LEFT JOIN dbo.tgh_slug s
    ON s.EntityType = N'pub_menu'
   AND s.EntityId = m.MenuId
   AND s.Lang = N'en';
