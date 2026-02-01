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

## Dữ liệu chính (bảng hiện tại)
- `trf_vehicle_type`: loại xe.
- `trf_vehicle`: thông tin xe.
- `trf_driver`: tài xế.
- `trf_route`: tuyến cố định.
- `trf_route_lang`: tên tuyến theo ngôn ngữ.
- `trf_route_price`: giá theo tuyến và loại xe (giá 1 chiều/khứ hồi).
- `trf_transfer_booking`: đơn đặt xe.
- `trf_transfer_booking_assign`: gán xe + tài xế cho booking.

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

## Nhật ký thay đổi (tóm tắt mới)
- 2026-01-31: Chuẩn hóa bảng module transfer sang prefix `trf_`.
- 2026-01-31: Bổ sung bảng ngôn ngữ cho tuyến và loại xe (`trf_route_lang`, `trf_vehicle_type_lang`).
- 2026-01-31: Cập nhật EF và code public/admin theo tên bảng mới.
- 2026-01-31: Admin: danh sách booking dùng EF, mapping `Route` + `VehicleType`.
- 2026-02-01: Áp dụng rewrite URL public và giữ admin truy cập `.aspx` trực tiếp.
