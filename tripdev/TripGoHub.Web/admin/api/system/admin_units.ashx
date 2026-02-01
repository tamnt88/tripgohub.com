<%@ WebHandler Language="C#" Class="TripGoHub.Web.Admin.Api.SystemConfig.AdminUnitsHandler" %>
using System;
using System.Linq;
using System.Web;
using System.Web.SessionState;

namespace TripGoHub.Web.Admin.Api.SystemConfig
{
    public class AdminUnitsHandler : IHttpHandler, IRequiresSessionState
    {
        private const string DefaultLang = "vi";

        public void ProcessRequest(HttpContext context)
        {
            if (!IsAuthorized(context))
            {
                context.Response.StatusCode = 401;
                WriteError(context, "Unauthorized");
                return;
            }

            var action = (context.Request["action"] ?? string.Empty).ToLowerInvariant();
            if (action == "tree")
            {
                WriteTree(context);
                return;
            }

            if (action == "parents")
            {
                WriteParents(context);
                return;
            }

            if (action == "create")
            {
                CreateAdminUnit(context);
                return;
            }

            if (action == "update")
            {
                UpdateAdminUnit(context);
                return;
            }

            if (action == "delete")
            {
                DeleteAdminUnit(context);
                return;
            }

            if (action == "translate")
            {
                TranslateAdminUnit(context);
                return;
            }

            WriteDataTable(context);
        }

        public bool IsReusable { get { return false; } }

        private bool IsAuthorized(HttpContext context)
        {
            return context.Session != null && context.Session["AdminUserId"] != null;
        }

        private void WriteTree(HttpContext context)
        {
            int countryId = ToInt(context.Request["countryId"]);
            var lang = GetLang(context);

            using (var db = new TripGoHubDbContext())
            {
                var query = from unit in db.AdminUnits
                            join langSel in db.AdminUnitLang on unit.Id equals langSel.AdminUnitId into selJoin
                            from langSel in selJoin.Where(x => x.Lang == lang).DefaultIfEmpty()
                            join langVi in db.AdminUnitLang on unit.Id equals langVi.AdminUnitId into viJoin
                            from langVi in viJoin.Where(x => x.Lang == DefaultLang).DefaultIfEmpty()
                            select new { unit, langSel, langVi };

                if (countryId > 0)
                {
                    query = query.Where(x => x.unit.CountryId == countryId);
                }

                var nodes = query.Select(x => new
                {
                    id = x.unit.Id,
                    parent = x.unit.ParentId.HasValue ? x.unit.ParentId.Value.ToString() : "#",
                    text = (x.langSel != null ? x.langSel.Name : x.langVi.Name) + " (" + x.unit.LevelType + ")",
                    data = new
                    {
                        levelType = x.unit.LevelType,
                        status = x.unit.Status,
                        sortOrder = x.unit.SortOrder,
                        name = x.langSel != null ? x.langSel.Name : x.langVi.Name
                    }
                }).ToList();

                context.Response.ContentType = "application/json";
                context.Response.Write(Newtonsoft.Json.JsonConvert.SerializeObject(nodes));
            }
        }

        private void WriteParents(HttpContext context)
        {
            int countryId = ToInt(context.Request["countryId"]);
            var levelType = (context.Request["levelType"] ?? string.Empty).Trim();
            var lang = GetLang(context);

            using (var db = new TripGoHubDbContext())
            {
                var query = from unit in db.AdminUnits
                            join langSel in db.AdminUnitLang on unit.Id equals langSel.AdminUnitId into selJoin
                            from langSel in selJoin.Where(x => x.Lang == lang).DefaultIfEmpty()
                            join langVi in db.AdminUnitLang on unit.Id equals langVi.AdminUnitId into viJoin
                            from langVi in viJoin.Where(x => x.Lang == DefaultLang).DefaultIfEmpty()
                            select new { unit, langSel, langVi };

                if (countryId > 0)
                {
                    query = query.Where(x => x.unit.CountryId == countryId);
                }

                if (!string.IsNullOrWhiteSpace(levelType))
                {
                    query = query.Where(x => x.unit.LevelType == levelType);
                }

                var list = query.OrderBy(x => x.langSel != null ? x.langSel.Name : x.langVi.Name)
                    .Select(x => new { Id = x.unit.Id, Name = x.langSel != null ? x.langSel.Name : x.langVi.Name, LevelType = x.unit.LevelType })
                    .ToList();

                context.Response.ContentType = "application/json";
                context.Response.Write(Newtonsoft.Json.JsonConvert.SerializeObject(list));
            }
        }

