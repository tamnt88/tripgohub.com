<%@ WebHandler Language="C#" Class="TripGoHub.Web.Admin.Api.SystemConfig.AdminMenusHandler" %>
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.SessionState;

namespace TripGoHub.Web.Admin.Api.SystemConfig
{
    public class AdminMenusHandler : IHttpHandler, IRequiresSessionState
    {
        private const string EntityType = "admin_menu";

        public void ProcessRequest(HttpContext context)
        {
            if (!IsAuthorized(context))
            {
                context.Response.StatusCode = 401;
                WriteError(context, "Unauthorized");
                return;
            }

            var action = (context.Request["action"] ?? string.Empty).ToLowerInvariant();
            if (action == "create")
            {
                CreateMenu(context);
                return;
            }

            if (action == "get")
            {
                WriteMenu(context);
                return;
            }

            if (action == "update")
            {
                UpdateMenu(context);
                return;
            }

            if (action == "delete")
            {
                DeleteMenu(context);
                return;
            }

            if (action == "parents")
            {
                WriteParents(context);
                return;
            }

            if (action == "translate")
            {
                TranslateSuggestion(context);
                return;
            }

            WriteDataTable(context);
        }

        public bool IsReusable { get { return false; } }

        private bool IsAuthorized(HttpContext context)
        {
            return context.Session != null && context.Session["AdminUserId"] != null;
        }

        private void WriteParents(HttpContext context)
        {
            using (var db = new TripGoHubDbContext())
            {
                var vi = db.AdminMenuLang.Where(x => x.Status == 1 && x.Lang == "vi").ToList();
                var viMap = vi.GroupBy(x => x.MenuId).ToDictionary(x => x.Key, x => x.First());

                var data = db.AdminMenus
                    .Where(x => x.Status == 1 && x.IsGroup)
                    .OrderBy(x => x.SortOrder).ThenBy(x => x.Code)
                    .ToList()
                    .Select(x => new
                    {
                        x.MenuId,
                        Title = viMap.ContainsKey(x.MenuId) ? viMap[x.MenuId].Title : x.Code
                    })
                    .ToList();

                var result = new { data = data };
                context.Response.ContentType = "application/json";
                context.Response.Write(Newtonsoft.Json.JsonConvert.SerializeObject(result));
            }
        }

        private void WriteDataTable(HttpContext context)
        {
            int draw = ToInt(context.Request["draw"]);
            int start = ToInt(context.Request["start"]);
            int length = ToInt(context.Request["length"], 10);
            string keyword = context.Request["keyword"] ?? string.Empty;
            string statusValue = context.Request["status"] ?? string.Empty;

            using (var db = new TripGoHubDbContext())
            {
                var query = from menu in db.AdminMenus
                            join viLang in db.AdminMenuLang on menu.MenuId equals viLang.MenuId into viJoin
                            from viLang in viJoin.Where(x => x.Lang == "vi").DefaultIfEmpty()
                            select new { menu, viLang };

                var totalAll = query.Count();

                if (!string.IsNullOrWhiteSpace(keyword))
                {
                    query = query.Where(x => x.menu.Code.Contains(keyword) || (x.viLang != null && x.viLang.Title.Contains(keyword)));
                }

                if (!string.IsNullOrWhiteSpace(statusValue))
                {
                    byte statusFilter;
                    if (byte.TryParse(statusValue, out statusFilter))
                    {
                        query = query.Where(x => x.menu.Status == statusFilter);
                    }
                }

                var totalFiltered = query.Count();
                var menus = query
                    .OrderBy(x => x.menu.SortOrder).ThenBy(x => x.menu.Code)
                    .Skip(start)
                    .Take(length)
                    .Select(x => x.menu)
                    .ToList();

                var menuIds = menus.Select(x => x.MenuId).ToList();
                var lang = db.AdminMenuLang.Where(x => menuIds.Contains(x.MenuId)).ToList();
                var viMap = lang.Where(x => x.Lang == "vi").GroupBy(x => x.MenuId).ToDictionary(x => x.Key, x => x.First());
                var enMap = lang.Where(x => x.Lang == "en").GroupBy(x => x.MenuId).ToDictionary(x => x.Key, x => x.First());

                var slugMap = db.Slugs
                    .Where(x => x.EntityType == EntityType && menuIds.Contains(x.EntityId))
                    .ToList()
                    .ToDictionary(x => x.EntityId + "|" + x.Lang, x => x);

                var parentIds = menus.Where(x => x.ParentId.HasValue).Select(x => x.ParentId.Value).Distinct().ToList();
                var parentLang = db.AdminMenuLang.Where(x => parentIds.Contains(x.MenuId) && x.Lang == "vi").ToList();
                var parentMap = parentLang.GroupBy(x => x.MenuId).ToDictionary(x => x.Key, x => x.First());

                var data = menus.Select(x => new
                {
                    x.MenuId,
                    x.ParentId,
                    ParentTitle = x.ParentId.HasValue && parentMap.ContainsKey(x.ParentId.Value) ? parentMap[x.ParentId.Value].Title : string.Empty,
                    x.Code,
                    TitleVi = viMap.ContainsKey(x.MenuId) ? viMap[x.MenuId].Title : string.Empty,
                    TitleEn = enMap.ContainsKey(x.MenuId) ? enMap[x.MenuId].Title : string.Empty,
                    SlugVi = GetSlug(slugMap, x.MenuId, "vi"),
                    SlugEn = GetSlug(slugMap, x.MenuId, "en"),
                    x.IsGroup,
                    x.Status,
                    x.SortOrder
                }).ToList();

                var result = new
                {
                    draw = draw,
                    recordsTotal = totalAll,
                    recordsFiltered = totalFiltered,
                    data = data
                };

                context.Response.ContentType = "application/json";
                context.Response.Write(Newtonsoft.Json.JsonConvert.SerializeObject(result));
            }
        }

