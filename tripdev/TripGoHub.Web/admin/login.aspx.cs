using System;
using TripGoHub.Web.Security;

namespace TripGoHub.Web.Admin
{
    public partial class Login : System.Web.UI.Page
    {
        protected void BtnLogin_Click(object sender, EventArgs e)
        {
            LblError.Text = "";

            var username = TxtUsername.Text == null ? null : TxtUsername.Text.Trim();
            var password = TxtPassword.Text;

            if (string.IsNullOrWhiteSpace(username) || string.IsNullOrWhiteSpace(password))
            {
                LblError.Text = "Vui lòng nhập tài khoản và mật khẩu.";
                return;
            }

            var auth = new AdminAuthService();
            var user = auth.ValidateLogin(username, password);
            if (user == null)
            {
                LblError.Text = "Tài khoản hoặc mật khẩu không đúng.";
                return;
            }

            Session["AdminUserId"] = user.Id;
            Session["AdminUsername"] = user.Username;
            Session["AdminRole"] = user.Role;
            Response.Redirect("default.aspx");
        }
    }
}
