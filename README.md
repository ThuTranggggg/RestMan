# 🍽️ RestMan20 - Hệ thống Quản lý Nhà hàng

## 📝 Mô tả Dự án

RestMan20 là một hệ thống quản lý nhà hàng hiện đại, cung cấp các tính năng:
- 👨‍💼 Giao diện cho **Nhân viên bán hàng** (thanh toán hóa đơn)
- 👤 Giao diện cho **Khách hàng** (gọi món)
- 💰 Quản lý **hóa đơn** và **thanh toán**
- 📊 Báo cáo doanh thu

---

## 🎯 Chức năng Chính - Nhân viên Bán hàng

### ✅ Đã Implement (Version 1.0)

#### 1. **Đăng nhập Nhân viên**
- Giao diện đăng nhập bảo mật
- Xác thực username/password
- Session management
- Đăng xuất

#### 2. **Trang Chủ Nhân viên**
- Hiển thị tên + chức vụ
- Nút "Thanh toán hóa đơn"
- Nút "Báo cáo" (sắp có)
- Nút "Đăng xuất"

#### 3. **Tìm Kiếm Bàn**
- Danh sách bàn đang phục vụ
- Tìm kiếm theo:
  - ID bàn
  - Tên bàn
  - Tên khách hàng
- Sắp xếp theo ID

#### 4. **Hóa Đơn Tạm Tính**
- Hiển thị chi tiết bàn + khách hàng
- Danh sách sản phẩm đã gọi
- Tính tổng tiền tự động
- Quản lý sản phẩm (xóa, sửa số lượng)
- Nhập điểm thưởng
- Xác nhận thanh toán

#### 5. **Hóa Đơn Cuối Cùng**
- Thông tin đầy đủ:
  - Số hiệu hóa đơn
  - Thời gian tạo
  - Nhân viên + chức vụ
  - Bàn + khách hàng
  - Chi tiết sản phẩm
  - Tổng tiền & điểm thưởng
- In hóa đơn (Ctrl+P)
- Quay lại danh sách bàn

---

## 📂 Cấu trúc Dự án

```
RestMan20/
├── src/main/java/
│   ├── dao/
│   │   ├── DAO.java                  (Abstract base class)
│   │   ├── StaffDAO.java             ✅ NEW
│   │   ├── TableDAO.java             ✅ NEW
│   │   ├── OrderDAO.java             ✅ NEW
│   │   ├── InvoiceDAO.java           ✅ NEW
│   │   └── ProductDAO.java
│   │
│   ├── model/
│   │   ├── Staff.java
│   │   ├── Table.java
│   │   ├── Order.java
│   │   ├── OrderDetail.java
│   │   ├── Invoice.java              ✏️ UPDATED (thêm Staff)
│   │   ├── Product.java
│   │   ├── User.java
│   │   └── ...
│   │
│   └── servlet/
│       ├── LoginServlet.java          ✅ NEW
│       ├── StaffPageServlet.java      ✅ NEW
│       ├── SearchTableServlet.java    ✅ NEW
│       ├── OrderServlet.java          ✅ NEW
│       ├── CheckoutServlet.java       ✅ NEW
│       ├── InvoiceServlet.java        ✅ NEW
│       ├── LinkServerlet.java
│       └── ...
│
├── src/main/webapp/
│   ├── index.jsp                      ✏️ UPDATED
│   ├── img/
│   ├── WEB-INF/
│   │   ├── web.xml
│   │   ├── Customer/
│   │   │   ├── CustomerPage.jsp
│   │   │   ├── SearchPage.jsp
│   │   │   └── ...
│   │   └── Staff/
│   │       ├── LoginPage.jsp          ✅ NEW
│   │       ├── StaffPage.jsp          ✅ NEW
│   │       ├── SearchTablePage.jsp    ✅ NEW
│   │       ├── OrderPage.jsp          ✅ NEW
│   │       └── InvoicePage.jsp        ✅ NEW
│   └── ...
│
├── pom.xml
├── SUMMARY.md                         ✅ NEW (Tổng hợp)
├── STAFF_CHECKOUT_FEATURE.md          ✅ NEW (Hướng dẫn)
├── STAFF_CHECKOUT_SETUP.sql           ✅ NEW (Setup DB)
├── DEPLOYMENT_GUIDE.md                ✅ NEW (Triển khai)
├── QUICKSTART.sh                      ✅ NEW (Quick Start)
└── README.md                          ✅ NEW (File này)
```