        private void WriteDataTable(HttpContext context)
        {
            int draw = ToInt(context.Request["draw"]);
            int start = ToInt(context.Request["start"]);
            int length = ToInt(context.Request["length"], 10);
            string search = context.Request["search[value]"] ?? string.Empty;
            int countryId = ToInt(context.Request["countryId"]);
            string levelType = (context.Request["levelType"] ?? string.Empty).Trim();
            int parentId = ToInt(context.Request["parentId"]);
            var lang = GetLang(context);

            using (var db = new TripGoHubDbContext())
            {
                var query = from unit in db.AdminUnits
                            join langSel in db.AdminUnitLang on unit.Id equals langSel.AdminUnitId into selJoin
                            from langSel in selJoin.Where(x => x.Lang == lang).DefaultIfEmpty()
                            join langVi in db.AdminUnitLang on unit.Id equals langVi.AdminUnitId into viJoin
                            from langVi in viJoin.Where(x => x.Lang == DefaultLang).DefaultIfEmpty()
                            join parentLang in db.AdminUnitLang on unit.ParentId equals parentLang.AdminUnitId into parentJoin
                            from parentLang in parentJoin.Where(x => x.Lang == lang).DefaultIfEmpty()
                            select new { unit, langSel, langVi, parentLang };

                if (countryId > 0)
                {
                    query = query.Where(x => x.unit.CountryId == countryId);
                }

                if (!string.IsNullOrWhiteSpace(levelType))
                {
                    query = query.Where(x => x.unit.LevelType == levelType);
                }

                if (parentId > 0)
                {
                    query = query.Where(x => x.unit.ParentId == parentId);
                }

                if (!string.IsNullOrWhiteSpace(search))
                {
                    query = query.Where(x => (x.langSel != null ? x.langSel.Name : x.langVi.Name).Contains(search));
                }

                var total = query.Count();
                var data = query.OrderBy(x => x.langSel != null ? x.langSel.Name : x.langVi.Name)
                    .Skip(start)
                    .Take(length)
                    .Select(x => new
                    {
                        Id = x.unit.Id,
                        Name = x.langSel != null ? x.langSel.Name : x.langVi.Name,
                        x.unit.LevelType,
                        ParentName = x.parentLang != null ? x.parentLang.Name : string.Empty,
                        x.unit.Status,
                        x.unit.SortOrder
                    })
                    .ToList();

                var result = new
                {
                    draw = draw,
                    recordsTotal = total,
                    recordsFiltered = total,
                    data = data
                };

                context.Response.ContentType = "application/json";
                context.Response.Write(Newtonsoft.Json.JsonConvert.SerializeObject(result));
            }
        }

        private void CreateAdminUnit(HttpContext context)
        {
            int countryId = ToInt(context.Request["countryId"]);
            int parentId = ToInt(context.Request["parentId"]);
            var levelType = (context.Request["levelType"] ?? string.Empty).Trim();
            var name = (context.Request["name"] ?? string.Empty).Trim();
            var lang = GetLang(context);
            byte status = ToByte(context.Request["status"], 1);
            int sortOrder = ToInt(context.Request["sortOrder"], 0);

            if (countryId <= 0)
            {
                WriteError(context, "Quốc gia là bắt buộc");
                return;
            }

            if (string.IsNullOrWhiteSpace(levelType))
            {
                WriteError(context, "Cấp là bắt buộc");
                return;
            }

            if (string.IsNullOrWhiteSpace(name))
            {
                WriteError(context, "Tên là bắt buộc");
                return;
            }

            using (var db = new TripGoHubDbContext())
            {
                var unit = new AdminUnit
                {
                    CountryId = countryId,
                    ParentId = parentId > 0 ? (int?)parentId : null,
                    LevelType = levelType,
                    Code = null,
                    Status = status,
                    SortOrder = sortOrder,
                    CreatedAt = DateTime.UtcNow,
                    CreatedBy = (context.Session["AdminUsername"] ?? "admin").ToString(),
                    UpdatedAt = DateTime.UtcNow,
                    UpdatedBy = (context.Session["AdminUsername"] ?? "admin").ToString()
                };
                db.AdminUnits.Add(unit);
                db.SaveChanges();

                var langEntity = new AdminUnitLang
                {
                    AdminUnitId = unit.Id,
                    Lang = lang,
                    Name = name,
                    CreatedAt = DateTime.UtcNow,
                    CreatedBy = (context.Session["AdminUsername"] ?? "admin").ToString(),
                    UpdatedAt = DateTime.UtcNow,
                    UpdatedBy = (context.Session["AdminUsername"] ?? "admin").ToString()
                };
                db.AdminUnitLang.Add(langEntity);
                db.SaveChanges();
            }

            WriteOk(context);
        }

