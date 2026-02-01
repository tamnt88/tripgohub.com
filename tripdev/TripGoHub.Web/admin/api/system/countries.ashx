<%@ WebHandler Language="C#" Class="TripGoHub.Web.Admin.Api.SystemConfig.CountriesHandler" %>
using System;
using System.Linq;
using System.Web;
using System.Web.SessionState;

namespace TripGoHub.Web.Admin.Api.SystemConfig
{
    public class CountriesHandler : IHttpHandler, IRequiresSessionState
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
            if (action == "list")
            {
                WriteCountryList(context);
                return;
            }

            if (action == "get")
            {
                WriteCountry(context);
                return;
            }

            if (action == "create")
            {
                CreateCountry(context);
                return;
            }

            if (action == "update")
            {
                UpdateCountry(context);
                return;
            }

            if (action == "delete")
            {
                DeleteCountry(context);
                return;
            }

            if (action == "translate")
            {
                TranslateCountry(context);
                return;
            }

            WriteDataTable(context);
        }

        public bool IsReusable { get { return false; } }

        private bool IsAuthorized(HttpContext context)
        {
            return context.Session != null && context.Session["AdminUserId"] != null;
        }

        private void WriteCountryList(HttpContext context)
        {
            using (var db = new TripGoHubDbContext())
            {
                var list = (from country in db.Countries
                            join lang in db.CountryLang on country.Id equals lang.CountryId
                            where lang.Lang == DefaultLang
                            orderby lang.Name
                            select new { Id = country.Id, Iso2 = country.Iso2, Name = lang.Name })
                    .ToList();

                context.Response.ContentType = "application/json";
                context.Response.Write(Newtonsoft.Json.JsonConvert.SerializeObject(list));
            }
        }

        private void WriteCountry(HttpContext context)
        {
            int id = ToInt(context.Request["id"]);
            using (var db = new TripGoHubDbContext())
            {
                var data = (from country in db.Countries
                            join lang in db.CountryLang on country.Id equals lang.CountryId
                            where country.Id == id && lang.Lang == DefaultLang
                            select new { Id = country.Id, country.Iso2, Name = lang.Name, country.Status, country.SortOrder })
                    .FirstOrDefault();

                if (data == null)
                {
                    WriteError(context, "Kh?ng t?m th?y qu?c gia");
                    return;
                }

                var en = db.CountryLang.FirstOrDefault(x => x.CountryId == id && x.Lang == "en");

                var result = new
                {
                    data.Id,
                    data.Iso2,
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

            using (var db = new TripGoHubDbContext())
            {
                var query = from country in db.Countries
                            join lang in db.CountryLang on country.Id equals lang.CountryId
                            where lang.Lang == DefaultLang
                            select new { country, lang };

                var totalAll = query.Count();

                if (!string.IsNullOrWhiteSpace(keyword))
                {
                    query = query.Where(x => x.lang.Name.Contains(keyword) || x.country.Iso2.Contains(keyword));
                }

                if (!string.IsNullOrWhiteSpace(statusValue))
                {
                    byte statusFilter;
                    if (byte.TryParse(statusValue, out statusFilter))
                    {
                        query = query.Where(x => x.country.Status == statusFilter);
                    }
                }

                var totalFiltered = query.Count();
                var data = query.OrderBy(x => x.lang.Name)
                    .Skip(start)
                    .Take(length)
                    .Select(x => new { Id = x.country.Id, x.country.Iso2, Name = x.lang.Name, x.country.Status, x.country.SortOrder })
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

        private void CreateCountry(HttpContext context)
        {
            var iso2 = (context.Request["iso2"] ?? string.Empty).Trim().ToUpperInvariant();
            var nameVi = (context.Request["nameVi"] ?? string.Empty).Trim();
            var nameEn = (context.Request["nameEn"] ?? string.Empty).Trim();
            byte status = ToByte(context.Request["status"], 1);
            int sortOrder = ToInt(context.Request["sortOrder"], 0);

            if (string.IsNullOrWhiteSpace(iso2) || iso2.Length != 2)
            {
                WriteError(context, "Mã ISO2 không hợp lệ");
                return;
            }

            if (string.IsNullOrWhiteSpace(nameVi))
            {
                WriteError(context, "Tên quốc gia là bắt buộc");
                return;
            }

            using (var db = new TripGoHubDbContext())
            {
                if (db.Countries.Any(x => x.Iso2 == iso2))
                {
                    WriteError(context, "Mã ISO2 đã tồn tại");
                    return;
                }

                var entity = new Country
                {
                    Iso2 = iso2,
                    Iso3 = null,
                    PhoneCode = null,
                    IsDefault = false,
                    Status = status,
                    SortOrder = sortOrder,
                    CreatedAt = DateTime.UtcNow,
                    CreatedBy = (context.Session["AdminUsername"] ?? "admin").ToString(),
                    UpdatedAt = DateTime.UtcNow,
                    UpdatedBy = (context.Session["AdminUsername"] ?? "admin").ToString()
                };
                db.Countries.Add(entity);
                db.SaveChanges();

                var lang = new CountryLang
                {
                    CountryId = entity.Id,
                    Lang = DefaultLang,
                    Name = nameVi,
                    NativeName = nameVi,
                    CreatedAt = DateTime.UtcNow,
                    CreatedBy = (context.Session["AdminUsername"] ?? "admin").ToString(),
                    UpdatedAt = DateTime.UtcNow,
                    UpdatedBy = (context.Session["AdminUsername"] ?? "admin").ToString()
                };
                db.CountryLang.Add(lang);
                if (string.IsNullOrWhiteSpace(nameEn))
                {
                    nameEn = TranslateBasic(nameVi);
                }
                if (!string.IsNullOrWhiteSpace(nameEn))
                {
                    var langEn = new CountryLang
                    {
                        CountryId = entity.Id,
                        Lang = "en",
                        Name = nameEn,
                        NativeName = nameEn,
                        CreatedAt = DateTime.UtcNow,
                        CreatedBy = (context.Session["AdminUsername"] ?? "admin").ToString(),
                        UpdatedAt = DateTime.UtcNow,
                        UpdatedBy = (context.Session["AdminUsername"] ?? "admin").ToString()
                    };
                    db.CountryLang.Add(langEn);
                }
                db.SaveChanges();
            }

            WriteOk(context);
        }

        private void UpdateCountry(HttpContext context)
        {
            int id = ToInt(context.Request["id"]);
            var iso2 = (context.Request["iso2"] ?? string.Empty).Trim().ToUpperInvariant();
            var nameVi = (context.Request["nameVi"] ?? string.Empty).Trim();
            var nameEn = (context.Request["nameEn"] ?? string.Empty).Trim();
            byte status = ToByte(context.Request["status"], 1);
            int sortOrder = ToInt(context.Request["sortOrder"], 0);

            if (id <= 0)
            {
                WriteError(context, "Kh?ng t?m th?y qu?c gia");
                return;
            }

            using (var db = new TripGoHubDbContext())
            {
                var entity = db.Countries.FirstOrDefault(x => x.Id == id);
                if (entity == null)
                {
                    WriteError(context, "Kh?ng t?m th?y qu?c gia");
                    return;
                }

                if (!string.IsNullOrWhiteSpace(iso2) && iso2.Length == 2 && entity.Iso2 != iso2)
                {
                    if (db.Countries.Any(x => x.Iso2 == iso2 && x.Id != id))
                    {
                        WriteError(context, "M? ISO2 ?? t?n t?i");
                        return;
                    }
                    entity.Iso2 = iso2;
                }

                if (!string.IsNullOrWhiteSpace(nameVi))
                {
                    var lang = db.CountryLang.FirstOrDefault(x => x.CountryId == id && x.Lang == DefaultLang);
                    if (lang == null)
                    {
                        lang = new CountryLang
                        {
                            CountryId = id,
                            Lang = DefaultLang,
                            CreatedAt = DateTime.UtcNow,
                            CreatedBy = (context.Session["AdminUsername"] ?? "admin").ToString()
                        };
                        db.CountryLang.Add(lang);
                    }
                    lang.Name = nameVi;
                    lang.NativeName = nameVi;
                    lang.UpdatedAt = DateTime.UtcNow;
                    lang.UpdatedBy = (context.Session["AdminUsername"] ?? "admin").ToString();
                }

                if (string.IsNullOrWhiteSpace(nameEn) && !string.IsNullOrWhiteSpace(nameVi))
                {
                    nameEn = TranslateBasic(nameVi);
                }

                if (!string.IsNullOrWhiteSpace(nameEn))
                {
                    var langEn = db.CountryLang.FirstOrDefault(x => x.CountryId == id && x.Lang == "en");
                    if (langEn == null)
                    {
                        langEn = new CountryLang
                        {
                            CountryId = id,
                            Lang = "en",
                            CreatedAt = DateTime.UtcNow,
                            CreatedBy = (context.Session["AdminUsername"] ?? "admin").ToString()
                        };
                        db.CountryLang.Add(langEn);
                    }
                    langEn.Name = nameEn;
                    langEn.NativeName = nameEn;
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

                private void TranslateCountry(HttpContext context)
        {
            var nameVi = (context.Request["nameVi"] ?? string.Empty).Trim();
            var result = new { ok = true, data = new { nameEn = TranslateBasic(nameVi) } };
            context.Response.ContentType = "application/json";
            context.Response.Write(Newtonsoft.Json.JsonConvert.SerializeObject(result));
        }

private void DeleteCountry(HttpContext context)
        {
            int id = ToInt(context.Request["id"]);
            using (var db = new TripGoHubDbContext())
            {
                var entity = db.Countries.FirstOrDefault(x => x.Id == id);
                if (entity != null)
                {
                    db.Countries.Remove(entity);
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
            context.Response.Write(Newtonsoft.Json.JsonConvert.SerializeObject(new { ok = false, message = message }));
        }
    }
}
