ï»¿<%@ WebHandler Language="C#" Class="TripGoHub.Web.Admin.Api.SystemConfig.WardsHandler" %>
using System;
using System.Linq;
using System.Web;
using System.Web.SessionState;

namespace TripGoHub.Web.Admin.Api.SystemConfig
{
    public class WardsHandler : IHttpHandler, IRequiresSessionState
    {
        private const string DefaultLang = "vi";
        private const string LevelWard = "Ward";

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
                CreateWard(context);
                return;
            }

            if (action == "get")
            {
                WriteWard(context);
                return;
            }

            if (action == "update")
            {
                UpdateWard(context);
                return;
            }

            if (action == "delete")
            {
                DeleteWard(context);
                return;
            }

            if (action == "translate")
            {
                TranslateWard(context);
                return;
            }

            WriteDataTable(context);
        }

        public bool IsReusable { get { return false; } }

        private bool IsAuthorized(HttpContext context)
        {
            return context.Session != null && context.Session["AdminUserId"] != null;
        }

                private void WriteWard(HttpContext context)
        {
            int id = ToInt(context.Request["id"]);
            using (var db = new TripGoHubDbContext())
            {
                var data = (from unit in db.AdminUnits
                            join lang in db.AdminUnitLang on unit.Id equals lang.AdminUnitId
                            where unit.Id == id && unit.LevelType == LevelWard && lang.Lang == DefaultLang
                            select new { Id = unit.Id, unit.CountryId, ParentId = unit.ParentId, Name = lang.Name, unit.Status, unit.SortOrder })
                    .FirstOrDefault();

                if (data == null)
                {
                    WriteError(context, "Kh?ng t?m th?y ph??ng/x?");
                    return;
                }

                var en = db.AdminUnitLang.FirstOrDefault(x => x.AdminUnitId == id && x.Lang == "en");

                var result = new
                {
                    data.Id,
                    data.CountryId,
                    data.ParentId,
                    NameVi = data.Name,
                    NameEn = en != null ? en.Name : string.Empty,
                    data.Status,
                    data.SortOrder
                };

                context.Response.ContentType = "application/json";
                context.Response.Write(Newtonsoft.Json.JsonConvert.SerializeObject(new { ok = true, data = result }));
            }
        }

