<%@ Page Title="Thêm/Cập nhật Quốc gia" Language="C#" MasterPageFile="~/admin/Admin.master" AutoEventWireup="true" CodeFile="country_edit.aspx.cs" Inherits="TripGoHub.Web.Admin.SystemConfig.CountryEdit" %>
<asp:Content ID="ContentTitle" ContentPlaceHolderID="TitleContent" runat="server">Thêm/Cập nhật Quốc gia</asp:Content>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h3 class="mb-0" id="CountryTitle">Thêm quốc gia</h3>
        <a href="countries.aspx" class="btn btn-outline-secondary"><i class="fa-solid fa-arrow-left"></i> Quay lại</a>
    </div>

    <div class="card">
        <div class="card-body">
            <ul class="nav nav-tabs mb-3" id="countryLangTabs" role="tablist">
                <% for (int i = 0; i < AdminLanguages.Count; i++) { var lang = AdminLanguages[i]; var isActive = i == 0; %>
                <li class="nav-item" role="presentation">
                    <button class="nav-link <%= isActive ? "active" : "" %>" id="tab-<%= lang.LangCode %>" data-bs-toggle="tab" data-bs-target="#pane-<%= lang.LangCode %>" type="button" role="tab">
                        <img class="lang-tab-flag" src="<%: ResolveUrl(lang.FlagUrl) %>" alt="<%= lang.LangCode %>" />
                        <span><%= lang.NativeName %></span>
                    </button>
                </li>
                <% } %>
            </ul>

            <div class="tab-content">
                <div class="tab-pane fade show active" id="pane-vi" role="tabpanel">
                    <div class="row g-3">
                        <div class="col-md-4">
                            <label class="form-label" for="CountryIso2">Mã ISO2</label>
                            <input type="text" class="form-control" id="CountryIso2" maxlength="2" />
                        </div>
                        <div class="col-md-8">
                            <label class="form-label" for="CountryNameVi">Tên quốc gia (VI)</label>
                            <input type="text" class="form-control" id="CountryNameVi" />
                        </div>
                    </div>
                </div>
                <div class="tab-pane fade" id="pane-en" role="tabpanel">
                    <div class="row g-3">
                        <div class="col-md-8">
                            <label class="form-label" for="CountryNameEn">Tên quốc gia (EN)</label>
                            <div class="input-group">
                                <input type="text" class="form-control" id="CountryNameEn" />
                                <button class="btn btn-outline-secondary" type="button" id="BtnTranslateCountry">Gợi ý EN</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row g-3 mt-2">
                <div class="col-md-3">
                    <label class="form-label" for="CountryStatus">Trạng thái</label>
                    <select class="form-select" id="CountryStatus">
                        <option value="1">Đang hiển thị</option>
                        <option value="0">Đang ẩn</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <label class="form-label" for="CountrySort">Thứ tự</label>
                    <input type="number" class="form-control" id="CountrySort" value="0" />
                </div>
            </div>

            <div class="mt-4 d-flex gap-2">
                <button type="button" class="btn btn-warning" id="BtnSaveCountry"><i class="fa-solid fa-floppy-disk"></i> Lưu</button>
                <a href="countries.aspx" class="btn btn-outline-secondary">Hủy</a>
            </div>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="Scripts" runat="server">
    <script src="../assets/js/country_edit.js"></script>
</asp:Content>
