using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.Script.Serialization;

namespace TripGoHub.Web.Transfer
{
    public partial class Booking : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindRoutes();
                BindVehicleTypes();
                ApplyQueryDefaults();
            }
            BindRouteJson();
        }

        private void BindRoutes()
        {
            using (var conn = new SqlConnection(GetConnectionString()))
            using (var cmd = new SqlCommand("SELECT RouteId, FromName, ToName, (FromName + N' - ' + ToName) AS RouteName FROM dbo.tgh_route WHERE Status = 1 ORDER BY SortOrder, RouteId", conn))
            using (var da = new SqlDataAdapter(cmd))
            {
                var dt = new DataTable();
                da.Fill(dt);
                RouteId.DataSource = dt;
                RouteId.DataTextField = "RouteName";
                RouteId.DataValueField = "RouteId";
                RouteId.DataBind();
            }
        }

        private void BindRouteJson()
        {
            var list = new System.Collections.Generic.List<RouteItem>();
            using (var conn = new SqlConnection(GetConnectionString()))
            using (var cmd = new SqlCommand("SELECT RouteId, FromName, ToName FROM dbo.tgh_route WHERE Status = 1 ORDER BY SortOrder, RouteId", conn))
            {
                conn.Open();
                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        list.Add(new RouteItem
                        {
                            RouteId = reader.GetInt32(0),
                            FromName = reader.GetString(1),
                            ToName = reader.GetString(2)
                        });
                    }
                }
            }

            var serializer = new JavaScriptSerializer();
            RouteDataJson.Text = serializer.Serialize(list);
        }

        private void BindVehicleTypes()
        {
            using (var conn = new SqlConnection(GetConnectionString()))
            using (var cmd = new SqlCommand("SELECT VehicleTypeId, Name FROM dbo.tgh_vehicle_type WHERE Status = 1 ORDER BY SortOrder, VehicleTypeId", conn))
            using (var da = new SqlDataAdapter(cmd))
            {
                var dt = new DataTable();
                da.Fill(dt);
                VehicleTypeId.DataSource = dt;
                VehicleTypeId.DataTextField = "Name";
                VehicleTypeId.DataValueField = "VehicleTypeId";
                VehicleTypeId.DataBind();
            }
        }

        private void ApplyQueryDefaults()
        {
            var pickup = (Request.QueryString["pickup"] ?? string.Empty).Trim();
            var dropoff = (Request.QueryString["dropoff"] ?? string.Empty).Trim();
            var trip = (Request.QueryString["trip"] ?? string.Empty).Trim().ToLowerInvariant();
            var vehicle = (Request.QueryString["vehicle"] ?? string.Empty).Trim();

            if (!string.IsNullOrWhiteSpace(pickup))
            {
                PickupPoint.Text = pickup;
            }

            if (!string.IsNullOrWhiteSpace(dropoff))
            {
                DropoffPoint.Text = dropoff;
            }

            if (trip == "round")
            {
                TripRound.Checked = true;
                TripOneWay.Checked = false;
            }

            if (!string.IsNullOrWhiteSpace(vehicle))
            {
                var item = VehicleTypeId.Items.FindByText(vehicle);
                if (item != null)
                {
                    VehicleTypeId.ClearSelection();
                    item.Selected = true;
                }
            }

            if (!string.IsNullOrWhiteSpace(pickup) && !string.IsNullOrWhiteSpace(dropoff))
            {
                var routeId = FindRouteIdByName(pickup, dropoff);
                if (routeId > 0)
                {
                    var item = RouteId.Items.FindByValue(routeId.ToString());
                    if (item != null)
                    {
                        RouteId.ClearSelection();
                        item.Selected = true;
                    }
                }
            }
        }

        private int FindRouteIdByName(string fromName, string toName)
        {
            using (var conn = new SqlConnection(GetConnectionString()))
            using (var cmd = new SqlCommand("SELECT RouteId FROM dbo.tgh_route WHERE FromName = @FromName AND ToName = @ToName AND Status = 1", conn))
            {
                cmd.Parameters.AddWithValue("@FromName", fromName);
                cmd.Parameters.AddWithValue("@ToName", toName);
                conn.Open();
                var result = cmd.ExecuteScalar();
                return result == null ? 0 : Convert.ToInt32(result);
            }
        }

        protected void BtnSubmit_Click(object sender, EventArgs e)
        {
            MessagePanel.Visible = false;

            var customerName = (CustomerName.Text ?? string.Empty).Trim();
            var customerPhone = (CustomerPhone.Text ?? string.Empty).Trim();

            if (string.IsNullOrWhiteSpace(customerName) || string.IsNullOrWhiteSpace(customerPhone))
            {
                ShowError("Vui lòng nhập họ tên và số điện thoại.");
                return;
            }

            DateTime pickupTime;
            if (!DateTime.TryParse(PickupTime.Text, out pickupTime))
            {
                ShowError("Vui lòng chọn thời gian đi hợp lệ.");
                return;
            }

            bool isRoundTrip = TripRound.Checked;
            DateTime? returnTime = null;
            if (isRoundTrip)
            {
                DateTime parsedReturn;
                if (!DateTime.TryParse(ReturnTime.Text, out parsedReturn))
                {
                    ShowError("Vui lòng chọn thời gian về cho chuyến khứ hồi.");
                    return;
                }
                returnTime = parsedReturn;
            }

            int routeId = ToInt(RouteId.SelectedValue);
            int vehicleTypeId = ToInt(VehicleTypeId.SelectedValue);
            var priceInfo = GetRoutePrice(routeId, vehicleTypeId);

            if (priceInfo == null)
            {
                ShowError("Không tìm thấy giá cho tuyến và loại xe đã chọn.");
                return;
            }

            decimal totalAmount = isRoundTrip ? priceInfo.RoundTrip : priceInfo.OneWay;
            byte tripType = (byte)(isRoundTrip ? 2 : 1);
            byte paymentType = (byte)(PayOnline.Checked ? 1 : 2);
            byte paymentStatus = 0;

            var bookingCode = "TG" + DateTime.Now.ToString("yyyyMMddHHmmss") + new Random().Next(100, 999).ToString();

            var email = string.IsNullOrWhiteSpace(CustomerEmail.Text) ? null : CustomerEmail.Text.Trim();
            var note = string.IsNullOrWhiteSpace(Note.Text) ? null : Note.Text.Trim();

            using (var conn = new SqlConnection(GetConnectionString()))
            using (var cmd = new SqlCommand(@"
INSERT INTO dbo.tgh_transfer_booking
(BookingCode, CustomerName, CustomerPhone, CustomerEmail, RouteId, VehicleTypeId, PickupTime, ReturnTime, TripType, PaymentType, PaymentStatus, TotalAmount, Note, Status, SortOrder, CreatedAt, CreatedBy, UpdatedAt, UpdatedBy)
VALUES
(@BookingCode, @CustomerName, @CustomerPhone, @CustomerEmail, @RouteId, @VehicleTypeId, @PickupTime, @ReturnTime, @TripType, @PaymentType, @PaymentStatus, @TotalAmount, @Note, 1, 0, SYSUTCDATETIME(), @CreatedBy, SYSUTCDATETIME(), @UpdatedBy)
", conn))
            {
                cmd.Parameters.AddWithValue("@BookingCode", bookingCode);
                cmd.Parameters.AddWithValue("@CustomerName", customerName);
                cmd.Parameters.AddWithValue("@CustomerPhone", customerPhone);
                cmd.Parameters.AddWithValue("@CustomerEmail", (object)email ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@RouteId", routeId);
                cmd.Parameters.AddWithValue("@VehicleTypeId", vehicleTypeId);
                cmd.Parameters.AddWithValue("@PickupTime", pickupTime);
                cmd.Parameters.AddWithValue("@ReturnTime", (object)returnTime ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@TripType", tripType);
                cmd.Parameters.AddWithValue("@PaymentType", paymentType);
                cmd.Parameters.AddWithValue("@PaymentStatus", paymentStatus);
                cmd.Parameters.AddWithValue("@TotalAmount", totalAmount);
                cmd.Parameters.AddWithValue("@Note", (object)note ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@CreatedBy", "web");
                cmd.Parameters.AddWithValue("@UpdatedBy", "web");

                conn.Open();
                cmd.ExecuteNonQuery();
            }

            ShowSuccess(string.Format("Đặt xe thành công. Mã booking: {0}. Tổng tiền: {1:N0} VND", bookingCode, totalAmount));
        }

        private PriceInfo GetRoutePrice(int routeId, int vehicleTypeId)
        {
            using (var conn = new SqlConnection(GetConnectionString()))
            using (var cmd = new SqlCommand(@"
SELECT PriceOneWay, PriceRoundTrip
FROM dbo.tgh_route_price
WHERE RouteId = @RouteId AND VehicleTypeId = @VehicleTypeId AND Status = 1
", conn))
            {
                cmd.Parameters.AddWithValue("@RouteId", routeId);
                cmd.Parameters.AddWithValue("@VehicleTypeId", vehicleTypeId);

                conn.Open();
                using (var reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        return new PriceInfo
                        {
                            OneWay = reader.GetDecimal(0),
                            RoundTrip = reader.GetDecimal(1)
                        };
                    }
                }
            }

            return null;
        }

        private static int ToInt(string value)
        {
            int result;
            return int.TryParse(value, out result) ? result : 0;
        }

        private void ShowError(string message)
        {
            MessagePanel.Visible = true;
            MessagePanel.CssClass = "msg error";
            MessageText.Text = message;
        }

        private void ShowSuccess(string message)
        {
            MessagePanel.Visible = true;
            MessagePanel.CssClass = "msg success";
            MessageText.Text = message;
        }

        private static string GetConnectionString()
        {
            return ConfigurationManager.ConnectionStrings["TripGoHubDB"].ConnectionString;
        }

        private class PriceInfo
        {
            public decimal OneWay { get; set; }
            public decimal RoundTrip { get; set; }
        }

        private class RouteItem
        {
            public int RouteId { get; set; }
            public string FromName { get; set; }
            public string ToName { get; set; }
        }
    }
}
