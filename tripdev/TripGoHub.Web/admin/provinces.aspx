<%@ Page Title="Quản trị Tỉnh" Language="C#" MasterPageFile="~/admin/Admin.master" AutoEventWireup="true" CodeFile="provinces.aspx.cs" Inherits="TripGoHub.Web.Admin.Provinces" %>
<asp:Content ID="TitleBlock" ContentPlaceHolderID="TitleContent" runat="server">Quản trị Tỉnh</asp:Content>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="d-flex align-items-center justify-content-between mb-3">
        <h1 class="h4 fw-bold mb-0">Tỉnh/Thành</h1>
        <button type="button" class="btn btn-warning" data-bs-toggle="modal" data-bs-target="#provinceModal">
            <i class="fa-solid fa-plus"></i> Thêm mới
        </button>
    </div>
    <table id="tblProvinces" class="table table-striped table-bordered w-100">
        <thead>
            <tr>
                <th>ID</th>
                <th>Tên</th>
                <th>Status</th>
                <th>SortOrder</th>
                <th>Hành động</th>
            </tr>
        </thead>
    </table>

    <div class="modal fade" id="provinceModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Thêm Tỉnh/Thành</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label">Tên</label>
                        <input type="text" class="form-control" id="ProvinceName" />
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Status</label>
                        <input type="number" class="form-control" id="ProvinceStatus" value="1" />
                    </div>
                    <div class="mb-3">
                        <label class="form-label">SortOrder</label>
                        <input type="number" class="form-control" id="ProvinceSort" value="0" />
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="button" class="btn btn-warning" id="BtnSaveProvince">Lưu</button>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="Scripts" runat="server">
<script>
    $(function () {
        var table = $('#tblProvinces').DataTable({
            serverSide: true,
            processing: true,
            ajax: {
                url: '../admin/api/provinces.ashx',
                type: 'POST'
            },
            columns: [
                { data: 'Id' },
                { data: 'Name' },
                { data: 'Status' },
                { data: 'SortOrder' },
                {
                    data: null,
                    orderable: false,
                    render: function (data) {
                        return '<button class="btn btn-sm btn-outline-primary me-1 edit" data-id="' + data.Id + '"><i class="fa-regular fa-pen-to-square"></i></button>' +
                               '<button class="btn btn-sm btn-outline-danger delete" data-id="' + data.Id + '"><i class="fa-regular fa-trash-can"></i></button>';
                    }
                }
            ]
        });

        $('#BtnSaveProvince').on('click', function () {
            $.ajax({
                url: '../admin/api/provinces.ashx',
                type: 'POST',
                data: {
                    action: 'create',
                    name: $('#ProvinceName').val(),
                    status: $('#ProvinceStatus').val(),
                    sortOrder: $('#ProvinceSort').val()
                }
            }).done(function () {
                $('#provinceModal').modal('hide');
                table.ajax.reload();
            });
        });

        $('#tblProvinces').on('click', 'button.delete', function () {
            if (!confirm('Xóa mục này?')) return;
            var id = $(this).data('id');
            $.ajax({
                url: '../admin/api/provinces.ashx',
                type: 'POST',
                data: { action: 'delete', id: id }
            }).done(function () { table.ajax.reload(); });
        });

        $('#tblProvinces').on('click', 'button.edit', function () {
            var id = $(this).data('id');
            var name = prompt('Tên mới');
            if (!name) return;
            $.ajax({
                url: '../admin/api/provinces.ashx',
                type: 'POST',
                data: { action: 'update', id: id, name: name }
            }).done(function () { table.ajax.reload(); });
        });
    });
</script>
</asp:Content>
