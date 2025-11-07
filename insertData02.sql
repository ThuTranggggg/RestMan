/* -----------------------------
   1) THÊM 10 KHÁCH HÀNG (5 CÓ THẺ)
   ----------------------------- */
-- Users (role = CUSTOMER)
INSERT INTO tblUser (fullName, phone, email, username, password, role) VALUES
('Nguyễn Văn An',    '0902123456', 'an.nguyen+101@gmail.com',  'cust101', '123456', 'CUSTOMER'),
('Trần Thị Bình',    '0903123456', 'binh.tran+102@gmail.com',  'cust102', '123456', 'CUSTOMER'),
('Lê Hoàng Phúc',    '0904123456', 'phuc.le+103@gmail.com',    'cust103', '123456', 'CUSTOMER'),
('Phạm Thu Hà',      '0905123456', 'ha.pham+104@gmail.com',    'cust104', '123456', 'CUSTOMER'),
('Vũ Minh Quân',     '0906123456', 'quan.vu+105@gmail.com',    'cust105', '123456', 'CUSTOMER'),
('Đỗ Hải Yến',       '0907123456', 'yen.do+106@gmail.com',     'cust106', '123456', 'CUSTOMER'),
('Bùi Thanh Tùng',   '0908123456', 'tung.bui+107@gmail.com',   'cust107', '123456', 'CUSTOMER'),
('Hoàng Thị Mai',    '0909123456', 'mai.hoang+108@gmail.com',  'cust108', '123456', 'CUSTOMER'),
('Phan Quốc Khánh',  '0910123456', 'khanh.phan+109@gmail.com', 'cust109', '123456', 'CUSTOMER'),
('Ngô Thùy Dung',    '0911123456', 'dung.ngo+110@gmail.com',   'cust110', '123456', 'CUSTOMER');

-- 5 thẻ thành viên cho 5 khách đầu
INSERT INTO tblMemberCard (point, issueDate) VALUES (10, CURDATE()); SET @mc101 = LAST_INSERT_ID();
INSERT INTO tblMemberCard (point, issueDate) VALUES (20, CURDATE()); SET @mc102 = LAST_INSERT_ID();
INSERT INTO tblMemberCard (point, issueDate) VALUES (30, CURDATE()); SET @mc103 = LAST_INSERT_ID();
INSERT INTO tblMemberCard (point, issueDate) VALUES (40, CURDATE()); SET @mc104 = LAST_INSERT_ID();
INSERT INTO tblMemberCard (point, issueDate) VALUES (50, CURDATE()); SET @mc105 = LAST_INSERT_ID();

-- Map vào bảng Customer (5 có thẻ, 5 không)
INSERT INTO tblCustomer (tblUserid, tblMemberCardid) VALUES
((SELECT id FROM tblUser WHERE username='cust101'), @mc101),
((SELECT id FROM tblUser WHERE username='cust102'), @mc102),
((SELECT id FROM tblUser WHERE username='cust103'), @mc103),
((SELECT id FROM tblUser WHERE username='cust104'), @mc104),
((SELECT id FROM tblUser WHERE username='cust105'), @mc105),
((SELECT id FROM tblUser WHERE username='cust106'), NULL),
((SELECT id FROM tblUser WHERE username='cust107'), NULL),
((SELECT id FROM tblUser WHERE username='cust108'), NULL),
((SELECT id FROM tblUser WHERE username='cust109'), NULL),
((SELECT id FROM tblUser WHERE username='cust110'), NULL);

/* -----------------------------
   2) THÊM 20 BÀN MỚI (21 → 40)
   ----------------------------- */
