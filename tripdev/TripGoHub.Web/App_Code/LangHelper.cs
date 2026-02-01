using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace TripGoHub.Web
{
    public static class LangHelper
    {
        public const string FallbackLang = "vi";

        public static string NormalizeLang(string lang)
        {
            if (string.IsNullOrWhiteSpace(lang)) return GetDefaultLang();
            lang = lang.Trim().ToLowerInvariant();
            return IsSupported(lang) ? lang : GetDefaultLang();
        }

        public static bool IsSupported(string lang)
        {
            if (string.IsNullOrWhiteSpace(lang)) return false;
            lang = lang.Trim().ToLowerInvariant();
            var supported = GetSupportedLangs();
            return supported.Contains(lang);
        }

        public static List<string> GetSupportedLangs()
        {
            return GetSupportedLanguages().Select(x => x.LangCode).ToList();
        }

        public static List<Language> GetSupportedLanguages()
        {
            try
            {
                using (var db = new TripGoHubDbContext())
                {
                    return db.Languages.Where(x => x.Status == 1)
                        .OrderByDescending(x => x.IsDefault)
                        .ThenBy(x => x.SortOrder)
                        .ThenBy(x => x.LangCode)
                        .ToList();
                }
            }
            catch
            {
                return new List<Language>
                {
                    new Language { LangCode = "vi", Name = "Vietnamese", NativeName = "Ti?ng Vi?t", FlagUrl = "/lang/vietnam.png", Status = 1, SortOrder = 0, IsDefault = true },
                    new Language { LangCode = "en", Name = "English", NativeName = "English", FlagUrl = "/lang/english.png", Status = 1, SortOrder = 10, IsDefault = false }
                };
            }
        }

        public static string GetDefaultLang()
        {
            try
            {
                var langs = GetSupportedLanguages();
                var def = langs.FirstOrDefault(x => x.IsDefault);
                if (def != null) return def.LangCode;
                if (langs.Count > 0) return langs[0].LangCode;
            }
            catch
            {
            }
            return FallbackLang;
        }

        public static string GetCurrentLang(HttpRequest request)
        {
            if (request == null) return GetDefaultLang();

            var qs = request.QueryString["lang"];
            if (!string.IsNullOrWhiteSpace(qs))
            {
                return NormalizeLang(qs);
            }

            var cookie = request.Cookies["tgh_lang"];
            if (cookie != null && !string.IsNullOrWhiteSpace(cookie.Value))
            {
                return NormalizeLang(cookie.Value);
            }

            return GetDefaultLang();
        }

        public static void SaveLangCookie(HttpResponse response, string lang)
        {
            if (response == null) return;
            var cookie = new HttpCookie("tgh_lang", NormalizeLang(lang))
            {
                Expires = DateTime.UtcNow.AddYears(1),
                HttpOnly = false
            };
            response.Cookies.Set(cookie);
        }

        public static string BuildLangUrl(HttpRequest request, string lang)
        {
            if (request == null) return "/" + NormalizeLang(lang);

            var cleanPath = StripLangPrefix(request.Url.AbsolutePath);
            if (string.IsNullOrWhiteSpace(cleanPath) || cleanPath == "/default.aspx")
            {
                cleanPath = "/";
            }

            if (cleanPath.EndsWith(".aspx", StringComparison.OrdinalIgnoreCase))
            {
                cleanPath = cleanPath.Substring(0, cleanPath.Length - 5);
            }

            var query = BuildQueryWithoutLang(request.QueryString);
            var prefix = "/" + NormalizeLang(lang);
            var url = cleanPath == "/" ? prefix : prefix + cleanPath;
            return string.IsNullOrWhiteSpace(query) ? url : url + "?" + query;
        }

        public static string BuildLangPath(string lang, string path)
        {
            var prefix = "/" + NormalizeLang(lang);
            if (string.IsNullOrWhiteSpace(path) || path == "/") return prefix;
            return path.StartsWith("/") ? prefix + path : prefix + "/" + path;
        }

        private static string BuildQueryWithoutLang(System.Collections.Specialized.NameValueCollection query)
        {
            if (query == null || query.Count == 0) return string.Empty;
            var parts = HttpUtility.ParseQueryString(string.Empty);
            foreach (string key in query.Keys)
            {
                if (string.Equals(key, "lang", StringComparison.OrdinalIgnoreCase)) continue;
                parts[key] = query[key];
            }
            return parts.ToString();
        }

        public static string StripLangPrefix(string path)
        {
            if (string.IsNullOrWhiteSpace(path)) return "/";
            var lower = path.ToLowerInvariant();
            var supported = GetSupportedLangs();
            foreach (var lang in supported)
            {
                var prefix = "/" + lang + "/";
                if (lower.StartsWith(prefix)) return path.Substring(prefix.Length - 1);
                if (lower == "/" + lang) return "/";
            }
            return path;
        }
    }
}
