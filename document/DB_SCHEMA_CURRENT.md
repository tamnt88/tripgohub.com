# DB Schema hiện tại (TripGoHub)


- 	gh_AdminUser: tài khoản admin.

## Admin (adm_)
- `adm_menu`: menu admin (tree).
- `adm_menu_lang`: nội dung menu admin theo ngôn ngữ.

## Public menu (pub_)
- `pub_menu`: menu public (tree nếu cần).
- `pub_menu_lang`: nội dung menu public theo ngôn ngữ.

## Transfer module (trf_)
- `trf_route`: tuyến cố định.
- `trf_route_lang`: tên tuyến theo ngôn ngữ.
- `trf_route_price`: giá tuyến theo loại xe.
- `trf_vehicle_type`: loại xe.
- `trf_vehicle_type_lang`: tên loại xe theo ngôn ngữ.
- `trf_vehicle_brand`: hãng xe.
- `trf_vehicle_brand_lang`: tên hãng xe theo ngôn ngữ.
- `trf_vehicle_model`: model xe.
- `trf_vehicle_model_lang`: tên model theo ngôn ngữ.
- `trf_vehicle`: xe.
- `trf_driver`: tài xế.
- `trf_transfer_booking`: booking.
- `trf_transfer_booking_assign`: gán xe + tài xế.

## Seed & reset
- File tổng reset: `document/tripgohub_reset_all.sql`
- Seed quốc gia: `document/tgh_country_seed.sql`
- Seed VN admin units: `document/tgh_vn_admin_units_seed.sql`

## Ghi chú
- Slug unique theo ngôn ngữ, dùng `tgh_slug`.
- Tất cả bảng mới có 6 cột mặc định.

