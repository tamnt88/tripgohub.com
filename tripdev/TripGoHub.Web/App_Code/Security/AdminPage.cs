using System;
using System.Web.UI;

namespace TripGoHub.Web.Security
{
    public class AdminPage : Page
    {
        protected override void OnInit(EventArgs e)
        {
            base.OnInit(e);

            if (Session == null || Session["AdminUserId"] == null)
            {
                Response.Redirect("~/admin/login.aspx");
            }
        }
    }
}
