<%@ Page Title="Đặt xe" Language="C#" MasterPageFile="~/admin/Admin.master" AutoEventWireup="true" CodeFile="transfer_bookings.aspx.cs" Inherits="TripGoHub.Web.Admin.TransferBookings" %>
<asp:Content ID="TitleBlock" ContentPlaceHolderID="TitleContent" runat="server">Đặt xe</asp:Content>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="d-flex align-items-center justify-content-between mb-3">
        <h1 class="h4 fw-bold mb-0">Đặt xe</h1>
    </div>
    <table id="tblTransferBookings" class="table table-striped table-bordered w-100">
        <thead>
            <tr>
                <th>Mã</th>
                <th>Khách</th>
                <th>Điện thoại</th>
                <th>Tuyến</th>
                <th>Loại xe</th>
                <th>Giờ đi</th>
                <th>Trạng thái</th>
                <th>Thanh toán</th>
            </tr>
        </thead>
    </table>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="Scripts" runat="server">
<script>
    $(function () {
        $('#tblTransferBookings').DataTable({
            serverSide: true,
            processing: true,
            ajax: {
                url: '../admin/api/transfer_bookings.ashx',
                type: 'POST'
            },
            columns: [
                { data: 'BookingCode' },
                { data: 'CustomerName' },
                { data: 'CustomerPhone' },
                { data: 'RouteName' },
                { data: 'VehicleTypeName' },
                { data: 'PickupTime' },
                { data: 'Status' },
                { data: 'PaymentStatus' }
            ]
        });
    });
</script>
</asp:Content>