INSERT INTO tblTable (name, status, description) VALUES
('Bàn 21', 0, 'Bàn 2 chỗ'),
('Bàn 22', 0, 'Bàn 2 chỗ'),
('Bàn 23', 0, 'Bàn 2 chỗ'),
('Bàn 24', 0, 'Bàn 2 chỗ'),
('Bàn 25', 0, 'Bàn 2 chỗ'),
('Bàn 26', 0, 'Bàn 4 chỗ'),
('Bàn 27', 0, 'Bàn 4 chỗ'),
('Bàn 28', 0, 'Bàn 4 chỗ'),
('Bàn 29', 0, 'Bàn 4 chỗ'),
('Bàn 30', 0, 'Bàn 4 chỗ'),
('Bàn 31', 0, 'Bàn 6 chỗ'),
('Bàn 32', 0, 'Bàn 6 chỗ'),
('Bàn 33', 0, 'Bàn 6 chỗ'),
('Bàn 34', 0, 'Bàn 6 chỗ'),
('Bàn 35', 0, 'Bàn 6 chỗ'),
('Bàn 36', 0, 'Bàn 8 chỗ'),
('Bàn 37', 0, 'Bàn 8 chỗ'),
('Bàn 38', 0, 'Bàn 8 chỗ'),
('Bàn 39', 0, 'Bàn 8 chỗ'),
('Bàn 40', 0, 'Bàn 8 chỗ');

/* ---------------------------------------------------
   3) 10 ĐƠN HÀNG (BÀN 21 → 30), MỖI ĐƠN > 5 MÓN/COMBO
      - Đặt status=1 cho bàn có đơn để "đang sử dụng"
      - Mỗi đơn trộn DISH/DRINK/COMBO để test UI
   --------------------------------------------------- */
UPDATE tblTable SET status = 1 WHERE id BETWEEN 21 AND 30;

-- Hỗ trợ: hàm chèn 1 dòng chi tiết qua tên sản phẩm
-- (Viết dưới dạng các INSERT ... SELECT theo tên từng món)

-- Bàn 21 - khách cust101
INSERT INTO tblOrder (tblCustomertblUserid, tblTableid)
VALUES ((SELECT id FROM tblUser WHERE username='cust101'), 21);
SET @o21 = LAST_INSERT_ID();
INSERT INTO tblOrderDetail (quantity, tblProductid, tblOrderid)
SELECT 2, id, @o21 FROM tblProduct WHERE name='Bún Chả Hà Nội' AND type='DISH';
INSERT INTO tblOrderDetail (quantity, tblProductid, tblOrderid)
SELECT 2, id, @o21 FROM tblProduct WHERE name='Cà Phê Sữa Đá' AND type='DRINK';
INSERT INTO tblOrderDetail (quantity, tblProductid, tblOrderid)
SELECT 1, id, @o21 FROM tblProduct WHERE name='Combo Bạn Bè' AND type='COMBO';
INSERT INTO tblOrderDetail (quantity, tblProductid, tblOrderid)
SELECT 1, id, @o21 FROM tblProduct WHERE name='Bánh Cuốn Nóng' AND type='DISH';
INSERT INTO tblOrderDetail (quantity, tblProductid, tblOrderid)
SELECT 1, id, @o21 FROM tblProduct WHERE name='Bạc Xỉu' AND type='DRINK';
INSERT INTO tblOrderDetail (quantity, tblProductid, tblOrderid)
SELECT 1, id, @o21 FROM tblProduct WHERE name='Nem Nướng Nha Trang' AND type='DISH';

-- Bàn 22 - cust102
INSERT INTO tblOrder (tblCustomertblUserid, tblTableid)
VALUES ((SELECT id FROM tblUser WHERE username='cust102'), 22);
SET @o22 = LAST_INSERT_ID();
INSERT INTO tblOrderDetail (quantity, tblProductid, tblOrderid)
SELECT 1, id, @o22 FROM tblProduct WHERE name='Combo Trưa Nhanh' AND type='COMBO';
INSERT INTO tblOrderDetail (quantity, tblProductid, tblOrderid)
SELECT 3, id, @o22 FROM tblProduct WHERE name='Trà Tắc Mật Ong' AND type='DRINK';
INSERT INTO tblOrderDetail (quantity, tblProductid, tblOrderid)
SELECT 2, id, @o22 FROM tblProduct WHERE name='Bún Riêu Cua' AND type='DISH';
INSERT INTO tblOrderDetail (quantity, tblProductid, tblOrderid)
SELECT 1, id, @o22 FROM tblProduct WHERE name='Cà Phê Trứng Hà Nội' AND type='DRINK';
INSERT INTO tblOrderDetail (quantity, tblProductid, tblOrderid)
SELECT 1, id, @o22 FROM tblProduct WHERE name='Bánh Xèo Miền Tây' AND type='DISH';
INSERT INTO tblOrderDetail (quantity, tblProductid, tblOrderid)
SELECT 1, id, @o22 FROM tblProduct WHERE name='Gỏi Cuốn Tôm Thịt' AND type='DISH';

