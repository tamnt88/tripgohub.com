<%@ Page Title="Quản trị Đơn vị hành chính" Language="C#" MasterPageFile="~/admin/Admin.master" AutoEventWireup="true" CodeFile="admin_units.aspx.cs" Inherits="TripGoHub.Web.Admin.SystemConfig.AdminUnits" %>
<asp:Content ID="ContentTitle" ContentPlaceHolderID="TitleContent" runat="server">Quản trị Đơn vị hành chính</asp:Content>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <link rel="stylesheet" href="../assets/vendor/jstree/style.min.css" />

    <div class="d-flex justify-content-between align-items-center mb-3">
        <h3 class="mb-0">Quản lý đơn vị hành chính</h3>
    </div>

    <div class="row">
        <div class="col-lg-4">
            <div class="card mb-3">
                <div class="card-header">Bộ lọc</div>
                <div class="card-body">
                    <div class="mb-3">
                        <label class="form-label" for="TreeCountry">Quốc gia</label>
                        <select class="form-control" id="TreeCountry"></select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label" for="AdminUnitLang">Ngôn ngữ</label>
                        <select class="form-control" id="AdminUnitLang">
                            <option value="vi">Tiếng Việt</option>
                            <option value="en">English</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label" for="TreeSearch">Tìm kiếm</label>
                        <input type="text" class="form-control" id="TreeSearch" placeholder="Nhập tên..." />
                    </div>
                </div>
            </div>

            <div class="card">
                <div class="card-header">Thêm / Cập nhật</div>
                <div class="card-body">
                    <div class="mb-3">
                        <label class="form-label" for="SelectedParent">Đơn vị cha (tạo mới)</label>
                        <input type="text" class="form-control" id="SelectedParent" readonly />
                        <small class="text-muted d-block mt-1">Chọn 1 node để tạo đơn vị con bên dưới.</small>
                    </div>
                    <div class="mb-3">
                        <label class="form-label" for="AdminUnitLevel">Cấp</label>
                        <select class="form-control" id="AdminUnitLevel">
                            <option value="Province">Tỉnh/Thành</option>
                            <option value="State">State</option>
                            <option value="City">City</option>
                            <option value="District">Quận/Huyện</option>
                            <option value="Ward">Phường/Xã</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label" for="AdminUnitName">Tên</label>
                        <div class="input-group">
                            <input type="text" class="form-control" id="AdminUnitName" />
                            <button class="btn btn-outline-secondary" type="button" id="BtnTranslateAdminUnit">Gợi ý EN</button>
                        </div>
                        <small class="text-muted d-block mt-1">Gợi ý EN chỉ hiện khi chọn ngôn ngữ English.</small>
                    </div>
                    <div class="mb-3">
                        <label class="form-label" for="AdminUnitStatus">Trạng thái</label>
                        <select class="form-control" id="AdminUnitStatus">
                            <option value="1">Đang hiển thị</option>
                            <option value="0">Đang ẩn</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label" for="AdminUnitSort">Thứ tự</label>
                        <input type="number" class="form-control" id="AdminUnitSort" value="0" />
                    </div>
                    <div class="d-flex gap-2">
                        <button type="button" class="btn btn-warning" id="BtnSaveAdminUnit"><i class="fa-solid fa-floppy-disk"></i> Lưu</button>
                        <button type="button" class="btn btn-outline-primary" id="BtnUpdateAdminUnit"><i class="fa-solid fa-pen"></i> Cập nhật</button>
                        <button type="button" class="btn btn-danger" id="BtnDeleteAdminUnit"><i class="fa-solid fa-trash"></i> Xóa</button>
                    </div>
                    <small class="text-muted d-block mt-2">Lưu: tạo mới đơn vị con dưới node đang chọn. Cập nhật: sửa node đang chọn.</small>
                </div>
            </div>
        </div>

        <div class="col-lg-8">
            <div class="card">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <span>Cây đơn vị hành chính</span>
                    <span class="badge bg-light text-dark" id="TreeLangLabel">VI</span>
                </div>
                <div class="card-body">
                    <div id="adminUnitTree"></div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="Scripts" runat="server">
    <script src="../assets/vendor/jstree/jstree.min.js"></script>
    <script src="../assets/js/admin_units.js"></script>
</asp:Content>
