using System;
using System.Collections.Specialized;
using System.IO;
using System.Web;

namespace TripGoHub.Web
{
    public partial class Global : HttpApplication
    {
        protected void Application_BeginRequest(object sender, EventArgs e)
        {
            TryRewritePublic();
        }

        private void TryRewritePublic()
        {
            var context = HttpContext.Current;
            if (context == null) return;

            var path = context.Request.Url.AbsolutePath;
            if (string.IsNullOrWhiteSpace(path)) return;

            var lower = path.ToLowerInvariant();
            if (lower.StartsWith("/admin") || lower.StartsWith("/content") || lower.StartsWith("/lang") ||
                lower.StartsWith("/_tmp") || lower.StartsWith("/scripts") || lower.StartsWith("/favicon"))
            {
                return;
            }

            if (lower.EndsWith(".axd")) return;

            if (lower.EndsWith(".aspx"))
            {
                if (RedirectPublicAspx(context, lower))
                {
                    return;
                }
                return;
            }

            var ext = Path.GetExtension(lower);
            if (!string.IsNullOrWhiteSpace(ext)) return;

            var trimmed = lower.TrimEnd('/');
            if (string.IsNullOrEmpty(trimmed))
            {
                RewriteTo("/Default.aspx", null);
                return;
            }

            var segments = trimmed.Split(new[] { '/' }, StringSplitOptions.RemoveEmptyEntries);
            if (segments.Length == 0)
            {
                RewriteTo("/Default.aspx", null);
                return;
            }

            var index = 0;
            string lang = null;
            if (segments[0] == "vi" || segments[0] == "en")
            {
                lang = segments[0];
                index = 1;
            }

            if (segments.Length == index)
            {
                RewriteTo("/Default.aspx", lang);
                return;
            }

            var remaining = string.Join("/", segments, index, segments.Length - index);
            if (remaining == "transfer/booking")
            {
                RewriteTo("/transfer/booking.aspx", lang);
                return;
            }

            if (remaining == "home" || remaining == "default")
            {
                RewriteTo("/Default.aspx", lang);
            }
        }

        private bool RedirectPublicAspx(HttpContext context, string path)
        {
            if (context == null) return false;
            var lang = LangHelper.GetCurrentLang(context.Request);
            var query = MergeQuery(context.Request.QueryString, null);

            if (path == "/default.aspx")
            {
                var url = LangHelper.BuildLangPath(lang, "/");
                if (!string.IsNullOrWhiteSpace(query)) url += "?" + query;
                context.Response.Redirect(url, true);
                return true;
            }

            if (path == "/transfer/booking.aspx")
            {
                var url = LangHelper.BuildLangPath(lang, "transfer/booking");
                if (!string.IsNullOrWhiteSpace(query)) url += "?" + query;
                context.Response.Redirect(url, true);
                return true;
            }

            return false;
        }

        private void RewriteTo(string targetPath, string lang)
        {
            var context = HttpContext.Current;
            if (context == null) return;

            var query = MergeQuery(context.Request.QueryString, lang);
            var newPath = string.IsNullOrWhiteSpace(query) ? targetPath : targetPath + "?" + query;
            context.RewritePath(newPath, false);
        }

        private string MergeQuery(NameValueCollection original, string lang)
        {
            var qb = HttpUtility.ParseQueryString(string.Empty);
            if (original != null)
            {
                foreach (string key in original.Keys)
                {
                    if (string.Equals(key, "lang", StringComparison.OrdinalIgnoreCase)) continue;
                    qb[key] = original[key];
                }
            }

            if (!string.IsNullOrWhiteSpace(lang))
            {
                qb["lang"] = lang;
            }

            return qb.ToString();
        }
    }
}