-- Bàn 23 - cust103
INSERT INTO tblOrder (tblCustomertblUserid, tblTableid)
VALUES ((SELECT id FROM tblUser WHERE username='cust103'), 23);
SET @o23 = LAST_INSERT_ID();
INSERT INTO tblOrderDetail (quantity, tblProductid, tblOrderid)
SELECT 1, id, @o23 FROM tblProduct WHERE name='Combo Đặc Sản Hà Nội' AND type='COMBO';
INSERT INTO tblOrderDetail (quantity, tblProductid, tblOrderid)
SELECT 2, id, @o23 FROM tblProduct WHERE name='Bún Bò Huế' AND type='DISH';
INSERT INTO tblOrderDetail (quantity, tblProductid, tblOrderid)
SELECT 2, id, @o23 FROM tblProduct WHERE name='Cà Phê Đen Đá' AND type='DRINK';
INSERT INTO tblOrderDetail (quantity, tblProductid, tblOrderid)
SELECT 1, id, @o23 FROM tblProduct WHERE name='Chả Cá Lã Vọng' AND type='DISH';
INSERT INTO tblOrderDetail (quantity, tblProductid, tblOrderid)
SELECT 1, id, @o23 FROM tblProduct WHERE name='Bánh Ướt Thịt Nướng' AND type='DISH';
INSERT INTO tblOrderDetail (quantity, tblProductid, tblOrderid)
SELECT 1, id, @o23 FROM tblProduct WHERE name='Rau Má Đậu Xanh' AND type='DRINK';

-- Bàn 24 - cust104
INSERT INTO tblOrder (tblCustomertblUserid, tblTableid)
VALUES ((SELECT id FROM tblUser WHERE username='cust104'), 24);
SET @o24 = LAST_INSERT_ID();
INSERT INTO tblOrderDetail (quantity, tblProductid, tblOrderid)
SELECT 1, id, @o24 FROM tblProduct WHERE name='Combo 4 Món Bắc' AND type='COMBO';
INSERT INTO tblOrderDetail (quantity, tblProductid, tblOrderid)
SELECT 2, id, @o24 FROM tblProduct WHERE name='Bánh Cuốn Nóng' AND type='DISH';
INSERT INTO tblOrderDetail (quantity, tblProductid, tblOrderid)
SELECT 2, id, @o24 FROM tblProduct WHERE name='Sữa Đậu Nành Nóng' AND type='DRINK';
INSERT INTO tblOrderDetail (quantity, tblProductid, tblOrderid)
SELECT 1, id, @o24 FROM tblProduct WHERE name='Bún Mọc' AND type='DISH';
INSERT INTO tblOrderDetail (quantity, tblProductid, tblOrderid)
SELECT 1, id, @o24 FROM tblProduct WHERE name='Cà Phê Sữa Đá' AND type='DRINK';
INSERT INTO tblOrderDetail (quantity, tblProductid, tblOrderid)
SELECT 1, id, @o24 FROM tblProduct WHERE name='Bánh Canh Cua' AND type='DISH';

-- Bàn 25 - cust105
INSERT INTO tblOrder (tblCustomertblUserid, tblTableid)
VALUES ((SELECT id FROM tblUser WHERE username='cust105'), 25);
SET @o25 = LAST_INSERT_ID();
INSERT INTO tblOrderDetail (quantity, tblProductid, tblOrderid)
SELECT 1, id, @o25 FROM tblProduct WHERE name='Combo Miền Trung' AND type='COMBO';
INSERT INTO tblOrderDetail (quantity, tblProductid, tblOrderid)
SELECT 2, id, @o25 FROM tblProduct WHERE name='Mì Quảng Gà' AND type='DISH';
INSERT INTO tblOrderDetail (quantity, tblProductid, tblOrderid)
SELECT 1, id, @o25 FROM tblProduct WHERE name='Cao Lầu Hội An' AND type='DISH';
INSERT INTO tblOrderDetail (quantity, tblProductid, tblOrderid)
SELECT 2, id, @o25 FROM tblProduct WHERE name='Trà Tắc Mật Ong' AND type='DRINK';
INSERT INTO tblOrderDetail (quantity, tblProductid, tblOrderid)
SELECT 1, id, @o25 FROM tblProduct WHERE name='Cà Phê Đen Đá' AND type='DRINK';
INSERT INTO tblOrderDetail (quantity, tblProductid, tblOrderid)
SELECT 1, id, @o25 FROM tblProduct WHERE name='Bánh Tráng Trộn' AND type='DISH';