                private void WriteMenu(HttpContext context)
        {
            int id = ToInt(context.Request["id"]);
            using (var db = new TripGoHubDbContext())
            {
                var menu = db.AdminMenus.FirstOrDefault(x => x.MenuId == id);
                if (menu == null)
                {
                    WriteError(context, "Kh?ng t?m th?y menu");
                    return;
                }

                var vi = db.AdminMenuLang.FirstOrDefault(x => x.MenuId == id && x.Lang == "vi");
                var en = db.AdminMenuLang.FirstOrDefault(x => x.MenuId == id && x.Lang == "en");
                var slugs = db.Slugs.Where(x => x.EntityType == EntityType && x.EntityId == id).ToList();
                var slugVi = slugs.FirstOrDefault(x => x.Lang == "vi");
                var slugEn = slugs.FirstOrDefault(x => x.Lang == "en");

                var data = new
                {
                    menu.MenuId,
                    menu.ParentId,
                    menu.Code,
                    TitleVi = vi != null ? vi.Title : string.Empty,
                    TitleEn = en != null ? en.Title : string.Empty,
                    UrlVi = vi != null ? vi.Url : string.Empty,
                    UrlEn = en != null ? en.Url : string.Empty,
                    SlugVi = slugVi != null ? slugVi.SlugText : string.Empty,
                    SlugEn = slugEn != null ? slugEn.SlugText : string.Empty,
                    SeoTitleVi = vi != null ? vi.SeoTitle : string.Empty,
                    SeoTitleEn = en != null ? en.SeoTitle : string.Empty,
                    SeoDescVi = vi != null ? vi.SeoDescription : string.Empty,
                    SeoDescEn = en != null ? en.SeoDescription : string.Empty,
                    SeoKeywordsVi = vi != null ? vi.SeoKeywords : string.Empty,
                    SeoKeywordsEn = en != null ? en.SeoKeywords : string.Empty,
                    menu.IconClass,
                    menu.IsGroup,
                    menu.Target,
                    menu.Status,
                    menu.SortOrder
                };

                context.Response.ContentType = "application/json";
                context.Response.Write(Newtonsoft.Json.JsonConvert.SerializeObject(new { ok = true, data = data }));
            }
        }

private void CreateMenu(HttpContext context)
        {
            int? parentId = ToNullableInt(context.Request["parentId"]);
            var code = (context.Request["code"] ?? string.Empty).Trim();
            var iconClass = (context.Request["iconClass"] ?? string.Empty).Trim();
            bool isGroup = ToBool(context.Request["isGroup"]);
            var target = (context.Request["target"] ?? string.Empty).Trim();
            byte status = ToByte(context.Request["status"], 1);
            int sortOrder = ToInt(context.Request["sortOrder"], 0);

            var vi = ReadLang(context, "vi");
            var en = ReadLang(context, "en");

            if (string.IsNullOrWhiteSpace(code) || string.IsNullOrWhiteSpace(vi.Title))
            {
                WriteError(context, "Code và tiêu d? (VI) là b?t bu?c");
                return;
            }

            if (string.IsNullOrWhiteSpace(en.Title))
            {
                en = AutoTranslate(vi, en);
            }

            using (var db = new TripGoHubDbContext())
            {
                if (db.AdminMenus.Any(x => x.Code == code))
                {
                    WriteError(context, "Code dă t?n t?i");
                    return;
                }

                var entity = new AdminMenu
                {
                    ParentId = parentId,
                    Code = code,
                    IconClass = string.IsNullOrWhiteSpace(iconClass) ? null : iconClass,
                    IsGroup = isGroup,
                    Target = string.IsNullOrWhiteSpace(target) ? null : target,
                    Status = status,
                    SortOrder = sortOrder,
                    CreatedAt = DateTime.UtcNow,
                    CreatedBy = (context.Session["AdminUsername"] ?? "admin").ToString(),
                    UpdatedAt = DateTime.UtcNow,
                    UpdatedBy = (context.Session["AdminUsername"] ?? "admin").ToString()
                };

                db.AdminMenus.Add(entity);
                db.SaveChanges();

                SaveLang(db, entity.MenuId, vi, (context.Session["AdminUsername"] ?? "admin").ToString());
                SaveLang(db, entity.MenuId, en, (context.Session["AdminUsername"] ?? "admin").ToString());

                db.SaveChanges();
            }

            WriteOk(context);
        }

