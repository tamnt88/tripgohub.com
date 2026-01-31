<%@ Page Title="Quản trị Hãng xe" Language="C#" MasterPageFile="~/admin/Admin.master" AutoEventWireup="true" CodeFile="vehicle_brands.aspx.cs" Inherits="TripGoHub.Web.Admin.Transfer.VehicleBrands" %>
<asp:Content ID="TitleBlock" ContentPlaceHolderID="TitleContent" runat="server">Quản trị Hãng xe</asp:Content>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="d-flex align-items-center justify-content-between mb-3">
        <h1 class="h4 fw-bold mb-0">Hãng xe</h1>
        <button type="button" class="btn btn-warning" data-bs-toggle="modal" data-bs-target="#brandModal">
            <i class="fa-solid fa-plus"></i> Thêm mới
        </button>
    </div>
    <table id="tblBrands" class="table table-striped table-bordered w-100">
        <thead>
            <tr>
                <th>ID</th>
                <th>Tên</th>
                <th>Slug</th>
                <th>Status</th>
                <th>SortOrder</th>
                <th>Hành động</th>
            </tr>
        </thead>
    </table>

    <div class="modal fade" id="brandModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Thêm Hãng xe</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label">Tên</label>
                        <input type="text" class="form-control" id="BrandName" />
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Slug</label>
                        <input type="text" class="form-control" id="BrandSlug" />
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Logo URL</label>
                        <input type="text" class="form-control" id="BrandLogoUrl" />
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Logo Alt</label>
                        <input type="text" class="form-control" id="BrandLogoAlt" />
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Tóm tắt</label>
                        <textarea class="form-control" id="BrandSummary" rows="2"></textarea>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">SEO Title</label>
                        <input type="text" class="form-control" id="BrandSeoTitle" />
                    </div>
                    <div class="mb-3">
                        <label class="form-label">SEO Description</label>
                        <textarea class="form-control" id="BrandSeoDescription" rows="2"></textarea>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">SEO Keywords</label>
                        <input type="text" class="form-control" id="BrandSeoKeywords" />
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Status</label>
                        <input type="number" class="form-control" id="BrandStatus" value="1" />
                    </div>
                    <div class="mb-3">
                        <label class="form-label">SortOrder</label>
                        <input type="number" class="form-control" id="BrandSort" value="0" />
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="button" class="btn btn-warning" id="BtnSaveBrand">Lưu</button>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="Scripts" runat="server">
<script>
    $(function () {
        var table = $('#tblBrands').DataTable({
            serverSide: true,
            processing: true,
            ajax: {
                url: '../api/transfer/vehicle_brands.ashx',
                type: 'POST'
            },
            columns: [
                { data: 'BrandId' },
                { data: 'Name' },
                { data: 'Slug' },
                { data: 'Status' },
                { data: 'SortOrder' },
                {
                    data: null,
                    orderable: false,
                    render: function (data) {
                        return '<button class="btn btn-sm btn-outline-primary me-1 edit" data-id="' + data.BrandId + '"><i class="fa-regular fa-pen-to-square"></i></button>' +
                               '<button class="btn btn-sm btn-outline-danger delete" data-id="' + data.BrandId + '"><i class="fa-regular fa-trash-can"></i></button>';
                    }
                }
            ]
        });

        $('#BtnSaveBrand').on('click', function () {
            $.ajax({
                url: '../api/transfer/vehicle_brands.ashx',
                type: 'POST',
                data: {
                    action: 'create',
                    name: $('#BrandName').val(),
                    slug: $('#BrandSlug').val(),
                    logoUrl: $('#BrandLogoUrl').val(),
                    logoAlt: $('#BrandLogoAlt').val(),
                    summary: $('#BrandSummary').val(),
                    seoTitle: $('#BrandSeoTitle').val(),
                    seoDescription: $('#BrandSeoDescription').val(),
                    seoKeywords: $('#BrandSeoKeywords').val(),
                    status: $('#BrandStatus').val(),
                    sortOrder: $('#BrandSort').val()
                }
            }).done(function () {
                $('#brandModal').modal('hide');
                table.ajax.reload();
            });
        });

        $('#tblBrands').on('click', 'button.delete', function () {
            if (!confirm('Xóa mục này?')) return;
            var id = $(this).data('id');
            $.ajax({
                url: '../api/transfer/vehicle_brands.ashx',
                type: 'POST',
                data: { action: 'delete', id: id }
            }).done(function () { table.ajax.reload(); });
        });

        $('#tblBrands').on('click', 'button.edit', function () {
            var id = $(this).data('id');
            var name = prompt('Tên mới');
            if (!name) return;
            $.ajax({
                url: '../api/transfer/vehicle_brands.ashx',
                type: 'POST',
                data: { action: 'update', id: id, name: name }
            }).done(function () { table.ajax.reload(); });
        });
    });
</script>
</asp:Content>
