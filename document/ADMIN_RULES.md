# Quy tắc Admin (TripGoHub)

## Layout & Assets
- Admin dùng **Bootstrap + jQuery + Font Awesome** dạng offline.
- Tất cả CSS/JS admin phải nằm trong thư mục `admin`.
- Master page dùng: `admin/Admin.master`.

## Data Table
- Tất cả màn hình danh sách trong admin phải dùng **jQuery DataTables (server-side)**.
- Không load toàn bộ dữ liệu vào GridView/Repeater.
- Dữ liệu phải lấy qua handler `admin/api/*.ashx`.

## Chứng thực
- Các trang trong `admin` (trừ `login.aspx`) phải kế thừa `TripGoHub.Web.Security.AdminPage`.
- Session timeout cấu hình trong `Web.config`.

## CRUD
- CRUD gọi qua AJAX tới `admin/api/*.ashx`.

## Data access
- Tất cả thao tác đọc/ghi dữ liệu trong hệ thống phải dùng Entity Framework (EF). Không dùng `SqlConnection`, `SqlCommand`, hoặc raw SQL trực tiếp.

## Module folders
- Trang admin phải đặt đúng thư mục theo module: `admin/{module}/...`.
- API admin phải đặt đúng thư mục theo module: `admin/api/{module}/...`.