        private void UpdateMenu(HttpContext context)
        {
            int id = ToInt(context.Request["id"]);
            int? parentId = ToNullableInt(context.Request["parentId"]);
            var code = (context.Request["code"] ?? string.Empty).Trim();
            var iconClass = (context.Request["iconClass"] ?? string.Empty).Trim();
            bool isGroup = ToBool(context.Request["isGroup"]);
            var target = (context.Request["target"] ?? string.Empty).Trim();
            byte status = ToByte(context.Request["status"], 1);
            int sortOrder = ToInt(context.Request["sortOrder"], 0);

            using (var db = new TripGoHubDbContext())
            {
                var entity = db.AdminMenus.FirstOrDefault(x => x.MenuId == id);
                if (entity == null)
                {
                    WriteError(context, "Kh?ng t?m th?y menu");
                    return;
                }

                var vi = ReadLang(context, "vi");
                var en = ReadLang(context, "en");

                if (!string.IsNullOrWhiteSpace(code) && entity.Code != code)
                {
                    if (db.AdminMenus.Any(x => x.Code == code && x.MenuId != id))
                    {
                        WriteError(context, "Code ?? t?n t?i");
                        return;
                    }
                    entity.Code = code;
                }

                entity.ParentId = parentId;
                entity.IconClass = string.IsNullOrWhiteSpace(iconClass) ? null : iconClass;
                entity.IsGroup = isGroup;
                entity.Target = string.IsNullOrWhiteSpace(target) ? null : target;
                entity.Status = status;
                entity.SortOrder = sortOrder;

                if (string.IsNullOrWhiteSpace(en.Title) && !string.IsNullOrWhiteSpace(vi.Title))
                {
                    en = AutoTranslate(vi, en);
                }

                UpdateLang(db, id, vi, (context.Session["AdminUsername"] ?? "admin").ToString());
                UpdateLang(db, id, en, (context.Session["AdminUsername"] ?? "admin").ToString());

                entity.UpdatedAt = DateTime.UtcNow;
                entity.UpdatedBy = (context.Session["AdminUsername"] ?? "admin").ToString();
                db.SaveChanges();
            }

            WriteOk(context);
        }

        private void DeleteMenu(HttpContext context)
        {
            int id = ToInt(context.Request["id"]);
            using (var db = new TripGoHubDbContext())
            {
                var entity = db.AdminMenus.FirstOrDefault(x => x.MenuId == id);
                if (entity != null)
                {
                    var hasChildren = db.AdminMenus.Any(x => x.ParentId == entity.MenuId);
                    if (hasChildren)
                    {
                        WriteError(context, "Không th? xóa menu dang có menu con");
                        return;
                    }

                    var lang = db.AdminMenuLang.Where(x => x.MenuId == entity.MenuId).ToList();
                    if (lang.Count > 0)
                    {
                        db.AdminMenuLang.RemoveRange(lang);
                    }

                    var slugs = db.Slugs.Where(x => x.EntityType == EntityType && x.EntityId == entity.MenuId).ToList();
                    if (slugs.Count > 0)
                    {
                        db.Slugs.RemoveRange(slugs);
                    }

                    db.AdminMenus.Remove(entity);
                    db.SaveChanges();
                }
            }

            WriteOk(context);
        }

        private static string GetValue(HttpContext context, string key)
        {
            var value = context.Request[key];
            return string.IsNullOrWhiteSpace(value) ? null : value.Trim();
        }

