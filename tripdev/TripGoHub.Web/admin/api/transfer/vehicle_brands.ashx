<%@ WebHandler Language="C#" Class="TripGoHub.Web.Admin.Api.Transfer.VehicleBrandsHandler" %>
using System;
using System.Linq;
using System.Web;
using System.Web.SessionState;

namespace TripGoHub.Web.Admin.Api.Transfer
{
    public class VehicleBrandsHandler : IHttpHandler, IRequiresSessionState
    {
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
                CreateBrand(context);
                return;
            }

            if (action == "update")
            {
                UpdateBrand(context);
                return;
            }

            if (action == "delete")
            {
                DeleteBrand(context);
                return;
            }

            WriteDataTable(context);
        }

        public bool IsReusable { get { return false; } }

        private bool IsAuthorized(HttpContext context)
        {
            return context.Session != null && context.Session["AdminUserId"] != null;
        }

        private void WriteDataTable(HttpContext context)
        {
            int draw = ToInt(context.Request["draw"]);
            int start = ToInt(context.Request["start"]);
            int length = ToInt(context.Request["length"], 10);
            string search = context.Request["search[value]"] ?? string.Empty;

            using (var db = new TripGoHubDbContext())
            {
                var query = db.VehicleBrands.AsQueryable();
                if (!string.IsNullOrWhiteSpace(search))
                {
                    query = query.Where(x => x.Name.Contains(search) || x.Slug.Contains(search));
                }

                var total = query.Count();
                var data = query.OrderBy(x => x.SortOrder).ThenBy(x => x.Name)
                    .Skip(start)
                    .Take(length)
                    .Select(x => new { x.BrandId, x.Name, x.Slug, x.Status, x.SortOrder })
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

        private void CreateBrand(HttpContext context)
        {
            var name = (context.Request["name"] ?? string.Empty).Trim();
            var slug = (context.Request["slug"] ?? string.Empty).Trim();
            var logoUrl = (context.Request["logoUrl"] ?? string.Empty).Trim();
            var logoAlt = (context.Request["logoAlt"] ?? string.Empty).Trim();
            var summary = (context.Request["summary"] ?? string.Empty).Trim();
            var seoTitle = (context.Request["seoTitle"] ?? string.Empty).Trim();
            var seoDescription = (context.Request["seoDescription"] ?? string.Empty).Trim();
            var seoKeywords = (context.Request["seoKeywords"] ?? string.Empty).Trim();
            byte status = ToByte(context.Request["status"], 1);
            int sortOrder = ToInt(context.Request["sortOrder"], 0);

            if (string.IsNullOrWhiteSpace(name) || string.IsNullOrWhiteSpace(slug))
            {
                WriteError(context, "Name and Slug are required");
                return;
            }

            using (var db = new TripGoHubDbContext())
            {
                if (db.VehicleBrands.Any(x => x.Slug == slug))
                {
                    WriteError(context, "Slug already exists");
                    return;
                }

                var entity = new VehicleBrand
                {
                    Name = name,
                    Slug = slug,
                    LogoUrl = string.IsNullOrWhiteSpace(logoUrl) ? null : logoUrl,
                    LogoAlt = string.IsNullOrWhiteSpace(logoAlt) ? null : logoAlt,
                    Summary = string.IsNullOrWhiteSpace(summary) ? null : summary,
                    SeoTitle = string.IsNullOrWhiteSpace(seoTitle) ? null : seoTitle,
                    SeoDescription = string.IsNullOrWhiteSpace(seoDescription) ? null : seoDescription,
                    SeoKeywords = string.IsNullOrWhiteSpace(seoKeywords) ? null : seoKeywords,
                    Status = status,
                    SortOrder = sortOrder,
                    CreatedAt = DateTime.UtcNow,
                    CreatedBy = (context.Session["AdminUsername"] ?? "admin").ToString(),
                    UpdatedAt = DateTime.UtcNow,
                    UpdatedBy = (context.Session["AdminUsername"] ?? "admin").ToString()
                };

                db.VehicleBrands.Add(entity);
                db.SaveChanges();
            }

            WriteOk(context);
        }

        private void UpdateBrand(HttpContext context)
        {
            int id = ToInt(context.Request["id"]);
            var name = (context.Request["name"] ?? string.Empty).Trim();

            using (var db = new TripGoHubDbContext())
            {
                var entity = db.VehicleBrands.FirstOrDefault(x => x.BrandId == id);
                if (entity == null)
                {
                    WriteError(context, "Not found");
                    return;
                }

                if (!string.IsNullOrWhiteSpace(name))
                {
                    entity.Name = name;
                }

                entity.UpdatedAt = DateTime.UtcNow;
                entity.UpdatedBy = (context.Session["AdminUsername"] ?? "admin").ToString();
                db.SaveChanges();
            }

            WriteOk(context);
        }

        private void DeleteBrand(HttpContext context)
        {
            int id = ToInt(context.Request["id"]);
            using (var db = new TripGoHubDbContext())
            {
                var entity = db.VehicleBrands.FirstOrDefault(x => x.BrandId == id);
                if (entity != null)
                {
                    db.VehicleBrands.Remove(entity);
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

        private static void WriteError(HttpContext context, string message)
        {
            context.Response.ContentType = "application/json";
            context.Response.Write("{\"ok\":false,\"message\":\"" + HttpUtility.JavaScriptStringEncode(message) + "\"}");
        }
    }
}