        private void UpdateAdminUnit(HttpContext context)
        {
            int id = ToInt(context.Request["id"]);
            int countryId = ToInt(context.Request["countryId"]);
            int parentId = ToInt(context.Request["parentId"]);
            var levelType = (context.Request["levelType"] ?? string.Empty).Trim();
            var name = (context.Request["name"] ?? string.Empty).Trim();
            var lang = GetLang(context);
            byte status = ToByte(context.Request["status"], 1);
            int sortOrder = ToInt(context.Request["sortOrder"], 0);

            if (id <= 0)
            {
                WriteError(context, "Không tìm thấy đơn vị");
                return;
            }

            using (var db = new TripGoHubDbContext())
            {
                var entity = db.AdminUnits.FirstOrDefault(x => x.Id == id);
                if (entity == null)
                {
                    WriteError(context, "Không tìm thấy đơn vị");
                    return;
                }

                if (countryId > 0)
                {
                    entity.CountryId = countryId;
                }

                if (!string.IsNullOrWhiteSpace(levelType))
                {
                    entity.LevelType = levelType;
                }

                if (parentId > 0)
                {
                    entity.ParentId = parentId;
                }

                if (!string.IsNullOrWhiteSpace(name))
                {
                    var langEntity = db.AdminUnitLang.FirstOrDefault(x => x.AdminUnitId == id && x.Lang == lang);
                    if (langEntity == null)
                    {
                        langEntity = new AdminUnitLang
                        {
                            AdminUnitId = id,
                            Lang = lang,
                            CreatedAt = DateTime.UtcNow,
                            CreatedBy = (context.Session["AdminUsername"] ?? "admin").ToString()
                        };
                        db.AdminUnitLang.Add(langEntity);
                    }
                    langEntity.Name = name;
                    langEntity.UpdatedAt = DateTime.UtcNow;
                    langEntity.UpdatedBy = (context.Session["AdminUsername"] ?? "admin").ToString();
                }

                entity.Status = status;
                entity.SortOrder = sortOrder;
                entity.UpdatedAt = DateTime.UtcNow;
                entity.UpdatedBy = (context.Session["AdminUsername"] ?? "admin").ToString();
                db.SaveChanges();
            }

            WriteOk(context);
        }

        private void DeleteAdminUnit(HttpContext context)
        {
            int id = ToInt(context.Request["id"]);
            using (var db = new TripGoHubDbContext())
            {
                var entity = db.AdminUnits.FirstOrDefault(x => x.Id == id);
                if (entity != null)
                {
                    db.AdminUnits.Remove(entity);
                    db.SaveChanges();
                }
            }

            WriteOk(context);
        }

        private void TranslateAdminUnit(HttpContext context)
        {
            var nameVi = (context.Request["nameVi"] ?? string.Empty).Trim();
            var result = new { ok = true, data = new { nameEn = TranslateBasic(nameVi) } };
            context.Response.ContentType = "application/json";
            context.Response.Write(Newtonsoft.Json.JsonConvert.SerializeObject(result));
        }

        private static string GetLang(HttpContext context)
        {
            var lang = (context.Request["lang"] ?? DefaultLang).Trim().ToLowerInvariant();
            if (lang != "vi" && lang != "en")
            {
                lang = DefaultLang;
            }
            return lang;
        }

        private static int ToInt(string value, int defaultValue = 0)
        {
            int result;
            return int.TryParse(value, out result) ? result : defaultValue;
        }

        private static byte ToByte(string value, byte defaultValue = 0)
        {
            byte result;
            return byte.TryParse(value, out result) ? result : defaultValue;
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

        private static string TranslateBasic(string input)
        {
            if (string.IsNullOrWhiteSpace(input)) return input;
            var value = input.Trim();

            var map = new System.Collections.Generic.Dictionary<string, string>(System.StringComparer.OrdinalIgnoreCase)
            {
                { "Thành phố", "City" },
                { "Tp.", "City" },
                { "TP.", "City" },
                { "Tp", "City" },
                { "TP", "City" },
                { "Tỉnh", "Province" },
                { "Quận", "District" },
                { "Huyện", "District" },
                { "Thị xã", "Town" },
                { "Thị trấn", "Town" },
                { "Phường", "Ward" },
                { "Xã", "Commune" }
            };

            foreach (var pair in map)
            {
                value = System.Text.RegularExpressions.Regex.Replace(
                    value,
                    "\\b" + System.Text.RegularExpressions.Regex.Escape(pair.Key) + "\\b",
                    pair.Value,
                    System.Text.RegularExpressions.RegexOptions.IgnoreCase
                );
            }

            return RemoveDiacritics(value);
        }

        private static string RemoveDiacritics(string text)
        {
            var normalized = text.Normalize(System.Text.NormalizationForm.FormD);
            var sb = new System.Text.StringBuilder();
            foreach (var ch in normalized)
            {
                var uc = System.Globalization.CharUnicodeInfo.GetUnicodeCategory(ch);
                if (uc != System.Globalization.UnicodeCategory.NonSpacingMark)
                {
                    sb.Append(ch);
                }
            }
            return sb.ToString().Normalize(System.Text.NormalizationForm.FormC);
        }
    }
}