        private void TranslateSuggestion(HttpContext context)
        {
            var vi = ReadLang(context, "vi");
            var en = AutoTranslate(vi, new LangInput());
            var result = new
            {
                data = new
                {
                    titleEn = en.Title,
                    seoTitleEn = en.SeoTitle,
                    seoDescEn = en.SeoDescription,
                    seoKeywordsEn = en.SeoKeywords
                }
            };
            context.Response.ContentType = "application/json";
            context.Response.Write(Newtonsoft.Json.JsonConvert.SerializeObject(result));
        }

        private LangInput ReadLang(HttpContext context, string lang)
        {
            return new LangInput
            {
                Lang = lang,
                Title = GetValue(context, "title" + lang) ?? GetValue(context, "title" + lang.ToUpperInvariant()) ?? string.Empty,
                Url = GetValue(context, "url" + lang) ?? GetValue(context, "url" + lang.ToUpperInvariant()) ?? string.Empty,
                Slug = GetValue(context, "slug" + lang) ?? GetValue(context, "slug" + lang.ToUpperInvariant()) ?? string.Empty,
                SeoTitle = GetValue(context, "seoTitle" + lang) ?? GetValue(context, "seoTitle" + lang.ToUpperInvariant()) ?? string.Empty,
                SeoDescription = GetValue(context, "seoDesc" + lang) ?? GetValue(context, "seoDesc" + lang.ToUpperInvariant()) ?? string.Empty,
                SeoKeywords = GetValue(context, "seoKeywords" + lang) ?? GetValue(context, "seoKeywords" + lang.ToUpperInvariant()) ?? string.Empty
            };
        }

        private void SaveLang(TripGoHubDbContext db, int menuId, LangInput input, string username)
        {
            var slugId = SaveSlug(db, menuId, input.Lang, input.Slug, input.Title, username);

            var entity = new AdminMenuLang
            {
                MenuId = menuId,
                Lang = input.Lang,
                Title = input.Title,
                Url = string.IsNullOrWhiteSpace(input.Url) ? null : input.Url,
                SeoTitle = string.IsNullOrWhiteSpace(input.SeoTitle) ? null : input.SeoTitle,
                SeoDescription = string.IsNullOrWhiteSpace(input.SeoDescription) ? null : input.SeoDescription,
                SeoKeywords = string.IsNullOrWhiteSpace(input.SeoKeywords) ? null : input.SeoKeywords,
                SlugId = slugId,
                Status = 1,
                SortOrder = 0,
                CreatedAt = DateTime.UtcNow,
                CreatedBy = username,
                UpdatedAt = DateTime.UtcNow,
                UpdatedBy = username
            };

            db.AdminMenuLang.Add(entity);
        }

        private void UpdateLang(TripGoHubDbContext db, int menuId, LangInput input, string username)
        {
            var entity = db.AdminMenuLang.FirstOrDefault(x => x.MenuId == menuId && x.Lang == input.Lang);
            if (entity == null)
            {
                if (string.IsNullOrWhiteSpace(input.Title))
                {
                    return;
                }
                SaveLang(db, menuId, input, username);
                return;
            }

            if (!string.IsNullOrWhiteSpace(input.Title))
            {
                entity.Title = input.Title;
            }
            if (!string.IsNullOrWhiteSpace(input.Url))
            {
                entity.Url = input.Url;
            }
            if (!string.IsNullOrWhiteSpace(input.SeoTitle))
            {
                entity.SeoTitle = input.SeoTitle;
            }
            if (!string.IsNullOrWhiteSpace(input.SeoDescription))
            {
                entity.SeoDescription = input.SeoDescription;
            }
            if (!string.IsNullOrWhiteSpace(input.SeoKeywords))
            {
                entity.SeoKeywords = input.SeoKeywords;
            }
            if (!string.IsNullOrWhiteSpace(input.Slug))
            {
                entity.SlugId = SaveSlug(db, menuId, input.Lang, input.Slug, input.Title, username);
            }

            entity.UpdatedAt = DateTime.UtcNow;
            entity.UpdatedBy = username;
        }