-- Bàn 26 - cust106
INSERT INTO tblOrder (tblCustomertblUserid, tblTableid)
VALUES ((SELECT id FROM tblUser WHERE username='cust106'), 26);
SET @o26 = LAST_INSERT_ID();
INSERT INTO tblOrderDetail (quantity, tblProductid, tblOrderid)
SELECT 1, id, @o26 FROM tblProduct WHERE name='Combo Lẩu Hải Sản' AND type='COMBO';
INSERT INTO tblOrderDetail (quantity, tblProductid, tblOrderid)
SELECT 1, id, @o26 FROM tblProduct WHERE name='Lẩu Thái Hải Sản' AND type='DISH';
INSERT INTO tblOrderDetail (quantity, tblProductid, tblOrderid)
SELECT 2, id, @o26 FROM tblProduct WHERE name='Bánh Bèo Chén' AND type='DISH';
INSERT INTO tblOrderDetail (quantity, tblProductid, tblOrderid)
SELECT 2, id, @o26 FROM tblProduct WHERE name='Sâm Bổ Lượng' AND type='DRINK';
INSERT INTO tblOrderDetail (quantity, tblProductid, tblOrderid)
SELECT 2, id, @o26 FROM tblProduct WHERE name='Cà Phê Sữa Đá' AND type='DRINK';
INSERT INTO tblOrderDetail (quantity, tblProductid, tblOrderid)
SELECT 1, id, @o26 FROM tblProduct WHERE name='Bánh Mì' AND type='DISH'; -- nếu không có 'Bánh Mì', thay bằng 'Bò Kho Bánh Mì'
-- fallback an toàn:
INSERT INTO tblOrderDetail (quantity, tblProductid, tblOrderid)
SELECT 1, id, @o26 FROM tblProduct WHERE name='Bò Kho Bánh Mì' AND type='DISH';

-- Bàn 27 - cust107
INSERT INTO tblOrder (tblCustomertblUserid, tblTableid)
VALUES ((SELECT id FROM tblUser WHERE username='cust107'), 27);
SET @o27 = LAST_INSERT_ID();
INSERT INTO tblOrderDetail (quantity, tblProductid, tblOrderid)
SELECT 1, id, @o27 FROM tblProduct WHERE name='Combo Gia Đình' AND type='COMBO';
INSERT INTO tblOrderDetail (quantity, tblProductid, tblOrderid)
SELECT 2, id, @o27 FROM tblProduct WHERE name='Cơm Tấm Sườn Bì Chả' AND type='DISH';
INSERT INTO tblOrderDetail (quantity, tblProductid, tblOrderid)
SELECT 1, id, @o27 FROM tblProduct WHERE name='Canh Chua Cá Lóc' AND type='DISH';
INSERT INTO tblOrderDetail (quantity, tblProductid, tblOrderid)
SELECT 1, id, @o27 FROM tblProduct WHERE name='Bánh Xèo Miền Tây' AND type='DISH';
INSERT INTO tblOrderDetail (quantity, tblProductid, tblOrderid)
SELECT 2, id, @o27 FROM tblProduct WHERE name='Nước Mía Tắc' AND type='DRINK';
INSERT INTO tblOrderDetail (quantity, tblProductid, tblOrderid)
SELECT 1, id, @o27 FROM tblProduct WHERE name='Gỏi Cuốn Tôm Thịt' AND type='DISH';