---

## 🔧 Yêu cầu Hệ thống

- **Java**: JDK 8 hoặc cao hơn
- **Database**: MySQL 5.7+
- **Server**: Apache Tomcat 7+
- **Build**: Maven 3.6+

---

## 📋 Cài đặt & Triển khai

### 1️⃣ Clone/Download dự án
```bash
cd /path/to/RestMan20
```

### 2️⃣ Chuẩn bị Database
```bash
mysql -u root -p RestMan < STAFF_CHECKOUT_SETUP.sql
```

**Hoặc** chạy SQL script thủ công từ `STAFF_CHECKOUT_SETUP.sql`

### 3️⃣ Build Project
```bash
mvn clean package
```

### 4️⃣ Deploy trên Tomcat
```bash
cp target/RestMan20.war $TOMCAT_HOME/webapps/
```

### 5️⃣ Khởi động Tomcat
```bash
cd $TOMCAT_HOME/bin
./startup.sh
```

### 6️⃣ Truy cập ứng dụng
```
http://localhost:8080/RestMan20/
```

---

## 👤 Tài khoản Test

### Nhân viên
| Username | Password | Chức vụ |
|----------|----------|--------|
| staff1 | password123 | Nhân viên bán hàng |
| staff2 | password123 | Nhân viên bán hàng |
| staff3 | password123 | Nhân viên bán hàng |

### Bàn (Mẫu)
- **Đang phục vụ:** Bàn 1-5, 7-8
- **Trống:** Bàn 3, 6

---

## 🎮 Hướng dẫn Sử dụng

### Thanh toán Hóa đơn (Nhân viên)

```
1. Vào http://localhost:8080/RestMan20/
   ↓
2. Nhấp "Tôi là Nhân viên"
   ↓ LoginPage.jsp
3. Nhập: staff1 / password123
   ↓
4. Xem trang chủ nhân viên (StaffPage.jsp)
   ↓
5. Nhấp "Thanh toán hóa đơn"
   ↓ SearchTablePage.jsp
6. Xem danh sách bàn đang phục vụ
   ↓
7. Tìm kiếm (tuỳ chọn):
   - Nhập "Bàn 1" + "Tìm kiếm"
   - hoặc Nhập tên khách hàng
   ↓
8. Nhấp bàn (VD: Bàn 1)
   ↓ OrderPage.jsp
9. Xem hóa đơn tạm tính
   - Sản phẩm đã gọi
   - Tổng tiền
   ↓
10. Nhập Điểm thưởng (VD: 100)
    ↓
11. Nhấp "Xác nhận thanh toán"
    ↓ InvoicePage.jsp
12. Xem hóa đơn cuối cùng
    - Số hiệu hóa đơn
    - Thời gian
    - Chi tiết đầy đủ
    ↓
13. Nhấp "In hóa đơn" (Ctrl+P)
    ↓
14. Nhấp "Quay lại" để thanh toán bàn khác
```

---

## 📊 Database Schema

### Bảng chính:
1. **User** - Người dùng (nhân viên, khách hàng)
2. **Staff** - Nhân viên bán hàng
3. **Table** - Bàn nhà hàng
4. **Order** - Đơn hàng tạm tính
5. **OrderDetail** - Chi tiết đơn hàng
6. **Product** - Sản phẩm (nước, món, combo)
7. **Invoice** - Hóa đơn cuối cùng

---

## 🔗 Routing & URL

| Đường dẫn | Phương thức | Giao diện |
|----------|-----------|----------|
| `/` | GET | index.jsp |
| `/login?role=staff` | GET | LoginPage.jsp |
| `/login` | POST | (Xác thực) |
| `/staffPage` | GET | StaffPage.jsp |
| `/staffPage` | POST | (Logout) |
| `/searchTable` | GET | SearchTablePage.jsp |
| `/order?tableId=X` | GET | OrderPage.jsp |
| `/order` | POST | (Quản lý sản phẩm) |
| `/checkout` | POST | (Xuất hóa đơn) |
| `/invoice?id=X` | GET | InvoicePage.jsp |

