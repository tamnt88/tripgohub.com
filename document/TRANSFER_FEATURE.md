# Tính năng đặt xe di chuyển

## Phạm vi
- Tính giá theo tuyến cố định.
- Thanh toán online hoặc đặt giữ chỗ.
- Xe do Tripgohub quản lý.
- Hỗ trợ đặt khứ hồi.

## Luồng nghiệp vụ
- Người dùng chọn tuyến + loại xe + thời gian đi.
- Nếu khứ hồi: nhập thời gian về.
- Hệ thống lấy giá theo tuyến cố định.
- Chọn hình thức: thanh toán online hoặc giữ chỗ.
- Tạo booking và chờ admin xác nhận/gán xe.

## Dữ liệu chính (đề xuất bảng)
- `tgh_vehicle_type`: loại xe.
- `tgh_vehicle`: thông tin xe.
- `tgh_driver`: tài xế.
- `tgh_route`: tuyến cố định.
- `tgh_route_price`: giá theo tuyến và loại xe (giá 1 chiều/khứ hồi).
- `tgh_transfer_booking`: đơn đặt xe.
- `tgh_transfer_booking_assign`: gán xe + tài xế cho booking.

## Trạng thái gợi ý
- Booking: Pending / Confirmed / Cancelled / Completed.
- Payment: Unpaid / Paid / Refunded.

## Quy tắc
- Nếu khứ hồi thì `ReturnTime` bắt buộc.
- Giá khứ hồi dùng `PriceRoundTrip` (không tự nhân đôi).
- Các bảng mới phải có cột mặc định: `Status`, `SortOrder`, `CreatedAt`, `CreatedBy`, `UpdatedAt`, `UpdatedBy`.

## UX điểm đón/điểm trả (gợi ý nhanh)
- Dùng autocomplete gợi ý tuyến cố định: người dùng gõ 2–3 ký tự là có danh sách.
- Hiển thị “tuyến phổ biến” và “điểm gần đây” để chọn nhanh.
- Cho phép đảo chiều điểm đón/điểm trả (nút ⇄).
- Mặc định điểm đón là sân bay/ga phổ biến nếu IP/địa chỉ thuộc thành phố đó.
- Cho phép nhập ghi chú chi tiết (cổng/ga/khách sạn) sau khi chọn tuyến.

## Tài liệu kỹ thuật
- Script CSDL khởi tạo: `document/tripgohub_transfer_schema.sql`
- Script seed dữ liệu: `document/tripgohub_transfer_seed.sql`

## Nhật ký thay đổi
- 2026-01-31: Tạo script CSDL cho module transfer (`tripgohub_transfer_schema.sql`).
- 2026-01-31: Thêm script seed dữ liệu mẫu cho transfer (`tripgohub_transfer_seed.sql`).
- 2026-01-31: Tạo trang đặt xe Web Forms (`tripdev/TripGoHub.Web/transfer/booking.aspx`, `tripdev/TripGoHub.Web/transfer/booking.aspx.cs`).
- 2026-01-31: Tạo trang admin danh sách booking + handler server-side (`tripdev/TripGoHub.Web/admin/transfer_bookings.aspx`, `tripdev/TripGoHub.Web/admin/transfer_bookings.aspx.cs`, `tripdev/TripGoHub.Web/admin/api/transfer_bookings.ashx`).
- 2026-01-31: Tạo masterpage public (`tripdev/TripGoHub.Web/Site.master`, `tripdev/TripGoHub.Web/Site.master.cs`, `tripdev/TripGoHub.Web/Site.master.designer.cs`) và áp dụng cho `Default.aspx`, `transfer/booking.aspx`.
- 2026-01-31: Bổ sung loại xe và loại chuyến ở tab tìm kiếm xe di chuyển (trang chủ) (`tripdev/TripGoHub.Web/Default.aspx`).
- 2026-01-31: Thêm autocomplete điểm đón/điểm trả và nút đảo chiều trên trang đặt xe (`tripdev/TripGoHub.Web/transfer/booking.aspx`, `tripdev/TripGoHub.Web/transfer/booking.aspx.cs`, `tripdev/TripGoHub.Web/transfer/booking.aspx.designer.cs`).
- 2026-01-31: Thêm autocomplete điểm đón/điểm trả ở trang chủ và chuyển dữ liệu sang form đặt xe (`tripdev/TripGoHub.Web/Default.aspx`, `tripdev/TripGoHub.Web/Default.aspx.cs`, `tripdev/TripGoHub.Web/Default.aspx.designer.cs`, `tripdev/TripGoHub.Web/transfer/booking.aspx.cs`).
