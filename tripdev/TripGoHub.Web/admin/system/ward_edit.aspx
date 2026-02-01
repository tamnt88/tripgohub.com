<%@ Page Title="Thêm/Sửa Phường/Xã" Language="C#" MasterPageFile="~/admin/Admin.master" AutoEventWireup="true" CodeFile="ward_edit.aspx.cs" Inherits="TripGoHub.Web.Admin.SystemConfig.WardEdit" %>
<asp:Content ID="ContentTitle" ContentPlaceHolderID="TitleContent" runat="server">Thêm/Sửa Phường/Xã</asp:Content>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h3 class="mb-0" id="WardTitle">Thêm phường/xã</h3>
        <a href="wards.aspx" class="btn btn-outline-secondary"><i class="fa-solid fa-arrow-left"></i> Quay lại</a>
    </div>

    <div class="card">
        <div class="card-body">
            <div class="row g-3">
                <div class="col-md-4">
                    <label class="form-label" for="EditWardCountry">Quốc gia</label>
                    <select class="form-select" id="EditWardCountry"></select>
                </div>
                <div class="col-md-4">
                    <label class="form-label" for="EditWardProvince">Tỉnh/Thành</label>
                    <select class="form-select" id="EditWardProvince"></select>
                </div>
            </div>

            <ul class="nav nav-tabs mt-4 mb-3" id="wardLangTabs" role="tablist">
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
                            <label class="form-label" for="EditWardNameVi">Tên phường/xã (VI)</label>
                            <input type="text" class="form-control" id="EditWardNameVi" />
                        </div>
                    </div>
                </div>
                <div class="tab-pane fade" id="pane-en" role="tabpanel">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label" for="EditWardNameEn">Tên phường/xã (EN)</label>
                            <div class="input-group">
                                <input type="text" class="form-control" id="EditWardNameEn" />
                                <button class="btn btn-outline-secondary" type="button" id="BtnTranslateWard">Gợi ý EN</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row g-3 mt-2">
                <div class="col-md-3">
                    <label class="form-label" for="EditWardStatus">Trạng thái</label>
                    <select class="form-select" id="EditWardStatus">
                        <option value="1">Đang hiển thị</option>
                        <option value="0">Đang ẩn</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <label class="form-label" for="EditWardSort">Thứ tự</label>
                    <input type="number" class="form-control" id="EditWardSort" value="0" />
                </div>
            </div>

            <div class="mt-4 d-flex gap-2">
                <button type="button" class="btn btn-warning" id="BtnSaveWard"><i class="fa-solid fa-floppy-disk"></i> Lưu</button>
                <a href="wards.aspx" class="btn btn-outline-secondary">Hủy</a>
            </div>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="Scripts" runat="server">
    <script src="../assets/js/ward_edit.js"></script>
</asp:Content>
