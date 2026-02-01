<%@ Page Title="Thêm/Sửa Tỉnh/Thành" Language="C#" MasterPageFile="~/admin/Admin.master" AutoEventWireup="true" CodeFile="province_edit.aspx.cs" Inherits="TripGoHub.Web.Admin.SystemConfig.ProvinceEdit" %>
<asp:Content ID="ContentTitle" ContentPlaceHolderID="TitleContent" runat="server">Thêm/Sửa Tỉnh/Thành</asp:Content>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h3 class="mb-0" id="ProvinceTitle">Thêm tỉnh/thành</h3>
        <a href="provinces.aspx" class="btn btn-outline-secondary"><i class="fa-solid fa-arrow-left"></i> Quay lại</a>
    </div>

    <div class="card">
        <div class="card-body">
            <div class="row g-3">
                <div class="col-md-6">
                    <label class="form-label" for="EditProvinceCountry">Quốc gia</label>
                    <select class="form-select" id="EditProvinceCountry"></select>
                </div>
            </div>

            <ul class="nav nav-tabs mt-4 mb-3" id="provinceLangTabs" role="tablist">
                <li class="nav-item" role="presentation">
                    <button class="nav-link active" id="tab-vi" data-bs-toggle="tab" data-bs-target="#pane-vi" type="button" role="tab">Tiếng Việt</button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link" id="tab-en" data-bs-toggle="tab" data-bs-target="#pane-en" type="button" role="tab">English</button>
                </li>
            </ul>

            <div class="tab-content">
                <div class="tab-pane fade show active" id="pane-vi" role="tabpanel">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label" for="EditProvinceNameVi">Tên tỉnh/thành (VI)</label>
                            <input type="text" class="form-control" id="EditProvinceNameVi" />
                        </div>
                    </div>
                </div>
                <div class="tab-pane fade" id="pane-en" role="tabpanel">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label" for="EditProvinceNameEn">Tên tỉnh/thành (EN)</label>
                            <div class="input-group">
                                <input type="text" class="form-control" id="EditProvinceNameEn" />
                                <button class="btn btn-outline-secondary" type="button" id="BtnTranslateProvince">Gợi ý EN</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row g-3 mt-2">
                <div class="col-md-3">
                    <label class="form-label" for="EditProvinceStatus">Trạng thái</label>
                    <select class="form-select" id="EditProvinceStatus">
                        <option value="1">Đang hiển thị</option>
                        <option value="0">Đang ẩn</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <label class="form-label" for="EditProvinceSort">Thứ tự</label>
                    <input type="number" class="form-control" id="EditProvinceSort" value="0" />
                </div>
            </div>

            <div class="mt-4 d-flex gap-2">
                <button type="button" class="btn btn-warning" id="BtnSaveProvince"><i class="fa-solid fa-floppy-disk"></i> Lưu</button>
                <a href="provinces.aspx" class="btn btn-outline-secondary">Hủy</a>
            </div>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="Scripts" runat="server">
    <script src="../assets/js/province_edit.js"></script>
</asp:Content>
