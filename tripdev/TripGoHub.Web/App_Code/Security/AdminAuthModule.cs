using System;
using System.Web;

namespace TripGoHub.Web.Security
{
    public class AdminAuthModule : IHttpModule
    {
        public void Init(HttpApplication context)
        {
            context.AcquireRequestState += (sender, args) =>
            {
                var app = (HttpApplication)sender;
                var path = app.Context.Request.AppRelativeCurrentExecutionFilePath ?? string.Empty;

                if (!path.StartsWith("~/admin/", StringComparison.OrdinalIgnoreCase))
                {
                    return;
                }

                if (path.EndsWith("/login.aspx", StringComparison.OrdinalIgnoreCase))
                {
                    return;
                }

                if (path.StartsWith("~/admin/assets/", StringComparison.OrdinalIgnoreCase))
                {
                    return;
                }

                var session = app.Context.Session;
                if (session == null || session["AdminUserId"] == null)
                {
                    app.Context.Response.Redirect("~/admin/login.aspx");
                }
            };
        }

        public void Dispose()
        {
        }
    }
}
