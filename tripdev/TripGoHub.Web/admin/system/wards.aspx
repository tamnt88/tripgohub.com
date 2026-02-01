<%@ Page Title="Quản trị Phường/Xã" Language="C#" MasterPageFile="~/admin/Admin.master" AutoEventWireup="true" CodeFile="wards.aspx.cs" Inherits="TripGoHub.Web.Admin.SystemConfig.Wards" %>
<asp:Content ID="ContentTitle" ContentPlaceHolderID="TitleContent" runat="server">Quản trị Phường/Xã</asp:Content>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h3 class="mb-0">Quản lý phường/xã</h3>
        <a href="ward_edit.aspx" class="btn btn-warning"><i class="fa-solid fa-plus"></i> Thêm phường/xã</a>
    </div>

    <div class="admin-filter mb-3">
        <div class="row g-2 align-items-end">
            <div class="col-12 col-md-3">
                <label class="form-label" for="WardCountry">Quốc gia</label>
                <select class="form-select" id="WardCountry"></select>
            </div>
            <div class="col-12 col-md-3">
                <label class="form-label" for="WardProvince">Tỉnh/Thành</label>
                <select class="form-select" id="WardProvince"></select>
            </div>
            <div class="col-12 col-md-2">
                <label class="form-label" for="WardStatus">Trạng thái</label>
                <select class="form-select" id="WardStatus">
                    <option value="">Tất cả</option>
                    <option value="1">Đang hiển thị</option>
                    <option value="0">Đang ẩn</option>
                </select>
            </div>
            <div class="col-12 col-md-3">
                <label class="form-label" for="WardKeyword">Từ khóa</label>
                <input type="text" class="form-control" id="WardKeyword" placeholder="Nhập tên phường/xã" />
            </div>
            <div class="col-12 col-md-2 d-flex gap-2">
                <button type="button" id="BtnWardFilter" class="btn btn-primary"><i class="fa-solid fa-filter"></i> Lọc</button>
                <button type="button" id="BtnWardReset" class="btn btn-outline-secondary"><i class="fa-solid fa-rotate"></i> Làm mới</button>
            </div>
        </div>
    </div>

    <div id="adminLoading" class="admin-loading" aria-hidden="true">
        <div class="spinner-border text-primary" role="status">
            <span class="visually-hidden">Đang tải...</span>
        </div>
    </div>

    <table id="tblWards" class="table table-striped table-bordered w-100">
        <thead>
            <tr>
                <th>Tên phường/xã</th>
                <th>Tỉnh/Thành</th>
                <th>Trạng thái</th>
                <th>Thứ tự</th>
                <th>Thao tác</th>
            </tr>
        </thead>
    </table>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="Scripts" runat="server">
    <script src="../assets/js/wards.js"></script>
</asp:Content>
