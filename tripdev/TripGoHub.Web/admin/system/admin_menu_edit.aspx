<%@ Page Title="Thêm/Sửa Menu admin" Language="C#" MasterPageFile="~/admin/Admin.master" AutoEventWireup="true" CodeFile="admin_menu_edit.aspx.cs" Inherits="TripGoHub.Web.Admin.SystemConfig.AdminMenuEdit" %>
<asp:Content ID="ContentTitle" ContentPlaceHolderID="TitleContent" runat="server">Thêm/Sửa Menu admin</asp:Content>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h3 class="mb-0" id="AdminMenuTitle">Thêm menu admin</h3>
        <a href="admin_menus.aspx" class="btn btn-outline-secondary"><i class="fa-solid fa-arrow-left"></i> Quay lại</a>
    </div>

    <div class="card">
        <div class="card-body">
            <div class="row g-3">
                <div class="col-md-6">
                    <label class="form-label">Nhóm cha</label>
                    <select class="form-select" id="MenuParent">
                        <option value="">(Không có)</option>
                    </select>
                </div>
                <div class="col-md-6">
                    <label class="form-label">Code</label>
                    <input type="text" class="form-control" id="MenuCode" />
                </div>
                <div class="col-md-6">
                    <label class="form-label">Tiêu đề (VI)</label>
                    <input type="text" class="form-control" id="MenuTitleVi" />
                </div>
                <div class="col-md-6">
                    <label class="form-label">Tiêu đề (EN)</label>
                    <div class="input-group">
                        <input type="text" class="form-control" id="MenuTitleEn" />
                        <button class="btn btn-outline-secondary" type="button" id="BtnTranslateEn">Gợi ý EN</button>
                    </div>
                </div>
                <div class="col-md-6">
                    <label class="form-label">URL (VI)</label>
                    <input type="text" class="form-control" id="MenuUrlVi" placeholder="system/countries.aspx" />
                </div>
                <div class="col-md-6">
                    <label class="form-label">URL (EN)</label>
                    <input type="text" class="form-control" id="MenuUrlEn" placeholder="system/countries.aspx" />
                </div>
                <div class="col-md-6">
                    <label class="form-label">Slug (VI)</label>
                    <input type="text" class="form-control" id="MenuSlugVi" />
                </div>
                <div class="col-md-6">
                    <label class="form-label">Slug (EN)</label>
                    <input type="text" class="form-control" id="MenuSlugEn" />
                </div>
                <div class="col-md-6">
                    <label class="form-label">SEO Title (VI)</label>
                    <input type="text" class="form-control" id="MenuSeoTitleVi" />
                </div>
                <div class="col-md-6">
                    <label class="form-label">SEO Title (EN)</label>
                    <input type="text" class="form-control" id="MenuSeoTitleEn" />
                </div>
                <div class="col-md-6">
                    <label class="form-label">SEO Description (VI)</label>
                    <textarea class="form-control" id="MenuSeoDescVi" rows="2"></textarea>
                </div>
                <div class="col-md-6">
                    <label class="form-label">SEO Description (EN)</label>
                    <textarea class="form-control" id="MenuSeoDescEn" rows="2"></textarea>
                </div>
                <div class="col-md-6">
                    <label class="form-label">SEO Keywords (VI)</label>
                    <input type="text" class="form-control" id="MenuSeoKeywordsVi" />
                </div>
                <div class="col-md-6">
                    <label class="form-label">SEO Keywords (EN)</label>
                    <input type="text" class="form-control" id="MenuSeoKeywordsEn" />
                </div>
                <div class="col-md-6">
                    <label class="form-label">Icon class</label>
                    <input type="text" class="form-control" id="MenuIcon" placeholder="fa-solid fa-gear" />
                </div>
                <div class="col-md-3">
                    <label class="form-label">Group</label>
                    <select class="form-select" id="MenuIsGroup">
                        <option value="0">Link</option>
                        <option value="1">Nhóm</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <label class="form-label">Target</label>
                    <input type="text" class="form-control" id="MenuTarget" placeholder="_blank" />
                </div>
                <div class="col-md-3">
                    <label class="form-label">Trạng thái</label>
                    <select class="form-select" id="MenuStatus">
                        <option value="1">Đang hiển thị</option>
                        <option value="0">Đang ẩn</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <label class="form-label">Thứ tự</label>
                    <input type="number" class="form-control" id="MenuSort" value="0" />
                </div>
            </div>

            <div class="mt-4 d-flex gap-2">
                <button type="button" class="btn btn-warning" id="BtnSaveMenu"><i class="fa-solid fa-floppy-disk"></i> Lưu</button>
                <a href="admin_menus.aspx" class="btn btn-outline-secondary">Hủy</a>
            </div>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="Scripts" runat="server">
    <script src="../assets/js/admin_menu_edit.js"></script>
</asp:Content>