        private int SaveSlug(TripGoHubDbContext db, int menuId, string lang, string slug, string title, string username)
        {
            var finalSlug = string.IsNullOrWhiteSpace(slug) ? Slugify(title) : Slugify(slug);
            finalSlug = EnsureUniqueSlug(db, lang, finalSlug, menuId);

            var existing = db.Slugs.FirstOrDefault(x => x.EntityType == EntityType && x.EntityId == menuId && x.Lang == lang);
            if (existing == null)
            {
                var entity = new Slug
                {
                    Lang = lang,
                    SlugText = finalSlug,
                    EntityType = EntityType,
                    EntityId = menuId,
                    Status = 1,
                    SortOrder = 0,
                    CreatedAt = DateTime.UtcNow,
                    CreatedBy = username,
                    UpdatedAt = DateTime.UtcNow,
                    UpdatedBy = username
                };
                db.Slugs.Add(entity);
                db.SaveChanges();
                return entity.SlugId;
            }

            existing.SlugText = finalSlug;
            existing.UpdatedAt = DateTime.UtcNow;
            existing.UpdatedBy = username;
            db.SaveChanges();
            return existing.SlugId;
        }

        private string EnsureUniqueSlug(TripGoHubDbContext db, string lang, string baseSlug, int menuId)
        {
            var slug = baseSlug;
            var counter = 2;
            while (db.Slugs.Any(x => x.Lang == lang && x.SlugText == slug && !(x.EntityType == EntityType && x.EntityId == menuId)))
            {
                slug = baseSlug + "-" + counter;
                counter++;
            }
            return slug;
        }

        private static string Slugify(string value)
        {
            if (string.IsNullOrWhiteSpace(value)) return string.Empty;
            var normalized = value.Trim().ToLowerInvariant().Normalize(NormalizationForm.FormD);
            var sb = new StringBuilder();
            foreach (var ch in normalized)
            {
                var uc = CharUnicodeInfo.GetUnicodeCategory(ch);
                if (uc == UnicodeCategory.NonSpacingMark) continue;
                if (char.IsLetterOrDigit(ch))
                {
                    sb.Append(ch);
                }
                else if (ch == ' ' || ch == '-' || ch == '_')
                {
                    sb.Append('-');
                }
            }
            var slug = Regex.Replace(sb.ToString(), "-+", "-").Trim('-');
            return slug;
        }

        private static LangInput AutoTranslate(LangInput vi, LangInput en)
        {
            en.Title = TranslateBasic(vi.Title);
            en.SeoTitle = TranslateBasic(vi.SeoTitle);
            en.SeoDescription = TranslateBasic(vi.SeoDescription);
            en.SeoKeywords = TranslateBasic(vi.SeoKeywords);
            return en;
        }

        private static string TranslateBasic(string input)
        {
            if (string.IsNullOrWhiteSpace(input)) return input;
            var map = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase)
            {
                { "Đ?t xe", "Transfers" },
                { "C?u h́nh h? th?ng", "System Settings" },
                { "Giá tuy?n", "Route Prices" },
                { "Tuy?n", "Routes" },
                { "Hăng xe", "Vehicle Brands" },
                { "Model xe", "Vehicle Models" },
                { "Tài x?", "Drivers" },
                { "T?nh/Thành", "Provinces" },
                { "Phu?ng/Xă", "Wards" },
                { "Menu admin", "Admin Menus" }
            };

            foreach (var pair in map)
            {
                input = input.Replace(pair.Key, pair.Value);
            }
            return input;
        }

        private static string GetSlug(Dictionary<string, Slug> map, int entityId, string lang)
        {
            Slug slug;
            return map.TryGetValue(entityId + "|" + lang, out slug) ? slug.SlugText : string.Empty;
        }

        private static int ToInt(string value, int defaultValue = 0)
        {
            int result;
            return int.TryParse(value, out result) ? result : defaultValue;
        }

        private static int? ToNullableInt(string value)
        {
            int result;
            return int.TryParse(value, out result) ? (int?)result : null;
        }

        private static byte ToByte(string value, byte defaultValue = 0)
        {
            byte result;
            return byte.TryParse(value, out result) ? result : defaultValue;
        }

        private static bool ToBool(string value)
        {
            if (string.IsNullOrWhiteSpace(value)) return false;
            return value == "1" || value.Equals("true", StringComparison.OrdinalIgnoreCase);
        }

        private static void WriteOk(HttpContext context)
        {
            context.Response.ContentType = "application/json";
            context.Response.Write("{\"ok\":true}");
        }

        private static void WriteError(HttpContext context, string message)
        {
            context.Response.ContentType = "application/json";
            context.Response.Write("{\"ok\":false,\"message\":\"" + HttpUtility.JavaScriptStringEncode(message) + "\"}");
        }

        private class LangInput
        {
            public string Lang { get; set; }
            public string Title { get; set; }
            public string Url { get; set; }
            public string Slug { get; set; }
            public string SeoTitle { get; set; }
            public string SeoDescription { get; set; }
            public string SeoKeywords { get; set; }
        }
    }
}
