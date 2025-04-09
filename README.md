UART AHB (Universal Asynchronous Receiver/Transmitter kết nối với bus AHB) là một module UART được tích hợp trong hệ thống sử dụng bus AMBA AHB (Advanced High-performance Bus). Đây là một giao tiếp phổ biến trong các SoC (System on Chip) để cho phép CPU giao tiếp với các thiết bị ngoại vi như UART.

UART AHB bao gồm một AHB slave interface, đóng vai trò là thiết bị ngoại vi nhận truy cập từ CPU hoặc các master khác qua bus AHB. Giao tiếp này bao gồm các tín hiệu chính:

-HADDR: Địa chỉ truy cập thanh ghi UART

-HWDATA: Dữ liệu ghi vào từ master

-HRDATA: Dữ liệu đọc ra gửi về master

-HWRITE: Tín hiệu điều khiển đọc/ghi

-HSEL: Chọn UART là thiết bị được truy cập

-HREADY, HRESP: Dùng để báo trạng thái sẵn sàng hoặc phản hồi lỗi

Cấu trúc và quá trình truyền dữ liệu của UART AHB:
AHB-->fifo_tx-->TX-->RX-->fifo_rx-->AHB



![image](https://github.com/user-attachments/assets/ac49d8d8-2488-4729-8c04-37f1ce9ee374)
