using System;
using System.Web.UI;

namespace TripGoHub.Web.Admin
{
    public partial class AdminMaster : MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session == null || Session["AdminUserId"] == null)
            {
                Response.Redirect("login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LblUser.Text = "Xin chào, " + (Session["AdminUsername"] ?? "admin");
                MarkActiveMenu();
            }
        }

        protected void BtnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Response.Redirect("login.aspx");
        }

        private void MarkActiveMenu()
        {
            var path = (Request.AppRelativeCurrentExecutionFilePath ?? string.Empty).ToLowerInvariant();
            if (path.EndsWith("/default.aspx"))
            {
                menuDashboard.Attributes["class"] = "menu-item is-active";
                return;
            }

            if (path.EndsWith("/transfer/transfer_bookings.aspx"))
            {
                SetTransferActive(menuTransferBookings);
                return;
            }

            if (path.EndsWith("/transfer/transfer_routes.aspx"))
            {
                SetTransferActive(menuTransferRoutes);
                return;
            }

            if (path.EndsWith("/transfer/transfer_route_prices.aspx"))
            {
                SetTransferActive(menuTransferRoutePrices);
                return;
            }

            if (path.EndsWith("/transfer/transfer_vehicles.aspx"))
            {
                SetTransferActive(menuTransferVehicles);
                return;
            }

            if (path.EndsWith("/transfer/vehicle_brands.aspx"))
            {
                SetTransferActive(menuTransferVehicleBrands);
                return;
            }

            if (path.EndsWith("/transfer/vehicle_models.aspx"))
            {
                SetTransferActive(menuTransferVehicleModels);
                return;
            }

            if (path.EndsWith("/transfer/transfer_drivers.aspx"))
            {
                SetTransferActive(menuTransferDrivers);
                return;
            }

            if (path.EndsWith("/system/provinces.aspx"))
            {
                SetSystemActive(menuProvinces);
                return;
            }

            if (path.EndsWith("/system/wards.aspx"))
            {
                SetSystemActive(menuWards);
            }
        }

        private void SetTransferActive(System.Web.UI.HtmlControls.HtmlAnchor menu)
        {
            menu.Attributes["class"] = "menu-item is-active";
            menuGroupTransfer.Attributes["class"] = "menu-group is-open";
        }

        private void SetSystemActive(System.Web.UI.HtmlControls.HtmlAnchor menu)
        {
            menu.Attributes["class"] = "menu-item is-active";
            menuGroupSystem.Attributes["class"] = "menu-group is-open";
        }
    }
}
