<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="TripGoHub.Web.Default" %>
<!DOCTYPE html>
<html lang="vi">
<head runat="server">
    <meta charset="utf-8" />
    <title>TripGoHub - Trang chủ</title>
    <link rel="stylesheet" href="<%: ResolveUrl("~/Content/vendor/bootstrap/css/bootstrap.min.css") %>" />
    <link rel="stylesheet" href="<%: ResolveUrl("~/Content/vendor/fontawesome/css/all.min.css") %>" />
    <link rel="stylesheet" href="<%: ResolveUrl("~/Content/site.css") %>" />
</head>
<body>
    <form id="form1" runat="server">
        <header class="topbar">
            <div class="brand">TripGoHub</div>
            <nav class="nav">
                <a href="#">Sim du lịch</a>
                <a href="#">Vé tham quan</a>
                <a href="#">Xe di chuyển</a>
                <a href="#">Homestay</a>
                <a href="#">Tour</a>
                <a href="#">Vé máy bay</a>
                <a href="#">Phòng khách sạn</a>
            </nav>
            <div class="actions">
                <button type="button" class="btn btn--ghost"><i class="fa-solid fa-user"></i> Đăng nhập</button>
                <button type="button" class="btn btn--primary"><i class="fa-solid fa-user-plus"></i> Tạo tài khoản</button>
            </div>
        </header>

        <main class="hero">
            <section class="hero__content">
                <div class="hero__intro">
                    <h1>Hệ sinh thái du lịch cho mọi hành trình</h1>
                    <p>Chọn dịch vụ và tìm kiếm theo nhu cầu trong vài bước.</p>
                </div>

                <div class="search-card">
                    <div class="search-tabs">
                        <button type="button" class="tab tab--active" data-target="#tab-sim"><i class="fa-solid fa-sim-card"></i> Sim du lịch</button>
                        <button type="button" class="tab" data-target="#tab-visit"><i class="fa-solid fa-ticket"></i> Vé tham quan</button>
                        <button type="button" class="tab" data-target="#tab-vehicle"><i class="fa-solid fa-car"></i> Xe di chuyển</button>
                        <button type="button" class="tab" data-target="#tab-homestay"><i class="fa-solid fa-house"></i> Homestay</button>
                        <button type="button" class="tab" data-target="#tab-tour"><i class="fa-solid fa-map-location-dot"></i> Tour</button>
                        <button type="button" class="tab" data-target="#tab-flight"><i class="fa-solid fa-plane"></i> Vé máy bay</button>
                        <button type="button" class="tab" data-target="#tab-hotel"><i class="fa-solid fa-hotel"></i> Phòng khách sạn</button>
                    </div>

                    <div class="tab-panels">
                        <div class="tab-panel is-active" id="tab-sim">
                            <div class="search-form">
                                <div class="field">
                                    <label>Quốc gia</label>
                                    <input type="text" placeholder="Nhật Bản, Hàn Quốc..." />
                                </div>
                                <div class="field">
                                    <label>Ngày khởi hành</label>
                                    <input type="date" />
                                </div>
                                <div class="field">
                                    <label>Số ngày</label>
                                    <input type="number" min="1" value="5" />
                                </div>
                                <div class="field field--cta">
                                    <button type="button" class="btn btn--primary btn--block"><i class="fa-solid fa-magnifying-glass"></i> Tìm sim</button>
                                </div>
                            </div>
                        </div>

                        <div class="tab-panel" id="tab-visit">
                            <div class="search-form">
                                <div class="field">
                                    <label>Điểm đến</label>
                                    <input type="text" placeholder="Đà Nẵng, Nha Trang..." />
                                </div>
                                <div class="field">
                                    <label>Ngày tham quan</label>
                                    <input type="date" />
                                </div>
                                <div class="field">
                                    <label>Vé</label>
                                    <select><option>Người lớn</option><option>Trẻ em</option></select>
                                </div>
                                <div class="field field--cta">
                                    <button type="button" class="btn btn--primary btn--block"><i class="fa-solid fa-magnifying-glass"></i> Tìm vé</button>
                                </div>
                            </div>
                        </div>

                        <div class="tab-panel" id="tab-vehicle">
                            <div class="search-form">
                                <div class="field">
                                    <label>Điểm đón</label>
                                    <input type="text" placeholder="Sân bay, khách sạn..." />
                                </div>
                                <div class="field">
                                    <label>Điểm trả</label>
                                    <input type="text" placeholder="Trung tâm, bến xe..." />
                                </div>
                                <div class="field">
                                    <label>Ngày đi</label>
                                    <input type="date" />
                                </div>
                                <div class="field field--cta">
                                    <button type="button" class="btn btn--primary btn--block"><i class="fa-solid fa-magnifying-glass"></i> Tìm xe</button>
                                </div>
                            </div>
                        </div>

                        <div class="tab-panel" id="tab-homestay">
                            <div class="search-form">
                                <div class="field">
                                    <label>Địa điểm</label>
                                    <input type="text" placeholder="Đà Lạt, Phú Quốc..." />
                                </div>
                                <div class="field">
                                    <label>Nhận phòng</label>
                                    <input type="date" />
                                </div>
                                <div class="field">
                                    <label>Trả phòng</label>
                                    <input type="date" />
                                </div>
                                <div class="field field--cta">
                                    <button type="button" class="btn btn--primary btn--block"><i class="fa-solid fa-magnifying-glass"></i> Tìm homestay</button>
                                </div>
                            </div>
                        </div>

                        <div class="tab-panel" id="tab-tour">
                            <div class="search-form">
                                <div class="field">
                                    <label>Điểm đến</label>
                                    <input type="text" placeholder="Châu Âu, Thái Lan..." />
                                </div>
                                <div class="field">
                                    <label>Ngày khởi hành</label>
                                    <input type="date" />
                                </div>
                                <div class="field">
                                    <label>Số người</label>
                                    <input type="number" min="1" value="2" />
                                </div>
                                <div class="field field--cta">
                                    <button type="button" class="btn btn--primary btn--block"><i class="fa-solid fa-magnifying-glass"></i> Tìm tour</button>
                                </div>
                            </div>
                        </div>

                        <div class="tab-panel" id="tab-flight">
                            <div class="search-form">
                                <div class="field">
                                    <label>Điểm đi</label>
                                    <input type="text" placeholder="Hà Nội (HAN)" />
                                </div>
                                <div class="field">
                                    <label>Điểm đến</label>
                                    <input type="text" placeholder="TP. HCM (SGN)" />
                                </div>
                                <div class="field">
                                    <label>Ngày đi</label>
                                    <input type="date" />
                                </div>
                                <div class="field">
                                    <label>Ngày về</label>
                                    <input type="date" />
                                </div>
                                <div class="field field--cta">
                                    <button type="button" class="btn btn--primary btn--block"><i class="fa-solid fa-magnifying-glass"></i> Tìm vé máy bay</button>
                                </div>
                            </div>
                        </div>

                        <div class="tab-panel" id="tab-hotel">
                            <div class="search-form">
                                <div class="field">
                                    <label>Địa điểm</label>
                                    <input type="text" placeholder="Hội An, Huế..." />
                                </div>
                                <div class="field">
                                    <label>Nhận phòng</label>
                                    <input type="date" />
                                </div>
                                <div class="field">
                                    <label>Trả phòng</label>
                                    <input type="date" />
                                </div>
                                <div class="field">
                                    <label>Khách</label>
                                    <select><option>2 người lớn</option><option>Gia đình</option></select>
                                </div>
                                <div class="field field--cta">
                                    <button type="button" class="btn btn--primary btn--block"><i class="fa-solid fa-magnifying-glass"></i> Tìm khách sạn</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
        </main>
    </form>

    <script src="<%: ResolveUrl("~/Content/vendor/jquery/jquery.min.js") %>"></script>
    <script src="<%: ResolveUrl("~/Content/vendor/bootstrap/js/bootstrap.bundle.min.js") %>"></script>
    <script>
        $('.search-tabs .tab').on('click', function () {
            var target = $(this).data('target');
            $('.search-tabs .tab').removeClass('tab--active');
            $(this).addClass('tab--active');
            $('.tab-panel').removeClass('is-active');
            $(target).addClass('is-active');
        });
    </script>
</body>
</html>
