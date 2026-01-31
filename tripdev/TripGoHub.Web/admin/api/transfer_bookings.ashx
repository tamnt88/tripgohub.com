<%@ WebHandler Language="C#" Class="TripGoHub.Web.Admin.Api.TransferBookingsHandler" %>
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Web;
using System.Web.SessionState;

namespace TripGoHub.Web.Admin.Api
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

            using (var conn = new SqlConnection(GetConnectionString()))
            using (var cmd = new SqlCommand(@"
SELECT t.BookingCode,
       t.CustomerName,
       t.CustomerPhone,
       r.FromName + N' - ' + r.ToName AS RouteName,
       vt.Name AS VehicleTypeName,
       t.PickupTime,
       t.Status,
       t.PaymentStatus
FROM dbo.tgh_transfer_booking t
JOIN dbo.tgh_route r ON r.RouteId = t.RouteId
JOIN dbo.tgh_vehicle_type vt ON vt.VehicleTypeId = t.VehicleTypeId
WHERE (@Search = '' OR t.BookingCode LIKE '%' + @Search + '%' OR t.CustomerName LIKE '%' + @Search + '%')
ORDER BY t.CreatedAt DESC
OFFSET @Start ROWS FETCH NEXT @Length ROWS ONLY;
", conn))
            {
                cmd.Parameters.AddWithValue("@Search", search);
                cmd.Parameters.AddWithValue("@Start", start);
                cmd.Parameters.AddWithValue("@Length", length);

                var total = GetTotalCount(conn, search);

                var table = new DataTable();
                using (var da = new SqlDataAdapter(cmd))
                {
                    da.Fill(table);
                }

                foreach (DataRow row in table.Rows)
                {
                    row["PickupTime"] = Convert.ToDateTime(row["PickupTime"]).ToString("yyyy-MM-dd HH:mm", CultureInfo.InvariantCulture);
                    row["Status"] = MapStatus(Convert.ToInt32(row["Status"]));
                    row["PaymentStatus"] = MapPaymentStatus(Convert.ToInt32(row["PaymentStatus"]));
                }

                var result = new
                {
                    draw = draw,
                    recordsTotal = total,
                    recordsFiltered = total,
                    data = table
                };

                context.Response.ContentType = "application/json";
                context.Response.Write(Newtonsoft.Json.JsonConvert.SerializeObject(result));
            }
        }

        private int GetTotalCount(SqlConnection conn, string search)
        {
            using (var cmd = new SqlCommand(@"
SELECT COUNT(1)
FROM dbo.tgh_transfer_booking t
WHERE (@Search = '' OR t.BookingCode LIKE '%' + @Search + '%' OR t.CustomerName LIKE '%' + @Search + '%')
", conn))
            {
                cmd.Parameters.AddWithValue("@Search", search);
                if (conn.State != ConnectionState.Open)
                {
                    conn.Open();
                }
                return Convert.ToInt32(cmd.ExecuteScalar());
            }
        }

        private static int ToInt(string value, int defaultValue = 0)
        {
            int result;
            return int.TryParse(value, out result) ? result : defaultValue;
        }

        private static string MapStatus(int status)
        {
            switch (status)
            {
                case 2: return "Confirmed";
                case 3: return "Cancelled";
                case 4: return "Completed";
                default: return "Pending";
            }
        }

        private static string MapPaymentStatus(int status)
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

        private static string GetConnectionString()
        {
            return ConfigurationManager.ConnectionStrings["TripGoHubDB"].ConnectionString;
        }
    }
}
