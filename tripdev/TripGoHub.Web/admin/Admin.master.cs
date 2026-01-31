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

            if (path.EndsWith("/provinces.aspx"))
            {
                menuProvinces.Attributes["class"] = "menu-item is-active";
                return;
            }

            if (path.EndsWith("/wards.aspx"))
            {
                menuWards.Attributes["class"] = "menu-item is-active";
            }
        }
    }
}
