<%@ Page Title="Qu?n tr? T?nh" Language="C#" MasterPageFile="~/admin/Admin.master" AutoEventWireup="true" CodeFile="provinces.aspx.cs" Inherits="TripGoHub.Web.Admin.SystemConfig.Provinces" %>
<asp:Content ID="TitleBlock" ContentPlaceHolderID="TitleContent" runat="server">Qu?n tr? T?nh</asp:Content>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="d-flex align-items-center justify-content-between mb-3">
        <h1 class="h4 fw-bold mb-0">T?nh/Thành</h1>
        <button type="button" class="btn btn-warning" data-bs-toggle="modal" data-bs-target="#provinceModal">
            <i class="fa-solid fa-plus"></i> Thêm m?i
        </button>
    </div>
    <table id="tblProvinces" class="table table-striped table-bordered w-100">
        <thead>
            <tr>
                <th>ID</th>
                <th>Tên</th>
                <th>Status</th>
                <th>SortOrder</th>
                <th>Hành d?ng</th>
            </tr>
        </thead>
    </table>

    <div class="modal fade" id="provinceModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Thêm T?nh/Thành</h5>
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
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">H?y</button>
                    <button type="button" class="btn btn-warning" id="BtnSaveProvince">Luu</button>
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
                url: '../api/system/provinces.ashx',
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
                url: '../api/system/provinces.ashx',
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
            if (!confirm('Xóa m?c này?')) return;
            var id = $(this).data('id');
            $.ajax({
                url: '../api/system/provinces.ashx',
                type: 'POST',
                data: { action: 'delete', id: id }
            }).done(function () { table.ajax.reload(); });
        });

        $('#tblProvinces').on('click', 'button.edit', function () {
            var id = $(this).data('id');
            var name = prompt('Tên m?i');
            if (!name) return;
            $.ajax({
                url: '../api/system/provinces.ashx',
                type: 'POST',
                data: { action: 'update', id: id, name: name }
            }).done(function () { table.ajax.reload(); });
        });
    });
</script>
</asp:Content>