-- Bàn 28 - cust108
INSERT INTO tblOrder (tblCustomertblUserid, tblTableid)
VALUES ((SELECT id FROM tblUser WHERE username='cust108'), 28);
SET @o28 = LAST_INSERT_ID();
INSERT INTO tblOrderDetail (quantity, tblProductid, tblOrderid)
SELECT 1, id, @o28 FROM tblProduct WHERE name='Combo Đôi Quán Nhà' AND type='COMBO';
INSERT INTO tblOrderDetail (quantity, tblProductid, tblOrderid)
SELECT 2, id, @o28 FROM tblProduct WHERE name='Hủ Tiếu Nam Vang' AND type='DISH';
INSERT INTO tblOrderDetail (quantity, tblProductid, tblOrderid)
SELECT 2, id, @o28 FROM tblProduct WHERE name='Gà Kho Gừng' AND type='DISH';
INSERT INTO tblOrderDetail (quantity, tblProductid, tblOrderid)
SELECT 3, id, @o28 FROM tblProduct WHERE name='Cà Phê Đen Đá' AND type='DRINK';
INSERT INTO tblOrderDetail (quantity, tblProductid, tblOrderid)
SELECT 1, id, @o28 FROM tblProduct WHERE name='Bạc Xỉu' AND type='DRINK';
INSERT INTO tblOrderDetail (quantity, tblProductid, tblOrderid)
SELECT 1, id, @o28 FROM tblProduct WHERE name='Bún Thịt Nướng' AND type='DISH';

-- Bàn 29 - cust109
INSERT INTO tblOrder (tblCustomertblUserid, tblTableid)
VALUES ((SELECT id FROM tblUser WHERE username='cust109'), 29);
SET @o29 = LAST_INSERT_ID();
INSERT INTO tblOrderDetail (quantity, tblProductid, tblOrderid)
SELECT 1, id, @o29 FROM tblProduct WHERE name='Combo Healthy Nhẹ Nhàng' AND type='COMBO';
INSERT INTO tblOrderDetail (quantity, tblProductid, tblOrderid)
SELECT 2, id, @o29 FROM tblProduct WHERE name='Gỏi Cuốn Tôm Thịt' AND type='DISH';
INSERT INTO tblOrderDetail (quantity, tblProductid, tblOrderid)
SELECT 1, id, @o29 FROM tblProduct WHERE name='Cháo Gà Hành Phi' AND type='DISH';
INSERT INTO tblOrderDetail (quantity, tblProductid, tblOrderid)
SELECT 2, id, @o29 FROM tblProduct WHERE name='Sữa Đậu Nành Nóng' AND type='DRINK';
INSERT INTO tblOrderDetail (quantity, tblProductid, tblOrderid)
SELECT 1, id, @o29 FROM tblProduct WHERE name='Rau Má Đậu Xanh' AND type='DRINK';
INSERT INTO tblOrderDetail (quantity, tblProductid, tblOrderid)
SELECT 1, id, @o29 FROM tblProduct WHERE name='Xôi Gà Lá Sen' AND type='DISH';

-- Bàn 30 - cust110
INSERT INTO tblOrder (tblCustomertblUserid, tblTableid)
VALUES ((SELECT id FROM tblUser WHERE username='cust110'), 30);
SET @o30 = LAST_INSERT_ID();
INSERT INTO tblOrderDetail (quantity, tblProductid, tblOrderid)
SELECT 1, id, @o30 FROM tblProduct WHERE name='Combo Ăn Vặt Cuối Tuần' AND type='COMBO';
INSERT INTO tblOrderDetail (quantity, tblProductid, tblOrderid)
SELECT 1, id, @o30 FROM tblProduct WHERE name='Bánh Tráng Trộn' AND type='DISH';
INSERT INTO tblOrderDetail (quantity, tblProductid, tblOrderid)
SELECT 1, id, @o30 FROM tblProduct WHERE name='Ốc Len Xào Dừa' AND type='DISH';
INSERT INTO tblOrderDetail (quantity, tblProductid, tblOrderid)
SELECT 2, id, @o30 FROM tblProduct WHERE name='Trà Tắc Mật Ong' AND type='DRINK';
INSERT INTO tblOrderDetail (quantity, tblProductid, tblOrderid)
SELECT 2, id, @o30 FROM tblProduct WHERE name='Cà Phê Sữa Đá' AND type='DRINK';
INSERT INTO tblOrderDetail (quantity, tblProductid, tblOrderid)
SELECT 1, id, @o30 FROM tblProduct WHERE name='Bánh Canh Cua' AND type='DISH';
