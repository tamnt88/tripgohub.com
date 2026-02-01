<%@ Page Language="C#" AutoEventWireup="true" CodeFile="login.aspx.cs" Inherits="TripGoHub.Web.Admin.Login" %>
<!DOCTYPE html>
<html lang="vi">
<head runat="server">
    <meta charset="utf-8" />
    <title>Admin Login - TripGoHub</title>
    <link rel="icon" type="image/png" href="<%: ResolveUrl("~/fav.png") %>" />
    <link rel="stylesheet" href="<%: ResolveUrl("~/admin/assets/vendor/bootstrap/css/bootstrap.min.css") %>" />
    <link rel="stylesheet" href="<%: ResolveUrl("~/admin/assets/vendor/fontawesome/css/all.min.css") %>" />
    <link rel="stylesheet" href="<%: ResolveUrl("~/admin/assets/css/admin.css") %>" />
</head>
<body class="bg-light">
    <form id="form1" runat="server">
        <main class="admin-login">
            <div class="login-card">
                <div class="login-brand">
                    <img src="<%: ResolveUrl("~/logo.png") %>" alt="TripGoHub" class="brand-logo" />
                </div>
                <h1 class="h4 fw-bold mb-3">Đăng nhập quản trị</h1>
                <asp:Label runat="server" ID="LblError" CssClass="error" />
                <div class="mb-3">
                    <label class="form-label">Tài khoản</label>
                    <asp:TextBox runat="server" ID="TxtUsername" CssClass="form-control" />
                </div>
                <div class="mb-3">
                    <label class="form-label">Mật khẩu</label>
                    <asp:TextBox runat="server" ID="TxtPassword" TextMode="Password" CssClass="form-control" />
                </div>
                <asp:Button runat="server" ID="BtnLogin" Text="Đăng nhập" CssClass="btn btn-warning w-100 fw-semibold" OnClick="BtnLogin_Click" />
            </div>
        </main>
    </form>
    <script src="<%: ResolveUrl("~/admin/assets/vendor/jquery/jquery.min.js") %>"></script>
    <script src="<%: ResolveUrl("~/admin/assets/vendor/bootstrap/js/bootstrap.bundle.min.js") %>"></script>
</body>
</html>
