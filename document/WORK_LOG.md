# TripGoHub - Work Log & Rules (Updated)

## Quy tắc bổ sung
- Toàn bộ CSS và JS phải tách ra file riêng và import vào trang. Không viết inline trong .aspx/.master.
- Luôn ghi lại mọi thay đổi vào `document/WORK_LOG.md` sau mỗi lần xử lý.
- Tabs ngôn ngữ trong admin phải render theo dữ liệu trong bảng `tgh_language` (không hardcode cờ/nhãn).

## Hạng mục đã triển khai

### 1) Hệ thống đa ngôn ngữ + URL rewrite
- Bảng ngôn ngữ và slug dùng chung:
  - `tgh_language`, `tgh_slug`, `tgh_site_setting`.
- Public i18n theo bảng riêng, slug unique theo ngôn ngữ.
- Route rewrite cho public; admin vẫn dùng URL .aspx.
- `LangHelper` lấy ngôn ngữ từ DB + cookie, build URL theo ngôn ngữ.
- Header public dùng dropdown chọn ngôn ngữ (flag + text).

### 2) Hệ thống menu admin từ DB
- Bảng menu admin:
  - `adm_menu`, `adm_menu_lang`.
- Seed menu: Dashboard, Đặt xe, Cấu hình hệ thống, Quốc gia, Đơn vị hành chính, Menu admin.
- API CRUD menu admin + render menu từ DB.
- Bỏ menu “Tỉnh/Thành” và “Phường/Xã” khỏi seed.

### 3) Chuẩn hóa prefix bảng
- Bảng dùng chung: prefix `tgh_`.
- Bảng module: prefix 3 ký tự (ví dụ `trf_`).
- Cập nhật schema/seed theo quy tắc.

### 4) Hệ thống quốc gia & đơn vị hành chính
- Bảng mới:
  - `tgh_country`, `tgh_country_lang`, `tgh_admin_unit`, `tgh_admin_unit_lang`.
- Seed toàn bộ quốc gia từ datahub.io.
- Import dữ liệu VN từ Excel `Danh-muc-Phuong-xa_moi.xlsx`:
  - 34 tỉnh/thành
  - 3321 phường/xã
- UI quản trị:
  - `admin/system/countries.aspx`
  - `admin/system/admin_units.aspx` (cây jsTree đa cấp)
- API:
  - `admin/api/system/countries.ashx`
  - `admin/api/system/admin_units.ashx` (tree + CRUD)

### 5) CRUD server-side (admin)
- Quốc gia: list + add/edit page, server-side DataTables, filter, tag trạng thái, overlay loading.
- Menu admin: list + add/edit page, server-side DataTables, filter, tag trạng thái/group.
- Tỉnh/Thành & Phường/Xã: list + add/edit page (giữ lại file nhưng menu đã bỏ).

### 6) Đa ngôn ngữ trong admin (form)
- Country/Province/Ward: 1 form 2 tab (VI/EN) + auto-translate EN.
- Admin Units: dropdown chọn ngôn ngữ, cây + form hiển thị theo ngôn ngữ, có gợi ý EN.
- Render tabs ngôn ngữ trong `admin/system/country_edit.aspx` theo bảng `tgh_language`.

### 7) Footer public + assets
- Footer theo mẫu, gồm 4 cột + payment/partner/awards + social.
- Dùng ảnh thực:
  - Payment: `images/payment/*.png`
  - Partner: `images/partner/*.png`
  - Awards: `images/award/*` (có .webp)
  - Social: `images/social/*`

### 8) CSS/JS public
- CSS chung: `Content/site.css`.
- CSS mobile: `Content/site.mobile.css`.
- JS public: `Content/site.js` (dropdown ngôn ngữ).

### 9) Fix lỗi build/runtime
- Sửa ký tự lạ trong `Slug.cs`.
- `Global.asax` theo kiểu Web Site (`CodeFile`).
- `Global.asax.cs` dùng `partial` class.
- Thêm navigation property trong `TransferBooking` (Route/VehicleType).
- Cho phép `.webp` trong `Web.config`.
- Sửa `admin/system/country_edit.aspx.cs` tránh null-conditional (tương thích .NET 4.x).

### 10) Assets offline admin
- Tải và dùng local assets cho jsTree (CSS/JS).
- Bổ sung `32px.png`, `40px.png`, `throbber.gif` cho jsTree.

## Seed/SQL
- `document/tripgohub_reset_all.sql` cập nhật theo schema mới.
- `document/tripgohub_admin_menu_seed.sql` bỏ menu provinces/wards.
- Tạo `document/tripgohub_admin_unit_seed_en.sql` để seed EN từ VI (dịch theo từ vựng).

## Các file chính đã chỉnh
- `tripdev/TripGoHub.Web/Global.asax`
- `tripdev/TripGoHub.Web/Global.asax.cs`
- `tripdev/TripGoHub.Web/Site.master`
- `tripdev/TripGoHub.Web/Content/site.css`
- `tripdev/TripGoHub.Web/Content/site.mobile.css`
- `tripdev/TripGoHub.Web/Content/site.js`
- `tripdev/TripGoHub.Web/Web.config`
- `tripdev/TripGoHub.Web/App_Code/TripGoHubDbContext.cs`
- `tripdev/TripGoHub.Web/App_Code/Models/*`
- `tripdev/TripGoHub.Web/admin/Admin.master`
- `tripdev/TripGoHub.Web/admin/assets/css/admin.css`
- `tripdev/TripGoHub.Web/admin/system/countries.aspx`
- `tripdev/TripGoHub.Web/admin/system/country_edit.aspx`
- `tripdev/TripGoHub.Web/admin/system/country_edit.aspx.cs`
- `tripdev/TripGoHub.Web/admin/system/admin_units.aspx`
- `tripdev/TripGoHub.Web/admin/assets/js/admin_units.js`
- `tripdev/TripGoHub.Web/admin/api/system/countries.ashx`
- `tripdev/TripGoHub.Web/admin/api/system/admin_units.ashx`
- `document/tripgohub_reset_all.sql`
- `document/tripgohub_admin_menu_seed.sql`
- `document/tripgohub_admin_unit_seed_en.sql`

## Ghi chú
- Admin dùng tiếng Việt.
- Public hiển thị đa ngôn ngữ theo `tgh_language`.
- Slug unique theo ngôn ngữ, quản lý tập trung trong `tgh_slug`.
