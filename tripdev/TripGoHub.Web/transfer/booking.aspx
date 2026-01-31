<%@ Page Title="Đặt xe di chuyển" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="booking.aspx.cs" Inherits="TripGoHub.Web.Transfer.Booking" %>
<asp:Content ID="TitleBlock" ContentPlaceHolderID="TitleContent" runat="server">Đặt xe di chuyển - TripGoHub</asp:Content>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        body { background: #f6f8fb; }
        .wrap { max-width: 920px; margin: 30px auto; background: #fff; border-radius: 12px; box-shadow: 0 8px 24px rgba(0,0,0,0.08); padding: 24px; }
        h1 { margin: 0 0 8px; font-size: 22px; }
        .sub { color: #666; margin-bottom: 20px; }
        .grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 16px; }
        .field { display: flex; flex-direction: column; gap: 6px; }
        label { font-weight: 600; }
        input, select, textarea { padding: 10px 12px; border: 1px solid #d8dee4; border-radius: 8px; font-size: 14px; }
        .row { display: flex; gap: 12px; }
        .row label { font-weight: 400; }
        .actions { margin-top: 20px; display: flex; align-items: center; gap: 12px; }
        .btn-book { background: #f1b100; color: #1f1f1f; border: none; padding: 10px 16px; border-radius: 8px; font-weight: 700; cursor: pointer; }
        .note { font-size: 13px; color: #777; }
        .msg { margin-top: 16px; padding: 10px 12px; border-radius: 8px; }
        .error { background: #ffe6e6; color: #b00020; }
        .success { background: #e8f7ee; color: #176b3a; }
        @media (max-width: 720px) { .grid { grid-template-columns: 1fr; } }
    </style>
        <div class="wrap">
            <h1>Đặt xe di chuyển</h1>
            <div class="sub">Chọn tuyến cố định, loại xe và thời gian. Hệ thống sẽ tính giá tự động.</div>

        <style>
            .route-row { display: grid; grid-template-columns: 1fr 42px 1fr; gap: 12px; align-items: end; }
            .swap-btn { height: 42px; border-radius: 10px; border: 1px solid #d8dee4; background: #f7f7f7; cursor: pointer; }
            .quick { font-size: 12px; color: #777; margin-top: 6px; }
        </style>

        <div class="grid">
            <div class="field" style="grid-column: span 2;">
                <label>Điểm đón / Điểm trả</label>
                <div class="route-row">
                    <div class="field">
                        <label for="PickupPoint">Điểm đón</label>
                        <asp:TextBox ID="PickupPoint" runat="server" list="pickupList"></asp:TextBox>
                        <datalist id="pickupList"></datalist>
                    </div>
                    <button type="button" class="swap-btn" id="SwapRoute" title="Đảo chiều">⇄</button>
                    <div class="field">
                        <label for="DropoffPoint">Điểm trả</label>
                        <asp:TextBox ID="DropoffPoint" runat="server" list="dropoffList"></asp:TextBox>
                        <datalist id="dropoffList"></datalist>
                    </div>
                </div>
                <div class="quick">Gợi ý nhanh: nhập 2–3 ký tự để chọn tuyến cố định.</div>
                <asp:DropDownList ID="RouteId" runat="server" style="display:none;"></asp:DropDownList>
            </div>
            <div class="field">
                <label for="VehicleTypeId">Loại xe</label>
                <asp:DropDownList ID="VehicleTypeId" runat="server"></asp:DropDownList>
            </div>
            <div class="field">
                <label for="PickupTime">Thời gian đi</label>
                <asp:TextBox ID="PickupTime" runat="server" TextMode="DateTimeLocal"></asp:TextBox>
            </div>
            <div class="field" id="ReturnTimeWrap">
                <label for="ReturnTime">Thời gian về (khứ hồi)</label>
                <asp:TextBox ID="ReturnTime" runat="server" TextMode="DateTimeLocal"></asp:TextBox>
            </div>
            <div class="field">
                <label>Loại chuyến</label>
                <div class="row">
                    <label><asp:RadioButton ID="TripOneWay" runat="server" GroupName="TripType" Checked="true" /> Một chiều</label>
                    <label><asp:RadioButton ID="TripRound" runat="server" GroupName="TripType" /> Khứ hồi</label>
                </div>
            </div>
            <div class="field">
                <label>Hình thức thanh toán</label>
                <div class="row">
                    <label><asp:RadioButton ID="PayOnline" runat="server" GroupName="PaymentType" Checked="true" /> Online</label>
                    <label><asp:RadioButton ID="PayHold" runat="server" GroupName="PaymentType" /> Giữ chỗ</label>
                </div>
            </div>
            <div class="field">
                <label for="CustomerName">Họ tên</label>
                <asp:TextBox ID="CustomerName" runat="server"></asp:TextBox>
            </div>
            <div class="field">
                <label for="CustomerPhone">Điện thoại</label>
                <asp:TextBox ID="CustomerPhone" runat="server"></asp:TextBox>
            </div>
            <div class="field">
                <label for="CustomerEmail">Email</label>
                <asp:TextBox ID="CustomerEmail" runat="server"></asp:TextBox>
            </div>
            <div class="field">
                <label for="Note">Ghi chú</label>
                <asp:TextBox ID="Note" runat="server" TextMode="MultiLine" Rows="3"></asp:TextBox>
            </div>
        </div>

        <div class="actions">
            <asp:Button ID="BtnSubmit" runat="server" Text="Đặt xe" CssClass="btn-book" OnClick="BtnSubmit_Click" />
            <span class="note">Giá sẽ được tính theo tuyến cố định.</span>
        </div>

        <asp:Panel ID="MessagePanel" runat="server" Visible="false" CssClass="msg">
            <asp:Literal ID="MessageText" runat="server"></asp:Literal>
        </asp:Panel>
        <asp:Literal ID="RouteDataJson" runat="server" Visible="false"></asp:Literal>
    </div>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="Scripts" runat="server">
<script>
    var routes = <%= RouteDataJson.Text %>;

    function fillRouteLists() {
        var pickupList = document.getElementById('pickupList');
        var dropoffList = document.getElementById('dropoffList');
        pickupList.innerHTML = '';
        dropoffList.innerHTML = '';
        routes.forEach(function (r) {
            var opt1 = document.createElement('option');
            opt1.value = r.FromName;
            pickupList.appendChild(opt1);
            var opt2 = document.createElement('option');
            opt2.value = r.ToName;
            dropoffList.appendChild(opt2);
        });
    }

    function syncRouteId() {
        var pickup = document.getElementById('<%= PickupPoint.ClientID %>').value.trim();
        var dropoff = document.getElementById('<%= DropoffPoint.ClientID %>').value.trim();
        var match = routes.find(function (r) {
            return r.FromName === pickup && r.ToName === dropoff;
        });
        if (match) {
            var ddl = document.getElementById('<%= RouteId.ClientID %>');
            for (var i = 0; i < ddl.options.length; i++) {
                if (ddl.options[i].value == match.RouteId) {
                    ddl.selectedIndex = i;
                    break;
                }
            }
        }
    }

    function toggleReturn() {
        var isRound = document.getElementById('<%= TripRound.ClientID %>').checked;
        var wrap = document.getElementById('ReturnTimeWrap');
        if (wrap) wrap.style.display = isRound ? 'block' : 'none';
    }

    document.getElementById('<%= PickupPoint.ClientID %>').addEventListener('change', syncRouteId);
    document.getElementById('<%= DropoffPoint.ClientID %>').addEventListener('change', syncRouteId);
    document.getElementById('SwapRoute').addEventListener('click', function () {
        var pickup = document.getElementById('<%= PickupPoint.ClientID %>');
        var dropoff = document.getElementById('<%= DropoffPoint.ClientID %>');
        var temp = pickup.value;
        pickup.value = dropoff.value;
        dropoff.value = temp;
        syncRouteId();
    });

    document.getElementById('<%= TripOneWay.ClientID %>').addEventListener('change', toggleReturn);
    document.getElementById('<%= TripRound.ClientID %>').addEventListener('change', toggleReturn);
    fillRouteLists();
    toggleReturn();
</script>
</asp:Content>
