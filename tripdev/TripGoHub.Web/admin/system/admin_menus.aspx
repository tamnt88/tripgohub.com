<%@ Page Title="Quản trị Menu admin" Language="C#" MasterPageFile="~/admin/Admin.master" AutoEventWireup="true" CodeFile="admin_menus.aspx.cs" Inherits="TripGoHub.Web.Admin.SystemConfig.AdminMenus" %>
<asp:Content ID="ContentTitle" ContentPlaceHolderID="TitleContent" runat="server">Quản trị Menu admin</asp:Content>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h3 class="mb-0">Menu admin</h3>
        <a href="admin_menu_edit.aspx" class="btn btn-warning"><i class="fa-solid fa-plus"></i> Thêm menu</a>
    </div>

    <div class="admin-filter mb-3">
        <div class="row g-2 align-items-end">
            <div class="col-12 col-md-3">
                <label class="form-label" for="AdminMenuStatus">Trạng thái</label>
                <select class="form-select" id="AdminMenuStatus">
                    <option value="">Tất cả</option>
                    <option value="1">Đang hiển thị</option>
                    <option value="0">Đang ẩn</option>
                </select>
            </div>
            <div class="col-12 col-md-6">
                <label class="form-label" for="AdminMenuKeyword">Từ khóa</label>
                <input type="text" class="form-control" id="AdminMenuKeyword" placeholder="Nhập code hoặc tiêu đề" />
            </div>
            <div class="col-12 col-md-3 d-flex gap-2">
                <button type="button" id="BtnAdminMenuFilter" class="btn btn-primary"><i class="fa-solid fa-filter"></i> Lọc</button>
                <button type="button" id="BtnAdminMenuReset" class="btn btn-outline-secondary"><i class="fa-solid fa-rotate"></i> Làm mới</button>
            </div>
        </div>
    </div>

    <div id="adminLoading" class="admin-loading" aria-hidden="true">
        <div class="spinner-border text-primary" role="status">
            <span class="visually-hidden">Đang tải...</span>
        </div>
    </div>

    <table id="tblMenus" class="table table-striped table-bordered w-100">
        <thead>
            <tr>
                <th>ID</th>
                <th>Nhóm cha</th>
                <th>Code</th>
                <th>Tiêu đề (VI)</th>
                <th>Tiêu đề (EN)</th>
                <th>Slug (VI)</th>
                <th>Slug (EN)</th>
                <th>Group</th>
                <th>Trạng thái</th>
                <th>Thứ tự</th>
                <th>Thao tác</th>
            </tr>
        </thead>
    </table>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="Scripts" runat="server">
    <script src="../assets/js/admin_menus.js"></script>
</asp:Content>
