<%@ Page Title="Quản trị Quốc gia" Language="C#" MasterPageFile="~/admin/Admin.master" AutoEventWireup="true" CodeFile="countries.aspx.cs" Inherits="TripGoHub.Web.Admin.SystemConfig.Countries" %>
<asp:Content ID="ContentTitle" ContentPlaceHolderID="TitleContent" runat="server">Quản trị Quốc gia</asp:Content>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h3 class="mb-0">Quản lý quốc gia</h3>
        <a href="country_edit.aspx" class="btn btn-warning"><i class="fa-solid fa-plus"></i> Thêm quốc gia</a>
    </div>

    <div class="admin-filter mb-3">
        <div class="row g-2 align-items-end">
            <div class="col-12 col-md-3">
                <label for="countryStatus" class="form-label">Trạng thái</label>
                <select id="countryStatus" class="form-select">
                    <option value="">Tất cả</option>
                    <option value="1">Đang hiển thị</option>
                    <option value="0">Đang ẩn</option>
                </select>
            </div>
            <div class="col-12 col-md-6">
                <label for="countryKeyword" class="form-label">Từ khóa</label>
                <input id="countryKeyword" type="text" class="form-control" placeholder="Nhập tên quốc gia hoặc mã ISO2" />
            </div>
            <div class="col-12 col-md-3 d-flex gap-2">
                <button type="button" id="btnCountryFilter" class="btn btn-primary"><i class="fa-solid fa-filter"></i> Lọc</button>
                <button type="button" id="btnCountryReset" class="btn btn-outline-secondary"><i class="fa-solid fa-rotate"></i> Làm mới</button>
            </div>
        </div>
    </div>

    <div id="adminLoading" class="admin-loading" aria-hidden="true">
        <div class="spinner-border text-primary" role="status">
            <span class="visually-hidden">Đang tải...</span>
        </div>
    </div>

    <table id="tblCountries" class="table table-striped table-bordered w-100">
        <thead>
            <tr>
                <th>Mã ISO2</th>
                <th>Tên quốc gia</th>
                <th>Trạng thái</th>
                <th>Thứ tự</th>
                <th>Thao tác</th>
            </tr>
        </thead>
    </table>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="Scripts" runat="server">
    <script src="../assets/js/countries.js"></script>
</asp:Content>