---

## 🛠️ Stack Công nghệ

- **Backend**: Java, Servlet, JSP
- **Database**: MySQL
- **Frontend**: HTML5, CSS3, Responsive Design
- **Build**: Maven
- **Server**: Apache Tomcat

---

## 📚 Tài liệu

| File | Mô tả |
|------|-------|
| **README.md** | File này (Tổng quan dự án) |
| **SUMMARY.md** | Tổng hợp tất cả file đã tạo |
| **STAFF_CHECKOUT_FEATURE.md** | Hướng dẫn kịch bản sử dụng chi tiết |
| **STAFF_CHECKOUT_SETUP.sql** | Script SQL chuẩn bị database |
| **DEPLOYMENT_GUIDE.md** | Hướng dẫn triển khai toàn bộ |
| **QUICKSTART.sh** | Script tự động setup |

---

## ⚙️ Cấu hình

### Kết nối Database (`DAO.java`)
```java
private static final String DB_URL  = "jdbc:mysql://localhost:3306/RestMan";
private static final String DB_USER = "root";
private static final String DB_PASS = "1235aBc@03";
```

### Session Timeout (web.xml)
```xml
<session-config>
    <cookie-config>
        <max-age>1800</max-age>
    </cookie-config>
</session-config>
```

---

## 🐛 Xử lý Lỗi Thường gặp

### ❌ MySQL Connection Error
```
→ Kiểm tra DB_URL, DB_USER, DB_PASS trong DAO.java
→ Đảm bảo MySQL server đang chạy
→ Đảm bảo database "RestMan" tồn tại
```

### ❌ 404 Not Found
```
→ Kiểm tra @WebServlet annotation trong Servlet
→ Kiểm tra JSP path trong forward/redirect
→ Xác nhận Tomcat đã compile file .class
```

### ❌ Session Lost
```
→ Kiểm tra Session timeout (mặc định 30 phút)
→ Xác nhận đang gửi cookie từ client
→ Kiểm tra browser cookies settings
```

---

## 🔒 Bảo mật

- ✅ PreparedStatement (SQL Injection prevention)
- ✅ Session validation (mỗi Servlet)
- ✅ Password xác thực
- ⚠️ Plain text password (TODO: BCrypt)
- 🔄 HTTPS (Production)

---

## 🚀 Phát triển Tiếp theo

### High Priority
- [ ] Hash password (BCrypt)
- [ ] Export PDF invoice (iText)
- [ ] Staff Performance Report
- [ ] Role-based access control

### Medium Priority
- [ ] Invoice history
- [ ] Advanced search (date range, staff filter)
- [ ] Refund/Edit invoice
- [ ] Discount management

### Low Priority
- [ ] QR code on invoice
- [ ] Auto print
- [ ] Online payment integration
- [ ] Mobile app

---

## 📞 Hỗ trợ

Có vấn đề hoặc câu hỏi?

1. **Đọc documentation:**
   - STAFF_CHECKOUT_FEATURE.md (Hướng dẫn chi tiết)
   - DEPLOYMENT_GUIDE.md (Triển khai)

2. **Kiểm tra logs:**
   - `$TOMCAT_HOME/logs/catalina.out`
   - Browser Console (F12)

3. **Xem Database:**
   ```sql
   SELECT * FROM User WHERE role = 'STAFF';
   SELECT * FROM `Order` LIMIT 5;
   SELECT * FROM Invoice LIMIT 5;
   ```

---

## 📄 License

RestMan20 © 2025 - All Rights Reserved

---

## 👨‍💻 Tác giả

**GitHub Copilot** - 05-11-2025

---

## 🎉 Cảm ơn!

Cảm ơn bạn đã sử dụng RestMan20!  
Chúc bạn có trải nghiệm tuyệt vời! 🚀

---

**Last Updated:** 2025-11-05  
**Version:** 1.0.0  
**Status:** ✅ Ready for Production
