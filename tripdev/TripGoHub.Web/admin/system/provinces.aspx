<%@ Page Title="Quản trị Tỉnh/Thành" Language="C#" MasterPageFile="~/admin/Admin.master" AutoEventWireup="true" CodeFile="provinces.aspx.cs" Inherits="TripGoHub.Web.Admin.SystemConfig.Provinces" %>
<asp:Content ID="ContentTitle" ContentPlaceHolderID="TitleContent" runat="server">Quản trị Tỉnh/Thành</asp:Content>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h3 class="mb-0">Quản lý tỉnh/thành</h3>
        <a href="province_edit.aspx" class="btn btn-warning"><i class="fa-solid fa-plus"></i> Thêm tỉnh/thành</a>
    </div>

    <div class="admin-filter mb-3">
        <div class="row g-2 align-items-end">
            <div class="col-12 col-md-3">
                <label for="ProvinceCountry" class="form-label">Quốc gia</label>
                <select class="form-select" id="ProvinceCountry"></select>
            </div>
            <div class="col-12 col-md-3">
                <label for="ProvinceStatus" class="form-label">Trạng thái</label>
                <select class="form-select" id="ProvinceStatus">
                    <option value="">Tất cả</option>
                    <option value="1">Đang hiển thị</option>
                    <option value="0">Đang ẩn</option>
                </select>
            </div>
            <div class="col-12 col-md-4">
                <label for="ProvinceKeyword" class="form-label">Từ khóa</label>
                <input type="text" class="form-control" id="ProvinceKeyword" placeholder="Nhập tên tỉnh/thành" />
            </div>
            <div class="col-12 col-md-2 d-flex gap-2">
                <button type="button" id="BtnProvinceFilter" class="btn btn-primary"><i class="fa-solid fa-filter"></i> Lọc</button>
                <button type="button" id="BtnProvinceReset" class="btn btn-outline-secondary"><i class="fa-solid fa-rotate"></i> Làm mới</button>
            </div>
        </div>
    </div>

    <div id="adminLoading" class="admin-loading" aria-hidden="true">
        <div class="spinner-border text-primary" role="status">
            <span class="visually-hidden">Đang tải...</span>
        </div>
    </div>

    <table id="tblProvinces" class="table table-striped table-bordered w-100">
        <thead>
            <tr>
                <th>Tên tỉnh/thành</th>
                <th>Trạng thái</th>
                <th>Thứ tự</th>
                <th>Thao tác</th>
            </tr>
        </thead>
    </table>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="Scripts" runat="server">
    <script src="../assets/js/provinces.js"></script>
</asp:Content>
