<%@ Page Title="Qu?n tr? Phu?ng" Language="C#" MasterPageFile="~/admin/Admin.master" AutoEventWireup="true" CodeFile="wards.aspx.cs" Inherits="TripGoHub.Web.Admin.SystemConfig.Wards" %>
<asp:Content ID="TitleBlock" ContentPlaceHolderID="TitleContent" runat="server">Qu?n tr? Phu?ng</asp:Content>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="d-flex align-items-center justify-content-between mb-3">
        <h1 class="h4 fw-bold mb-0">Phu?ng/Xã</h1>
        <button type="button" class="btn btn-warning" data-bs-toggle="modal" data-bs-target="#wardModal">
            <i class="fa-solid fa-plus"></i> Thêm m?i
        </button>
    </div>
    <table id="tblWards" class="table table-striped table-bordered w-100">
        <thead>
            <tr>
                <th>ID</th>
                <th>Tên</th>
                <th>T?nh</th>
                <th>Status</th>
                <th>SortOrder</th>
                <th>Hành d?ng</th>
            </tr>
        </thead>
    </table>

    <div class="modal fade" id="wardModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Thêm Phu?ng/Xã</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label">T?nh</label>
                        <select class="form-control" id="WardProvince"></select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Tên</label>
                        <input type="text" class="form-control" id="WardName" />
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Status</label>
                        <input type="number" class="form-control" id="WardStatus" value="1" />
                    </div>
                    <div class="mb-3">
                        <label class="form-label">SortOrder</label>
                        <input type="number" class="form-control" id="WardSort" value="0" />
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">H?y</button>
                    <button type="button" class="btn btn-warning" id="BtnSaveWard">Luu</button>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="Scripts" runat="server">
<script>
    $(function () {
        function loadProvinces() {
            $.getJSON('../api/system/provinces.ashx?action=list', function (data) {
                var html = '';
                data.forEach(function (item) {
                    html += '<option value="' + item.Id + '">' + item.Name + '</option>';
                });
                $('#WardProvince').html(html);
            });
        }

        var table = $('#tblWards').DataTable({
            serverSide: true,
            processing: true,
            ajax: {
                url: '../api/system/wards.ashx',
                type: 'POST'
            },
            columns: [
                { data: 'Id' },
                { data: 'Name' },
                { data: 'ProvinceName' },
                { data: 'Status' },
                { data: 'SortOrder' },
                {
                    data: null,
                    orderable: false,
                    render: function (data) {
                        return '<button class="btn btn-sm btn-outline-danger delete" data-id="' + data.Id + '"><i class="fa-regular fa-trash-can"></i></button>';
                    }
                }
            ]
        });

        loadProvinces();

        $('#BtnSaveWard').on('click', function () {
            $.ajax({
                url: '../api/system/wards.ashx',
                type: 'POST',
                data: {
                    action: 'create',
                    provinceId: $('#WardProvince').val(),
                    name: $('#WardName').val(),
                    status: $('#WardStatus').val(),
                    sortOrder: $('#WardSort').val()
                }
            }).done(function () {
                $('#wardModal').modal('hide');
                table.ajax.reload();
            });
        });

        $('#tblWards').on('click', 'button.delete', function () {
            if (!confirm('Xóa m?c này?')) return;
            var id = $(this).data('id');
            $.ajax({
                url: '../api/system/wards.ashx',
                type: 'POST',
                data: { action: 'delete', id: id }
            }).done(function () { table.ajax.reload(); });
        });
    });
</script>
</asp:Content>
