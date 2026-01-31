<%@ WebHandler Language="C#" Class="TripGoHub.Web.Admin.Api.Transfer.TransferBookingsHandler" %>
using System;
using System.Linq;
using System.Web;
using System.Web.SessionState;

namespace TripGoHub.Web.Admin.Api.Transfer
{
    public class TransferBookingsHandler : IHttpHandler, IRequiresSessionState
    {
        public void ProcessRequest(HttpContext context)
        {
            if (!IsAuthorized(context))
            {
                context.Response.StatusCode = 401;
                WriteError(context, "Unauthorized");
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
                var query = db.TransferBookings.AsQueryable();
                if (!string.IsNullOrWhiteSpace(search))
                {
                    query = query.Where(x => x.BookingCode.Contains(search) || x.CustomerName.Contains(search));
                }

                var total = query.Count();
                var data = query.OrderByDescending(x => x.CreatedAt)
                    .Skip(start)
                    .Take(length)
                    .Select(x => new
                    {
                        x.BookingCode,
                        x.CustomerName,
                        x.CustomerPhone,
                        RouteName = x.Route.FromName + " - " + x.Route.ToName,
                        VehicleTypeName = x.VehicleType.Name,
                        PickupTime = x.PickupTime,
                        x.Status,
                        x.PaymentStatus
                    })
                    .ToList()
                    .Select(x => new
                    {
                        x.BookingCode,
                        x.CustomerName,
                        x.CustomerPhone,
                        x.RouteName,
                        x.VehicleTypeName,
                        PickupTime = x.PickupTime.ToString("yyyy-MM-dd HH:mm"),
                        Status = MapStatus(x.Status),
                        PaymentStatus = MapPaymentStatus(x.PaymentStatus)
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

        private static int ToInt(string value, int defaultValue = 0)
        {
            int result;
            return int.TryParse(value, out result) ? result : defaultValue;
        }

        private static string MapStatus(byte status)
        {
            switch (status)
            {
                case 2: return "Confirmed";
                case 3: return "Cancelled";
                case 4: return "Completed";
                default: return "Pending";
            }
        }

        private static string MapPaymentStatus(byte status)
        {
            switch (status)
            {
                case 1: return "Paid";
                case 2: return "Refunded";
                default: return "Unpaid";
            }
        }

        private static void WriteError(HttpContext context, string message)
        {
            context.Response.ContentType = "application/json";
            context.Response.Write("{\"ok\":false,\"message\":\"" + HttpUtility.JavaScriptStringEncode(message) + "\"}");
        }
    }
}
