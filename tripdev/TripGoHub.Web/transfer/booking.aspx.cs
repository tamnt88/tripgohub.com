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
            var lang = LangHelper.GetCurrentLang(Request);

            using (var db = new TripGoHubDbContext())
            {
                var routes = db.Routes.Where(x => x.Status == 1)
                    .OrderBy(x => x.SortOrder)
                    .ThenBy(x => x.RouteId)
                    .ToList();

                var routeIds = routes.Select(x => x.RouteId).ToList();
                var i18nMap = db.RouteLang.Where(x => routeIds.Contains(x.RouteId) && x.Lang == lang)
                    .ToList()
                    .GroupBy(x => x.RouteId)
                    .ToDictionary(x => x.Key, x => x.First());

                var items = routes.Select(x =>
                {
                    var name = i18nMap.ContainsKey(x.RouteId) ? i18nMap[x.RouteId] : null;
                    return new
                    {
                        x.RouteId,
                        RouteName = (name != null ? name.FromName : x.FromName) + " - " + (name != null ? name.ToName : x.ToName)
                    };
                }).ToList();

                RouteId.DataSource = items;
                RouteId.DataTextField = "RouteName";
                RouteId.DataValueField = "RouteId";
                RouteId.DataBind();
            }
        }

        private void BindRouteJson()
        {
            var lang = LangHelper.GetCurrentLang(Request);

            using (var db = new TripGoHubDbContext())
            {
                var routes = db.Routes.Where(x => x.Status == 1)
                    .OrderBy(x => x.SortOrder)
                    .ThenBy(x => x.RouteId)
                    .ToList();

                var routeIds = routes.Select(x => x.RouteId).ToList();
                var i18nMap = db.RouteLang.Where(x => routeIds.Contains(x.RouteId) && x.Lang == lang)
                    .ToList()
                    .GroupBy(x => x.RouteId)
                    .ToDictionary(x => x.Key, x => x.First());

                var list = routes.Select(x =>
                {
                    var name = i18nMap.ContainsKey(x.RouteId) ? i18nMap[x.RouteId] : null;
                    return new RouteItem
                    {
                        RouteId = x.RouteId,
                        FromName = name != null ? name.FromName : x.FromName,
                        ToName = name != null ? name.ToName : x.ToName
                    };
                }).ToList();

                var serializer = new JavaScriptSerializer();
                RouteDataJson.Text = serializer.Serialize(list);
            }
        }

        private void BindVehicleTypes()
        {
            var lang = LangHelper.GetCurrentLang(Request);

            using (var db = new TripGoHubDbContext())
            {
                var types = db.VehicleTypes.Where(x => x.Status == 1)
                    .OrderBy(x => x.SortOrder)
                    .ThenBy(x => x.VehicleTypeId)
                    .ToList();

                var typeIds = types.Select(x => x.VehicleTypeId).ToList();
                var i18nMap = db.VehicleTypeLang.Where(x => typeIds.Contains(x.VehicleTypeId) && x.Lang == lang)
                    .ToList()
                    .GroupBy(x => x.VehicleTypeId)
                    .ToDictionary(x => x.Key, x => x.First());

                var items = types.Select(x => new
                {
                    x.VehicleTypeId,
                    Name = i18nMap.ContainsKey(x.VehicleTypeId) ? i18nMap[x.VehicleTypeId].Name : x.Name
                }).ToList();

                VehicleTypeId.DataSource = items;
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
            var lang = LangHelper.GetCurrentLang(Request);

            using (var db = new TripGoHubDbContext())
            {
                var routeId = db.RouteLang.Where(x => x.Lang == lang && x.FromName == fromName && x.ToName == toName && x.Status == 1)
                    .Select(x => x.RouteId)
                    .FirstOrDefault();

                if (routeId > 0)
                {
                    return routeId;
                }

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
                ShowError("Vui lòng nh?p h? tên và s? di?n tho?i.");
                return;
            }

            DateTime pickupTime;
            if (!DateTime.TryParse(PickupTime.Text, out pickupTime))
            {
                ShowError("Vui lòng ch?n th?i gian di h?p l?.");
                return;
            }

            bool isRoundTrip = TripRound.Checked;
            DateTime? returnTime = null;
            if (isRoundTrip)
            {
                DateTime parsedReturn;
                if (!DateTime.TryParse(ReturnTime.Text, out parsedReturn))
                {
                    ShowError("Vui lòng ch?n th?i gian v? cho chuy?n kh? h?i.");
                    return;
                }
                returnTime = parsedReturn;
            }

            int routeId = ToInt(RouteId.SelectedValue);
            int vehicleTypeId = ToInt(VehicleTypeId.SelectedValue);
            var priceInfo = GetRoutePrice(routeId, vehicleTypeId);

            if (priceInfo == null)
            {
                ShowError("Không tìm th?y giá cho tuy?n và lo?i xe dã ch?n.");
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

            ShowSuccess(string.Format("Ð?t xe thành công. Mã booking: {0}. T?ng ti?n: {1:N0} VND", bookingCode, totalAmount));
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

