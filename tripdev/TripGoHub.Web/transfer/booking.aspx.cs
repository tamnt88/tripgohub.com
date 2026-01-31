using System;
using System.Linq;
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
            using (var db = new TripGoHubDbContext())
            {
                var routes = db.Routes.Where(x => x.Status == 1)
                    .OrderBy(x => x.SortOrder)
                    .ThenBy(x => x.RouteId)
                    .Select(x => new { x.RouteId, RouteName = x.FromName + " - " + x.ToName })
                    .ToList();

                RouteId.DataSource = routes;
                RouteId.DataTextField = "RouteName";
                RouteId.DataValueField = "RouteId";
                RouteId.DataBind();
            }
        }

        private void BindRouteJson()
        {
            using (var db = new TripGoHubDbContext())
            {
                var list = db.Routes.Where(x => x.Status == 1)
                    .OrderBy(x => x.SortOrder)
                    .ThenBy(x => x.RouteId)
                    .Select(x => new RouteItem
                    {
                        RouteId = x.RouteId,
                        FromName = x.FromName,
                        ToName = x.ToName
                    })
                    .ToList();

                var serializer = new JavaScriptSerializer();
                RouteDataJson.Text = serializer.Serialize(list);
            }
        }

        private void BindVehicleTypes()
        {
            using (var db = new TripGoHubDbContext())
            {
                var types = db.VehicleTypes.Where(x => x.Status == 1)
                    .OrderBy(x => x.SortOrder)
                    .ThenBy(x => x.VehicleTypeId)
                    .Select(x => new { x.VehicleTypeId, x.Name })
                    .ToList();

                VehicleTypeId.DataSource = types;
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
            using (var db = new TripGoHubDbContext())
            {
                return db.Routes.Where(x => x.FromName == fromName && x.ToName == toName && x.Status == 1)
                    .Select(x => x.RouteId)
                    .FirstOrDefault();
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

            using (var db = new TripGoHubDbContext())
            {
                var entity = new TransferBooking
                {
                    BookingCode = bookingCode,
                    CustomerName = customerName,
                    CustomerPhone = customerPhone,
                    CustomerEmail = email,
                    RouteId = routeId,
                    VehicleTypeId = vehicleTypeId,
                    PickupTime = pickupTime,
                    ReturnTime = returnTime,
                    TripType = tripType,
                    PaymentType = paymentType,
                    PaymentStatus = paymentStatus,
                    TotalAmount = totalAmount,
                    Note = note,
                    Status = 1,
                    SortOrder = 0,
                    CreatedAt = DateTime.UtcNow,
                    CreatedBy = "web",
                    UpdatedAt = DateTime.UtcNow,
                    UpdatedBy = "web"
                };

                db.TransferBookings.Add(entity);
                db.SaveChanges();
            }

            ShowSuccess(string.Format("Đặt xe thành công. Mã booking: {0}. Tổng tiền: {1:N0} VND", bookingCode, totalAmount));
        }

        private PriceInfo GetRoutePrice(int routeId, int vehicleTypeId)
        {
            using (var db = new TripGoHubDbContext())
            {
                var price = db.RoutePrices.FirstOrDefault(x => x.RouteId == routeId && x.VehicleTypeId == vehicleTypeId && x.Status == 1);
                if (price == null)
                {
                    return null;
                }

                return new PriceInfo
                {
                    OneWay = price.PriceOneWay,
                    RoundTrip = price.PriceRoundTrip
                };
            }
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