private void WriteDataTable(HttpContext context)
        {
            int draw = ToInt(context.Request["draw"]);
            int start = ToInt(context.Request["start"]);
            int length = ToInt(context.Request["length"], 10);
            string keyword = context.Request["keyword"] ?? string.Empty;
            string statusValue = context.Request["status"] ?? string.Empty;
            int provinceId = ToInt(context.Request["provinceId"]);

            using (var db = new TripGoHubDbContext())
            {
                var query = from unit in db.AdminUnits
                            join lang in db.AdminUnitLang on unit.Id equals lang.AdminUnitId
                            where unit.LevelType == LevelWard && lang.Lang == DefaultLang
                            select new { unit, lang };

                var totalAll = query.Count();

                if (countryId > 0)
                {
                    query = query.Where(x => x.unit.CountryId == countryId);
                }

                if (provinceId > 0)
                {
                    query = query.Where(x => x.unit.ParentId == provinceId);
                }

                if (!string.IsNullOrWhiteSpace(keyword))
                {
                    query = query.Where(x => x.lang.Name.Contains(keyword));
                }

                if (!string.IsNullOrWhiteSpace(statusValue))
                {
                    byte statusFilter;
                    if (byte.TryParse(statusValue, out statusFilter))
                    {
                        query = query.Where(x => x.unit.Status == statusFilter);
                    }
                }

                var totalFiltered = query.Count();
                var data = (from item in query
                            join parent in db.AdminUnitLang on item.unit.ParentId equals parent.AdminUnitId
                            where parent.Lang == DefaultLang
                            orderby item.lang.Name
                            select new
                            {
                                Id = item.unit.Id,
                                Name = item.lang.Name,
                                ProvinceName = parent.Name,
                                item.unit.Status,
                                item.unit.SortOrder
                            })
                    .Skip(start)
                    .Take(length)
                    .ToList();

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

        private void CreateWard(HttpContext context)
        {
            var nameVi = (context.Request["nameVi"] ?? string.Empty).Trim();
            var nameEn = (context.Request["nameEn"] ?? string.Empty).Trim();
            int provinceId = ToInt(context.Request["provinceId"]);
            int countryId = ToInt(context.Request["countryId"]);
            byte status = ToByte(context.Request["status"], 1);
            int sortOrder = ToInt(context.Request["sortOrder"], 0);

            if (string.IsNullOrWhiteSpace(nameVi))
            {
                WriteError(context, "T?n ph??ng/x? (VI) l? b?t bu?c");
                return;
            }

            if (provinceId <= 0)
            {
                WriteError(context, "T?nh/Th?nh l? b?t bu?c");
                return;
            }

            using (var db = new TripGoHubDbContext())
            {
                if (countryId <= 0)
                {
                    countryId = GetCountryId(db, context);
                }

                var entity = new AdminUnit
                {
                    CountryId = countryId,
                    ParentId = provinceId,
                    LevelType = LevelWard,
                    Code = null,
                    Status = status,
                    SortOrder = sortOrder,
                    CreatedAt = DateTime.UtcNow,
                    CreatedBy = (context.Session["AdminUsername"] ?? "admin").ToString(),
                    UpdatedAt = DateTime.UtcNow,
                    UpdatedBy = (context.Session["AdminUsername"] ?? "admin").ToString()
                };
                db.AdminUnits.Add(entity);
                db.SaveChanges();

                var lang = new AdminUnitLang
                {
                    AdminUnitId = entity.Id,
                    Lang = DefaultLang,
                    Name = nameVi,
                    CreatedAt = DateTime.UtcNow,
                    CreatedBy = (context.Session["AdminUsername"] ?? "admin").ToString(),
                    UpdatedAt = DateTime.UtcNow,
                    UpdatedBy = (context.Session["AdminUsername"] ?? "admin").ToString()
                };
                db.AdminUnitLang.Add(lang);
                if (string.IsNullOrWhiteSpace(nameEn))
                {
                    nameEn = TranslateBasic(nameVi);
                }
                if (!string.IsNullOrWhiteSpace(nameEn))
                {
                    var langEn = new AdminUnitLang
                    {
                        AdminUnitId = entity.Id,
                        Lang = "en",
                        Name = nameEn,
                        CreatedAt = DateTime.UtcNow,
                        CreatedBy = (context.Session["AdminUsername"] ?? "admin").ToString(),
                        UpdatedAt = DateTime.UtcNow,
                        UpdatedBy = (context.Session["AdminUsername"] ?? "admin").ToString()
                    };
                    db.AdminUnitLang.Add(langEn);
                }
                db.SaveChanges();
            }

            WriteOk(context);
        }

                private void UpdateWard(HttpContext context)
        {
            int id = ToInt(context.Request["id"]);
            var nameVi = (context.Request["nameVi"] ?? string.Empty).Trim();
            var nameEn = (context.Request["nameEn"] ?? string.Empty).Trim();
            int provinceId = ToInt(context.Request["provinceId"]);
            int countryId = ToInt(context.Request["countryId"]);
            byte status = ToByte(context.Request["status"], 1);
            int sortOrder = ToInt(context.Request["sortOrder"], 0);

            using (var db = new TripGoHubDbContext())
            {
                var entity = db.AdminUnits.FirstOrDefault(x => x.Id == id && x.LevelType == LevelWard);
                if (entity == null)
                {
                    WriteError(context, "Kh?ng t?m th?y ph??ng/x?");
                    return;
                }

                if (provinceId > 0)
                {
                    entity.ParentId = provinceId;
                }

                if (countryId > 0)
                {
                    entity.CountryId = countryId;
                }

                if (!string.IsNullOrWhiteSpace(nameVi))
                {
                    var lang = db.AdminUnitLang.FirstOrDefault(x => x.AdminUnitId == id && x.Lang == DefaultLang);
                    if (lang == null)
                    {
                        lang = new AdminUnitLang
                        {
                            AdminUnitId = id,
                            Lang = DefaultLang,
                            CreatedAt = DateTime.UtcNow,
                            CreatedBy = (context.Session["AdminUsername"] ?? "admin").ToString()
                        };
                        db.AdminUnitLang.Add(lang);
                    }
                    lang.Name = nameVi;
                    lang.UpdatedAt = DateTime.UtcNow;
                    lang.UpdatedBy = (context.Session["AdminUsername"] ?? "admin").ToString();
                }

                if (string.IsNullOrWhiteSpace(nameEn) && !string.IsNullOrWhiteSpace(nameVi))
                {
                    nameEn = TranslateBasic(nameVi);
                }

                if (!string.IsNullOrWhiteSpace(nameEn))
                {
                    var langEn = db.AdminUnitLang.FirstOrDefault(x => x.AdminUnitId == id && x.Lang == "en");
                    if (langEn == null)
                    {
                        langEn = new AdminUnitLang
                        {
                            AdminUnitId = id,
                            Lang = "en",
                            CreatedAt = DateTime.UtcNow,
                            CreatedBy = (context.Session["AdminUsername"] ?? "admin").ToString()
                        };
                        db.AdminUnitLang.Add(langEn);
                    }
                    langEn.Name = nameEn;
                    langEn.UpdatedAt = DateTime.UtcNow;
                    langEn.UpdatedBy = (context.Session["AdminUsername"] ?? "admin").ToString();
                }

                entity.Status = status;
                entity.SortOrder = sortOrder;
                entity.UpdatedAt = DateTime.UtcNow;
                entity.UpdatedBy = (context.Session["AdminUsername"] ?? "admin").ToString();
                db.SaveChanges();
            }

            WriteOk(context);
        }

        private void TranslateWard(HttpContext context)
        {
            var nameVi = (context.Request["nameVi"] ?? string.Empty).Trim();
            var result = new { ok = true, data = new { nameEn = TranslateBasic(nameVi) } };
            context.Response.ContentType = "application/json";
            context.Response.Write(Newtonsoft.Json.JsonConvert.SerializeObject(result));
        }

private void DeleteWard(HttpContext context)
        {
            int id = ToInt(context.Request["id"]);
            using (var db = new TripGoHubDbContext())
            {
                var entity = db.AdminUnits.FirstOrDefault(x => x.Id == id && x.LevelType == LevelWard);
                if (entity != null)
                {
                    db.AdminUnits.Remove(entity);
                    db.SaveChanges();
                }
            }

            WriteOk(context);
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

                        private static string TranslateBasic(string input)
        {
            if (string.IsNullOrWhiteSpace(input)) return input;
            var value = input.Trim();

            var map = new System.Collections.Generic.Dictionary<string, string>(System.StringComparer.OrdinalIgnoreCase)
            {
                { "Th?nh ph?", "City" },
                { "Tp.", "City" },
                { "TP.", "City" },
                { "Tp", "City" },
                { "TP", "City" },
                { "T?nh", "Province" },
                { "Qu?n", "District" },
                { "Huy?n", "District" },
                { "Th? x?", "Town" },
                { "Th? tr?n", "Town" },
                { "Ph??ng", "Ward" },
                { "X?", "Commune" }
            };

            foreach (var pair in map)
            {
                value = System.Text.RegularExpressions.Regex.Replace(
                    value,
                    "" + System.Text.RegularExpressions.Regex.Escape(pair.Key) + "",
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

private static void WriteError(HttpContext context, string message)
        {
            context.Response.ContentType = "application/json";
            context.Response.Write("{\"ok\":false,\"message\":\"" + HttpUtility.JavaScriptStringEncode(message) + "\"}");
        }

        private static int GetCountryId(TripGoHubDbContext db, HttpContext context)
        {
            int countryId = ToInt(context.Request["countryId"]);
            if (countryId > 0)
            {
                return countryId;
            }

            var defaultCountry = db.Countries.FirstOrDefault(x => x.IsDefault);
            if (defaultCountry != null)
            {
                return defaultCountry.Id;
            }

            var vn = db.Countries.FirstOrDefault(x => x.Iso2 == "VN");
            return vn != null ? vn.Id : 0;
        }
    }
}
