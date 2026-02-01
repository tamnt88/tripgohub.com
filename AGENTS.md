# AGENTS.md — tripgohub.com

## Tổng quan
- Tên dự án: Tripgohub
- Mục tiêu: Xây dựng hệ thống du lịch tương tự Traveloka cho người dùng Việt Nam.
- Ngôn ngữ: Website hỗ trợ Tiếng Việt + English; phần admin dùng Tiếng Việt.
## Công nghệ & môi trường
- Nền tảng: .NET (C#).
- Ứng dụng web: ASP.NET Web Forms (ASPX).
- CSDL: SQL Server 2022.
- Hệ điều hành máy chủ: Windows Server 2022.

## Cấu hình cơ sở dữ liệu (tạm thời)
- SQL Server: `(localdb)\\MSSQLLocalDB`
- User: `sa`
- Password: `123456`
- Database: `TripGoHubDB` (chưa tạo)

## Giọng điệu & nội dung
- Giọng điệu: thân thiện, rõ ràng, hữu ích.
- Hạn chế: không dùng ngôn ngữ quảng cáo quá đà; tránh thông tin mơ hồ.
- Chuẩn hoá chính tả tiếng Việt.

## Quy tắc làm việc
- Ưu tiên tạo thay đổi nhỏ, rõ ràng, dễ review.
- Trước khi thêm thư viện hoặc phụ thuộc mới, xác nhận nhu cầu.
- Không xóa hoặc ghi đè thay đổi hiện có nếu không được yêu cầu.
- Trước khi xử lý yêu cầu mới: luôn đọc `document/WORK_LOG.md` và `document/DB_SCHEMA_CURRENT.md` để nắm lịch sử và schema hiện tại.

## Cấu trúc repo
- `document/`: tài liệu nội bộ.
- `tripdev/`: mã nguồn hoặc môi trường phát triển.

## Liên hệ & hướng dẫn bổ sung
- Nếu thiếu thông tin (yêu cầu, scope, framework), hãy hỏi lại.
- Nếu người dùng yêu cầu “xin chào”, ưu tiên tạo lời chào tiếng Việt ngắn gọn.

## Ví dụ nội dung
- Lời chào: "Xin chào! Tripgohub rất vui được đồng hành cùng bạn trên mọi hành trình."

## Tài liệu nội bộ
- `document/DB_RULES.md`: quy tắc đặt tên, prefix và cột mặc định.
- `document/DB_SCHEMA_CURRENT.md`: mô tả DB hiện tại theo module.
- `document/ADMIN_RULES.md`: quy tắc/admin flow nội bộ.
- `document/TRANSFER_FEATURE.md`: mô tả module đặt xe di chuyển (transfer).
- `document/WORK_LOG.md`: log các thay đổi đã thực hiện và quy tắc mới.


## Quy tắc bổ sung
- Luôn ghi lại mọi thay đổi vào document/WORK_LOG.md sau mỗi lần xử lý.
- Tabs ngôn ngữ trong admin phải render theo dữ liệu trong bảng 	gh_language (không hardcode cờ/nhãn).

