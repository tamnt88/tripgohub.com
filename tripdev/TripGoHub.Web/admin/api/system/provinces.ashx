<%@ WebHandler Language="C#" Class="TripGoHub.Web.Admin.Api.SystemConfig.ProvincesHandler" %>
using System;
using System.Linq;
using System.Web;
using System.Web.SessionState;

namespace TripGoHub.Web.Admin.Api.SystemConfig
{
    public class ProvincesHandler : IHttpHandler, IRequiresSessionState
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
            if (action == "list")
            {
                WriteProvinceList(context);
                return;
            }

            if (action == "create")
            {
                CreateProvince(context);
                return;
            }

            if (action == "update")
            {
                UpdateProvince(context);
                return;
            }

            if (action == "delete")
            {
                DeleteProvince(context);
                return;
            }

            WriteDataTable(context);
        }

        public bool IsReusable { get { return false; } }

        private bool IsAuthorized(HttpContext context)
        {
            return context.Session != null && context.Session["AdminUserId"] != null;
        }

        private void WriteProvinceList(HttpContext context)
        {
            using (var db = new TripGoHubDbContext())
            {
                var list = db.Provinces.OrderBy(x => x.Name)
                    .Select(x => new { x.Id, x.Name })
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

            using (var db = new TripGoHubDbContext())
            {
                var query = db.Provinces.AsQueryable();
                if (!string.IsNullOrWhiteSpace(search))
                {
                    query = query.Where(x => x.Name.Contains(search));
                }

                var total = query.Count();
                var data = query.OrderBy(x => x.Name)
                    .Skip(start)
                    .Take(length)
                    .Select(x => new { x.Id, x.Name, x.Status, x.SortOrder })
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

        private void CreateProvince(HttpContext context)
        {
            var name = (context.Request["name"] ?? string.Empty).Trim();
            byte status = ToByte(context.Request["status"], 1);
            int sortOrder = ToInt(context.Request["sortOrder"], 0);

            if (string.IsNullOrWhiteSpace(name))
            {
                WriteError(context, "Name is required");
                return;
            }

            using (var db = new TripGoHubDbContext())
            {
                var entity = new Province
                {
                    Name = name,
                    Status = status,
                    SortOrder = sortOrder,
                    CreatedAt = DateTime.UtcNow,
                    CreatedBy = (context.Session["AdminUsername"] ?? "admin").ToString(),
                    UpdatedAt = DateTime.UtcNow,
                    UpdatedBy = (context.Session["AdminUsername"] ?? "admin").ToString()
                };
                db.Provinces.Add(entity);
                db.SaveChanges();
            }

            WriteOk(context);
        }

        private void UpdateProvince(HttpContext context)
        {
            int id = ToInt(context.Request["id"]);
            var name = (context.Request["name"] ?? string.Empty).Trim();

            using (var db = new TripGoHubDbContext())
            {
                var entity = db.Provinces.FirstOrDefault(x => x.Id == id);
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

        private void DeleteProvince(HttpContext context)
        {
            int id = ToInt(context.Request["id"]);
            using (var db = new TripGoHubDbContext())
            {
                var entity = db.Provinces.FirstOrDefault(x => x.Id == id);
                if (entity != null)
                {
                    db.Provinces.Remove(entity);
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
