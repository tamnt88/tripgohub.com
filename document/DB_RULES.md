# Quy tắc DB (cập nhật)

## Quy tắc tên bảng
- Bảng dùng chung: prefix `tgh_`.
- Bảng theo module: prefix 3 ký tự + `_` (ví dụ `trf_` cho transfer, `adm_` cho admin, `pub_` cho public menu).

## Cột mặc định bắt buộc
Mọi bảng mới phải có các cột:
- `Status`
- `SortOrder`
- `CreatedAt`
- `CreatedBy`
- `UpdatedAt`
- `UpdatedBy`

## Ngôn ngữ & slug
- Đa ngôn ngữ dùng bảng lang riêng theo chuẩn `{entity}_lang`.
- Slug quản lý tập trung ở `tgh_slug`, unique theo ngôn ngữ.

## Ghi chú
- Admin dùng tiếng Việt, public đa ngôn ngữ.
- Description dùng kiểu `NVARCHAR(MAX)` cho nội dung dài.
