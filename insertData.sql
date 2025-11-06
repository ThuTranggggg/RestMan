SET FOREIGN_KEY_CHECKS = 0;

-- =============================
-- USERS (3 STAFF + 3 CUSTOMER)
-- =============================
INSERT INTO tblUser (fullName, phone, email, username, password, role) VALUES
('Trần Minh Khang', '0906666666', 'khang.tm@restman.com', 'staff001', '123456', 'STAFF'),   -- id = 1
('Ngô Thị Lan',     '0907777777', 'lan.nt@restman.com',   'staff002', '123456', 'STAFF'),   -- id = 2
('Phạm Đức Huy',    '0908888888', 'huy.pd@restman.com',   'staff003', '123456', 'STAFF'),   -- id = 3
('Nguyễn Thị Mai',  '0909999999', 'mai.nt@gmail.com',     'cust001',  '123456', 'CUSTOMER'),-- id = 4
('Lê Hoàng Nam',    '0910000000', 'nam.lh@gmail.com',     'cust002',  '123456', 'CUSTOMER'),-- id = 5
('Phan Thanh Tùng', '0911111111', 'tung.pt@gmail.com',    'cust003',  '123456', 'CUSTOMER');-- id = 6

-- =============================
-- STAFF ROLES (map đúng id 1-3)
-- =============================
INSERT INTO tblStaff (tblUserId, position) VALUES
(1, 'Manager'),
(2, 'Server'),
(3, 'Stock Clerk');

INSERT INTO tblManager (tblStafftblUserId) VALUES (1);
INSERT INTO tblServer  (tblStafftblUserId) VALUES (2);
INSERT INTO tblStockClerk (tblStafftblUserId) VALUES (3);

-- =============================
-- MEMBER CARD + CUSTOMER
-- =============================
INSERT INTO tblMemberCard (point, issueDate) VALUES (0, CURDATE());
INSERT INTO tblCustomer (tblUserid, tblMemberCardid) VALUES (4, 1); -- cust001 gắn thẻ #1

-- =============================
-- TABLES
-- =============================
INSERT INTO tblTable (name, status, description) VALUES
('Bàn 1', 0, 'Bàn 2 chỗ'),
('Bàn 2', 0, 'Bàn 2 chỗ'),
('Bàn 3', 0, 'Bàn 2 chỗ'),
('Bàn 4', 0, 'Bàn 2 chỗ'),
('Bàn 5', 0, 'Bàn 2 chỗ'),
('Bàn 6', 0, 'Bàn 4 chỗ'),
('Bàn 7', 0, 'Bàn 4 chỗ'),
('Bàn 8', 0, 'Bàn 4 chỗ'),
('Bàn 9', 0, 'Bàn 4 chỗ'),
('Bàn 10', 0, 'Bàn 4 chỗ'),
('Bàn 11', 0, 'Bàn 6 chỗ'),
('Bàn 12', 0, 'Bàn 6 chỗ'),
('Bàn 13', 0, 'Bàn 6 chỗ'),
('Bàn 14', 0, 'Bàn 6 chỗ'),
('Bàn 15', 0, 'Bàn 6 chỗ'),
('Bàn 16', 0, 'Bàn 8 chỗ'),
('Bàn 17', 0, 'Bàn 8 chỗ'),
('Bàn 18', 0, 'Bàn 8 chỗ'),
('Bàn 19', 0, 'Bàn 8 chỗ'),
('Bàn 20', 0, 'Bàn 8 chỗ');

-- =============================
-- PRODUCTS (KHÔNG có cột sold)
-- =============================
-- 30 món ăn (type='DISH')
INSERT INTO tblProduct (name, description, price, type, imageUrl, status) VALUES
('Bún Chả Hà Nội', 'Thịt nướng thơm lừng, bún trắng và nước chấm chua ngọt cân bằng.', 55000, 'DISH', 'F:/Semester7/PhanTichThietKe/RestMan20/src/main/webapp/img/bunCha.png', 1),
('Bún Riêu Cua', 'Nước dùng thanh, gạch cua béo nhẹ, cà chua ngọt dịu.', 48000, 'DISH', 'F:/Semester7/PhanTichThietKe/RestMan20/src/main/webapp/img/bunCha.png', 1),
('Bún Đậu Mắm Tôm', 'Đậu rán vàng giòn, thịt chấm mắm tôm dậy vị, rau thơm mát.', 45000, 'DISH', 'F:/Semester7/PhanTichThietKe/RestMan20/src/main/webapp/img/bunCha.png', 1),
('Bánh Xèo Miền Tây', 'Vỏ giòn rụm, nhân tôm thịt, ăn kèm rau sống và nước mắm pha.', 60000, 'DISH', 'F:/Semester7/PhanTichThietKe/RestMan20/src/main/webapp/img/bunCha.png', 1),
('Bánh Cuốn Nóng', 'Bánh mỏng mềm, hành phi thơm, chả lụa và nước chấm ấm.', 42000, 'DISH', 'F:/Semester7/PhanTichThietKe/RestMan20/src/main/webapp/img/bunCha.png', 1),
('Gỏi Cuốn Tôm Thịt', 'Cuốn nhẹ thanh, tôm tươi, chấm tương bùi béo.', 38000, 'DISH', 'F:/Semester7/PhanTichThietKe/RestMan20/src/main/webapp/img/bunCha.png', 1),
('Bò Kho Bánh Mì', 'Nước sốt đậm đà hương quế hồi, thịt bò mềm rục.', 65000, 'DISH', 'F:/Semester7/PhanTichThietKe/RestMan20/src/main/webapp/img/bunCha.png', 1),
('Cá Kho Tộ', 'Cá thấm vị, nước kho kẹo nhẹ, đưa cơm hết sẩy.', 75000, 'DISH', 'F:/Semester7/PhanTichThietKe/RestMan20/src/main/webapp/img/bunCha.png', 1),
('Canh Chua Cá Lóc', 'Chua ngọt hài hòa, thơm bạc hà, ngò om dậy mùi.', 59000, 'DISH', 'F:/Semester7/PhanTichThietKe/RestMan20/src/main/webapp/img/bunCha.png', 1),
('Hủ Tiếu Nam Vang', 'Sợi hủ tiếu trong, nước dùng thanh, tôm thịt đầy đặn.', 52000, 'DISH', 'F:/Semester7/PhanTichThietKe/RestMan20/src/main/webapp/img/bunCha.png', 1),

('Bún Bò Huế', 'Vị cay nhẹ, sả thơm, chả bò và giò heo hấp dẫn.', 60000, 'DISH', 'F:/Semester7/PhanTichThietKe/RestMan20/src/main/webapp/img/bunRieu.png', 1),
('Mì Quảng Gà', 'Nghệ vàng thơm, đậu phộng bùi, giòn bánh tráng mè.', 55000, 'DISH', 'F:/Semester7/PhanTichThietKe/RestMan20/src/main/webapp/img/bunRieu.png', 1),
('Cao Lầu Hội An', 'Sợi mì dai nhẹ, heo xá xíu, rau sống Trà Quế tươi.', 65000, 'DISH', 'F:/Semester7/PhanTichThietKe/RestMan20/src/main/webapp/img/bunRieu.png', 1),
('Cơm Tấm Sườn Bì Chả', 'Sườn nướng mật ong, mỡ hành xanh, đồ chua cân vị.', 62000, 'DISH', 'F:/Semester7/PhanTichThietKe/RestMan20/src/main/webapp/img/bunRieu.png', 1),
('Cháo Gà Hành Phi', 'Cháo sánh mịn, gà xé ngọt thịt, hành phi thơm bùi.', 42000, 'DISH', 'F:/Semester7/PhanTichThietKe/RestMan20/src/main/webapp/img/bunRieu.png', 1),
('Nem Nướng Nha Trang', 'Nem nướng than hoa, cuốn bánh tráng kèm xoài xanh.', 70000, 'DISH', 'F:/Semester7/PhanTichThietKe/RestMan20/src/main/webapp/img/bunRieu.png', 1),
('Lẩu Thái Hải Sản', 'Chua cay đậm vị, tôm mực tươi, rau nấm phong phú.', 180000, 'DISH', 'F:/Semester7/PhanTichThietKe/RestMan20/src/main/webapp/img/bunRieu.png', 1),
('Lẩu Bò Nhúng Dấm', 'Thịt bò mềm, nước dấm thanh, rau sống cuốn bánh tráng.', 195000, 'DISH', 'F:/Semester7/PhanTichThietKe/RestMan20/src/main/webapp/img/bunRieu.png', 1),
('Ốc Len Xào Dừa', 'Béo thơm nước cốt dừa, ốc giòn ngọt, chấm bánh mì.', 90000, 'DISH', 'F:/Semester7/PhanTichThietKe/RestMan20/src/main/webapp/img/bunRieu.png', 1),
('Gà Kho Gừng', 'Thịt gà săn chắc, gừng ấm nồng, cơm trắng đưa vị.', 78000, 'DISH', 'F:/Semester7/PhanTichThietKe/RestMan20/src/main/webapp/img/bunRieu.png', 1),

('Sườn Xào Chua Ngọt', 'Sườn áo sốt chua ngọt óng ả, thơm mè rang.', 85000, 'DISH', 'F:/Semester7/PhanTichThietKe/RestMan20/src/main/webapp/img/bunDau.png', 1),
('Thịt Kho Trứng', 'Vị đậm đà, trứng béo bùi, nồi cơm vơi nhanh.', 78000, 'DISH', 'F:/Semester7/PhanTichThietKe/RestMan20/src/main/webapp/img/bunDau.png', 1),
('Bánh Canh Cua', 'Sợi bánh canh dai mềm, thịt cua ngọt, nước sánh.', 69000, 'DISH', 'F:/Semester7/PhanTichThietKe/RestMan20/src/main/webapp/img/bunDau.png', 1),
('Bánh Bèo Chén', 'Bèo mỏng, mỡ hành, tôm cháy bùi, chan nước mắm ấm.', 45000, 'DISH', 'F:/Semester7/PhanTichThietKe/RestMan20/src/main/webapp/img/bunDau.png', 1),
('Bánh Tráng Trộn', 'Mặn ngọt cay hài hòa, mứt tắc thơm lừng.', 30000, 'DISH', 'F:/Semester7/PhanTichThietKe/RestMan20/src/main/webapp/img/bunDau.png', 1),
('Bún Thịt Nướng', 'Thịt nướng than thơm, đồ chua giòn, mắm nêm đậm vị.', 52000, 'DISH', 'F:/Semester7/PhanTichThietKe/RestMan20/src/main/webapp/img/bunDau.png', 1),
('Xôi Gà Lá Sen', 'Xôi dẻo thơm, gà xé đậm đà, thoang thoảng lá sen.', 48000, 'DISH', 'F:/Semester7/PhanTichThietKe/RestMan20/src/main/webapp/img/bunDau.png', 1),
('Bánh Ướt Thịt Nướng', 'Bánh ướt mềm, thịt nướng thơm, mắm nêm hài hòa.', 49000, 'DISH', 'F:/Semester7/PhanTichThietKe/RestMan20/src/main/webapp/img/bunDau.png', 1),
('Chả Cá Lã Vọng', 'Cá ướp riềng mẻ, thì là, ăn kèm bún và mắm tôm.', 125000, 'DISH', 'F:/Semester7/PhanTichThietKe/RestMan20/src/main/webapp/img/bunDau.png', 1),
('Bún Mọc', 'Viên mọc heo ngọt thịt, nước trong thanh, nấm hương thơm.', 52000, 'DISH', 'F:/Semester7/PhanTichThietKe/RestMan20/src/main/webapp/img/bunDau.png', 1);

-- 10 đồ uống (type='DRINK')
INSERT INTO tblProduct (name, description, price, type, imageUrl, status) VALUES
('Cà Phê Sữa Đá',       'Đậm đà cà phê rang xay hòa quyện sữa đặc béo ngậy.', 32000, 'DRINK', 'F:/Semester7/PhanTichThietKe/RestMan20/src/main/webapp/img/cafe.png', 1),
('Cà Phê Đen Đá',       'Vị đắng quyến rũ, hậu ngọt nhẹ, tỉnh táo tức thì.',    28000, 'DRINK', 'F:/Semester7/PhanTichThietKe/RestMan20/src/main/webapp/img/cafe.png', 1),
('Bạc Xỉu',             'Sữa ngậy hơn cà phê, thơm dịu, hợp khẩu vị nhẹ nhàng.', 30000, 'DRINK', 'F:/Semester7/PhanTichThietKe/RestMan20/src/main/webapp/img/cafe.png', 1),
('Cà Phê Trứng Hà Nội', 'Lớp kem trứng mịn màng, cà phê ấm thơm lừng.',        45000, 'DRINK', 'F:/Semester7/PhanTichThietKe/RestMan20/src/main/webapp/img/cafe.png', 1),
('CaCao Nóng',          'Sô cô la đậm vị, ấm áp những ngày mưa.',               35000, 'DRINK', 'F:/Semester7/PhanTichThietKe/RestMan20/src/main/webapp/img/cafe.png', 1),
('Nước Mía Tắc',        'Mía ép tươi mát, mùi tắc thơm nhẹ, giải khát tức thì.',22000, 'DRINK', 'F:/Semester7/PhanTichThietKe/RestMan20/src/main/webapp/img/nuocMia.png', 1),
('Trà Tắc Mật Ong',     'Chua ngọt cân bằng, thoang thoảng mật ong ấm.',        25000, 'DRINK', 'F:/Semester7/PhanTichThietKe/RestMan20/src/main/webapp/img/nuocMia.png', 1),
('Sâm Bổ Lượng',        'Mát người thanh nhiệt, nhiều topping truyền thống.',   28000, 'DRINK', 'F:/Semester7/PhanTichThietKe/RestMan20/src/main/webapp/img/nuocMia.png', 1),
('Sữa Đậu Nành Nóng',   'Béo thanh, thơm đậu, dễ uống mọi lúc.',                20000, 'DRINK', 'F:/Semester7/PhanTichThietKe/RestMan20/src/main/webapp/img/nuocMia.png', 1),
('Rau Má Đậu Xanh',     'Mát lạnh, bùi béo đậu xanh, giải nhiệt ngày nắng.',    25000, 'DRINK', 'F:/Semester7/PhanTichThietKe/RestMan20/src/main/webapp/img/nuocMia.png', 1);

-- (Giữ nguyên lệnh chuẩn hóa type cho đồ uống nếu bạn muốn)
UPDATE tblProduct
SET type = 'DRINK'
WHERE name IN (
  'Cà Phê Sữa Đá','Cà Phê Đen Đá','Bạc Xỉu','Cà Phê Trứng Hà Nội','CaCao Nóng',
  'Nước Mía Tắc','Trà Tắc Mật Ong','Sâm Bổ Lượng','Sữa Đậu Nành Nóng','Rau Má Đậu Xanh'
) AND type <> 'COMBO';

-- =============================
-- COMBO PRODUCTS (10 cái)
-- =============================
INSERT INTO tblProduct (name, description, price, type, imageUrl, status) VALUES
('Combo Trưa Nhanh', 'Cơm chiên + Bánh mì thịt nướng + Nước ép trái cây', 120000, 'COMBO', 'F:/Semester7/PhanTichThietKe/RestMan20/src/main/webapp/img/combo01.png', 1),
('Combo Đôi Quán Nhà', 'Phở bò + Gà nướng + Nước ép trái cây', 150000, 'COMBO', 'F:/Semester7/PhanTichThietKe/RestMan20/src/main/webapp/img/combo01.png', 1),
('Combo Bạn Bè', 'Bún chả Hà Nội + Nem nướng Nha Trang + Trà tắc mật ong', 165000, 'COMBO', 'F:/Semester7/PhanTichThietKe/RestMan20/src/main/webapp/img/combo01.png', 1),
('Combo 4 Món Bắc', 'Bún mọc + Chả cá Lã Vọng + Bánh cuốn + Cà phê trứng', 210000, 'COMBO', 'F:/Semester7/PhanTichThietKe/RestMan20/src/main/webapp/img/combo01.png', 1),

('Combo Gia Đình', 'Cơm tấm sườn bì chả + Canh chua cá lóc + Bánh xèo + Nước mía tắc', 235000, 'COMBO', 'F:/Semester7/PhanTichThietKe/RestMan20/src/main/webapp/img/combo02.png', 1),
('Combo Lẩu Hải Sản', 'Lẩu Thái hải sản + Bánh mì + Rau nấm', 199000, 'COMBO', 'F:/Semester7/PhanTichThietKe/RestMan20/src/main/webapp/img/combo02.png', 1),
('Combo Miền Trung', 'Bún bò Huế + Mì Quảng gà + Cao lầu', 175000, 'COMBO', 'F:/Semester7/PhanTichThietKe/RestMan20/src/main/webapp/img/combo02.png', 1),

('Combo Đặc Sản Hà Nội', 'Bún chả Hà Nội + Bánh cốm (tặng) + Cà phê sữa đá', 135000, 'COMBO', 'F:/Semester7/PhanTichThietKe/RestMan20/src/main/webapp/img/combo03.png', 1),
('Combo Healthy Nhẹ Nhàng', 'Gỏi cuốn tôm thịt + Cháo gà hành phi + Sữa đậu nành', 115000, 'COMBO', 'F:/Semester7/PhanTichThietKe/RestMan20/src/main/webapp/img/combo03.png', 1),
('Combo Ăn Vặt Cuối Tuần', 'Bánh tráng trộn + Ốc len xào dừa + Trà tắc mật ong', 125000, 'COMBO', 'F:/Semester7/PhanTichThietKe/RestMan20/src/main/webapp/img/combo03.png', 1);

-- =============================
-- COMBO ITEMS (chọn món type <> 'COMBO')
-- =============================

-- Combo Trưa Nhanh
INSERT INTO tblComboItem (quantity, tblProductid_Dish, tblProductid_Combo)
SELECT 1, d.id, c.id
FROM tblProduct d JOIN tblProduct c ON c.name='Combo Trưa Nhanh' AND c.type='COMBO'
WHERE d.name='Cơm Tấm Sườn Bì Chả' AND d.type <> 'COMBO'
  AND NOT EXISTS (SELECT 1 FROM tblComboItem x WHERE x.tblProductid_Dish=d.id AND x.tblProductid_Combo=c.id);
INSERT INTO tblComboItem (quantity, tblProductid_Dish, tblProductid_Combo)
SELECT 1, d.id, c.id
FROM tblProduct d JOIN tblProduct c ON c.name='Combo Trưa Nhanh' AND c.type='COMBO'
WHERE d.name='Bánh Ướt Thịt Nướng' AND d.type <> 'COMBO'
  AND NOT EXISTS (SELECT 1 FROM tblComboItem x WHERE x.tblProductid_Dish=d.id AND x.tblProductid_Combo=c.id);
INSERT INTO tblComboItem (quantity, tblProductid_Dish, tblProductid_Combo)
SELECT 1, d.id, c.id
FROM tblProduct d JOIN tblProduct c ON c.name='Combo Trưa Nhanh' AND c.type='COMBO'
WHERE d.name='Nước Mía Tắc' AND d.type <> 'COMBO'
  AND NOT EXISTS (SELECT 1 FROM tblComboItem x WHERE x.tblProductid_Dish=d.id AND x.tblProductid_Combo=c.id);

-- Combo Đôi Quán Nhà
INSERT INTO tblComboItem (quantity, tblProductid_Dish, tblProductid_Combo)
SELECT 1, d.id, c.id
FROM tblProduct d JOIN tblProduct c ON c.name='Combo Đôi Quán Nhà' AND c.type='COMBO'
WHERE d.name='Hủ Tiếu Nam Vang' AND d.type <> 'COMBO'
  AND NOT EXISTS (SELECT 1 FROM tblComboItem x WHERE x.tblProductid_Dish=d.id AND x.tblProductid_Combo=c.id);
INSERT INTO tblComboItem (quantity, tblProductid_Dish, tblProductid_Combo)
SELECT 1, d.id, c.id
FROM tblProduct d JOIN tblProduct c ON c.name='Combo Đôi Quán Nhà' AND c.type='COMBO'
WHERE d.name='Gà Kho Gừng' AND d.type <> 'COMBO'
  AND NOT EXISTS (SELECT 1 FROM tblComboItem x WHERE x.tblProductid_Dish=d.id AND x.tblProductid_Combo=c.id);
INSERT INTO tblComboItem (quantity, tblProductid_Dish, tblProductid_Combo)
SELECT 1, d.id, c.id
FROM tblProduct d JOIN tblProduct c ON c.name='Combo Đôi Quán Nhà' AND c.type='COMBO'
WHERE d.name='Trà Tắc Mật Ong' AND d.type <> 'COMBO'
  AND NOT EXISTS (SELECT 1 FROM tblComboItem x WHERE x.tblProductid_Dish=d.id AND x.tblProductid_Combo=c.id);

-- Combo Bạn Bè
INSERT INTO tblComboItem (quantity, tblProductid_Dish, tblProductid_Combo)
SELECT 1, d.id, c.id
FROM tblProduct d JOIN tblProduct c ON c.name='Combo Bạn Bè' AND c.type='COMBO'
WHERE d.name='Bún Chả Hà Nội' AND d.type <> 'COMBO'
  AND NOT EXISTS (SELECT 1 FROM tblComboItem x WHERE x.tblProductid_Dish=d.id AND x.tblProductid_Combo=c.id);
INSERT INTO tblComboItem (quantity, tblProductid_Dish, tblProductid_Combo)
SELECT 1, d.id, c.id
FROM tblProduct d JOIN tblProduct c ON c.name='Combo Bạn Bè' AND c.type='COMBO'
WHERE d.name='Nem Nướng Nha Trang' AND d.type <> 'COMBO'
  AND NOT EXISTS (SELECT 1 FROM tblComboItem x WHERE x.tblProductid_Dish=d.id AND x.tblProductid_Combo=c.id);
INSERT INTO tblComboItem (quantity, tblProductid_Dish, tblProductid_Combo)
SELECT 1, d.id, c.id
FROM tblProduct d JOIN tblProduct c ON c.name='Combo Bạn Bè' AND c.type='COMBO'
WHERE d.name='Trà Tắc Mật Ong' AND d.type <> 'COMBO'
  AND NOT EXISTS (SELECT 1 FROM tblComboItem x WHERE x.tblProductid_Dish=d.id AND x.tblProductid_Combo=c.id);

-- Combo 4 Món Bắc
INSERT INTO tblComboItem (quantity, tblProductid_Dish, tblProductid_Combo)
SELECT 1, d.id, c.id
FROM tblProduct d JOIN tblProduct c ON c.name='Combo 4 Món Bắc' AND c.type='COMBO'
WHERE d.name='Bún Mọc' AND d.type <> 'COMBO'
  AND NOT EXISTS (SELECT 1 FROM tblComboItem x WHERE x.tblProductid_Dish=d.id AND x.tblProductid_Combo=c.id);
INSERT INTO tblComboItem (quantity, tblProductid_Dish, tblProductid_Combo)
SELECT 1, d.id, c.id
FROM tblProduct d JOIN tblProduct c ON c.name='Combo 4 Món Bắc' AND c.type='COMBO'
WHERE d.name='Chả Cá Lã Vọng' AND d.type <> 'COMBO'
  AND NOT EXISTS (SELECT 1 FROM tblComboItem x WHERE x.tblProductid_Dish=d.id AND x.tblProductid_Combo=c.id);
INSERT INTO tblComboItem (quantity, tblProductid_Dish, tblProductid_Combo)
SELECT 1, d.id, c.id
FROM tblProduct d JOIN tblProduct c ON c.name='Combo 4 Món Bắc' AND c.type='COMBO'
WHERE d.name='Bánh Cuốn Nóng' AND d.type <> 'COMBO'
  AND NOT EXISTS (SELECT 1 FROM tblComboItem x WHERE x.tblProductid_Dish=d.id AND x.tblProductid_Combo=c.id);
INSERT INTO tblComboItem (quantity, tblProductid_Dish, tblProductid_Combo)
SELECT 1, d.id, c.id
FROM tblProduct d JOIN tblProduct c ON c.name='Combo 4 Món Bắc' AND c.type='COMBO'
WHERE d.name='Cà Phê Trứng Hà Nội' AND d.type <> 'COMBO'
  AND NOT EXISTS (SELECT 1 FROM tblComboItem x WHERE x.tblProductid_Dish=d.id AND x.tblProductid_Combo=c.id);

-- Combo Gia Đình 4 Người (Mới)
INSERT INTO tblComboItem (quantity, tblProductid_Dish, tblProductid_Combo)
SELECT 1, d.id, c.id
FROM tblProduct d JOIN tblProduct c ON c.name='Combo Gia Đình 4 Người (Mới)' AND c.type='COMBO'
WHERE d.name='Cơm Tấm Sườn Bì Chả' AND d.type <> 'COMBO'
  AND NOT EXISTS (SELECT 1 FROM tblComboItem x WHERE x.tblProductid_Dish=d.id AND x.tblProductid_Combo=c.id);
INSERT INTO tblComboItem (quantity, tblProductid_Dish, tblProductid_Combo)
SELECT 1, d.id, c.id
FROM tblProduct d JOIN tblProduct c ON c.name='Combo Gia Đình 4 Người (Mới)' AND c.type='COMBO'
WHERE d.name='Canh Chua Cá Lóc' AND d.type <> 'COMBO'
  AND NOT EXISTS (SELECT 1 FROM tblComboItem x WHERE x.tblProductid_Dish=d.id AND x.tblProductid_Combo=c.id);
INSERT INTO tblComboItem (quantity, tblProductid_Dish, tblProductid_Combo)
SELECT 1, d.id, c.id
FROM tblProduct d JOIN tblProduct c ON c.name='Combo Gia Đình 4 Người (Mới)' AND c.type='COMBO'
WHERE d.name='Bánh Xèo Miền Tây' AND d.type <> 'COMBO'
  AND NOT EXISTS (SELECT 1 FROM tblComboItem x WHERE x.tblProductid_Dish=d.id AND x.tblProductid_Combo=c.id);
INSERT INTO tblComboItem (quantity, tblProductid_Dish, tblProductid_Combo)
SELECT 1, d.id, c.id
FROM tblProduct d JOIN tblProduct c ON c.name='Combo Gia Đình 4 Người (Mới)' AND c.type='COMBO'
WHERE d.name='Nước Mía Tắc' AND d.type <> 'COMBO'
  AND NOT EXISTS (SELECT 1 FROM tblComboItem x WHERE x.tblProductid_Dish=d.id AND x.tblProductid_Combo=c.id);

-- Combo Lẩu Hải Sản
INSERT INTO tblComboItem (quantity, tblProductid_Dish, tblProductid_Combo)
SELECT 1, d.id, c.id
FROM tblProduct d JOIN tblProduct c ON c.name='Combo Lẩu Hải Sản' AND c.type='COMBO'
WHERE d.name='Lẩu Thái Hải Sản' AND d.type <> 'COMBO'
  AND NOT EXISTS (SELECT 1 FROM tblComboItem x WHERE x.tblProductid_Dish=d.id AND x.tblProductid_Combo=c.id);
INSERT INTO tblComboItem (quantity, tblProductid_Dish, tblProductid_Combo)
SELECT 2, d.id, c.id
FROM tblProduct d JOIN tblProduct c ON c.name='Combo Lẩu Hải Sản' AND c.type='COMBO'
WHERE d.name='Bánh Bèo Chén' AND d.type <> 'COMBO'
  AND NOT EXISTS (SELECT 1 FROM tblComboItem x WHERE x.tblProductid_Dish=d.id AND x.tblProductid_Combo=c.id);
INSERT INTO tblComboItem (quantity, tblProductid_Dish, tblProductid_Combo)
SELECT 1, d.id, c.id
FROM tblProduct d JOIN tblProduct c ON c.name='Combo Lẩu Hải Sản' AND c.type='COMBO'
WHERE d.name='Rau Má Đậu Xanh' AND d.type <> 'COMBO'
  AND NOT EXISTS (SELECT 1 FROM tblComboItem x WHERE x.tblProductid_Dish=d.id AND x.tblProductid_Combo=c.id);

-- Combo Miền Trung
INSERT INTO tblComboItem (quantity, tblProductid_Dish, tblProductid_Combo)
SELECT 1, d.id, c.id
FROM tblProduct d JOIN tblProduct c ON c.name='Combo Miền Trung' AND c.type='COMBO'
WHERE d.name='Bún Bò Huế' AND d.type <> 'COMBO'
  AND NOT EXISTS (SELECT 1 FROM tblComboItem x WHERE x.tblProductid_Dish=d.id AND x.tblProductid_Combo=c.id);
INSERT INTO tblComboItem (quantity, tblProductid_Dish, tblProductid_Combo)
SELECT 1, d.id, c.id
FROM tblProduct d JOIN tblProduct c ON c.name='Combo Miền Trung' AND c.type='COMBO'
WHERE d.name='Mì Quảng Gà' AND d.type <> 'COMBO'
  AND NOT EXISTS (SELECT 1 FROM tblComboItem x WHERE x.tblProductid_Dish=d.id AND x.tblProductid_Combo=c.id);
INSERT INTO tblComboItem (quantity, tblProductid_Dish, tblProductid_Combo)
SELECT 1, d.id, c.id
FROM tblProduct d JOIN tblProduct c ON c.name='Combo Miền Trung' AND c.type='COMBO'
WHERE d.name='Cao Lầu Hội An' AND d.type <> 'COMBO'
  AND NOT EXISTS (SELECT 1 FROM tblComboItem x WHERE x.tblProductid_Dish=d.id AND x.tblProductid_Combo=c.id);

-- Combo Đặc Sản Hà Nội
INSERT INTO tblComboItem (quantity, tblProductid_Dish, tblProductid_Combo)
SELECT 1, d.id, c.id
FROM tblProduct d JOIN tblProduct c ON c.name='Combo Đặc Sản Hà Nội' AND c.type='COMBO'
WHERE d.name='Bún Chả Hà Nội' AND d.type <> 'COMBO'
  AND NOT EXISTS (SELECT 1 FROM tblComboItem x WHERE x.tblProductid_Dish=d.id AND x.tblProductid_Combo=c.id);
INSERT INTO tblComboItem (quantity, tblProductid_Dish, tblProductid_Combo)
SELECT 1, d.id, c.id
FROM tblProduct d JOIN tblProduct c ON c.name='Combo Đặc Sản Hà Nội' AND c.type='COMBO'
WHERE d.name='Cà Phê Sữa Đá' AND d.type <> 'COMBO'
  AND NOT EXISTS (SELECT 1 FROM tblComboItem x WHERE x.tblProductid_Dish=d.id AND x.tblProductid_Combo=c.id);

-- Combo Healthy Nhẹ Nhàng
INSERT INTO tblComboItem (quantity, tblProductid_Dish, tblProductid_Combo)
SELECT 2, d.id, c.id
FROM tblProduct d JOIN tblProduct c ON c.name='Combo Healthy Nhẹ Nhàng' AND c.type='COMBO'
WHERE d.name='Gỏi Cuốn Tôm Thịt' AND d.type <> 'COMBO'
  AND NOT EXISTS (SELECT 1 FROM tblComboItem x WHERE x.tblProductid_Dish=d.id AND x.tblProductid_Combo=c.id);
INSERT INTO tblComboItem (quantity, tblProductid_Dish, tblProductid_Combo)
SELECT 1, d.id, c.id
FROM tblProduct d JOIN tblProduct c ON c.name='Combo Healthy Nhẹ Nhàng' AND c.type='COMBO'
WHERE d.name='Cháo Gà Hành Phi' AND d.type <> 'COMBO'
  AND NOT EXISTS (SELECT 1 FROM tblComboItem x WHERE x.tblProductid_Dish=d.id AND x.tblProductid_Combo=c.id);
INSERT INTO tblComboItem (quantity, tblProductid_Dish, tblProductid_Combo)
SELECT 1, d.id, c.id
FROM tblProduct d JOIN tblProduct c ON c.name='Combo Healthy Nhẹ Nhàng' AND c.type='COMBO'
WHERE d.name='Sữa Đậu Nành Nóng' AND d.type <> 'COMBO'
  AND NOT EXISTS (SELECT 1 FROM tblComboItem x WHERE x.tblProductid_Dish=d.id AND x.tblProductid_Combo=c.id);

-- Combo Ăn Vặt Cuối Tuần
INSERT INTO tblComboItem (quantity, tblProductid_Dish, tblProductid_Combo)
SELECT 1, d.id, c.id
FROM tblProduct d JOIN tblProduct c ON c.name='Combo Ăn Vặt Cuối Tuần' AND c.type='COMBO'
WHERE d.name='Bánh Tráng Trộn' AND d.type <> 'COMBO'
  AND NOT EXISTS (SELECT 1 FROM tblComboItem x WHERE x.tblProductid_Dish=d.id AND x.tblProductid_Combo=c.id);
INSERT INTO tblComboItem (quantity, tblProductid_Dish, tblProductid_Combo)
SELECT 1, d.id, c.id
FROM tblProduct d JOIN tblProduct c ON c.name='Combo Ăn Vặt Cuối Tuần' AND c.type='COMBO'
WHERE d.name='Ốc Len Xào Dừa' AND d.type <> 'COMBO'
  AND NOT EXISTS (SELECT 1 FROM tblComboItem x WHERE x.tblProductid_Dish=d.id AND x.tblProductid_Combo=c.id);
INSERT INTO tblComboItem (quantity, tblProductid_Dish, tblProductid_Combo)
SELECT 1, d.id, c.id
FROM tblProduct d JOIN tblProduct c ON c.name='Combo Ăn Vặt Cuối Tuần' AND c.type='COMBO'
WHERE d.name='Trà Tắc Mật Ong' AND d.type <> 'COMBO'
  AND NOT EXISTS (SELECT 1 FROM tblComboItem x WHERE x.tblProductid_Dish=d.id AND x.tblProductid_Combo=c.id);

-- =============================
-- ORDERS + ORDER DETAILS + INVOICES
-- (Để có bàn cần thanh toán - status=1)
-- Tạo 20 bàn với các đơn hàng khác nhau
-- =============================

-- Cập nhật tất cả 20 bàn thành trạng thái đang sử dụng (status=1)
UPDATE tblTable SET status = 1 WHERE id BETWEEN 1 AND 20;

-- BÀNG 1: Bún Chả Hà Nội + Cà Phê Sữa Đá
INSERT INTO tblOrder (tblCustomertblUserid, tblTableid) VALUES (4, 1);
INSERT INTO tblOrderDetail (quantity, tblProductid, tblOrderid) SELECT 2, p.id, 1 FROM tblProduct p WHERE p.name='Bún Chả Hà Nội' AND p.type='DISH';
INSERT INTO tblOrderDetail (quantity, tblProductid, tblOrderid) SELECT 2, p.id, 1 FROM tblProduct p WHERE p.name='Cà Phê Sữa Đá' AND p.type='DRINK';

-- BÀNG 2: Lẩu Thái Hải Sản + Rau Má Đậu Xanh
INSERT INTO tblOrder (tblCustomertblUserid, tblTableid) VALUES (5, 2);
INSERT INTO tblOrderDetail (quantity, tblProductid, tblOrderid) SELECT 1, p.id, 2 FROM tblProduct p WHERE p.name='Lẩu Thái Hải Sản' AND p.type='DISH';
INSERT INTO tblOrderDetail (quantity, tblProductid, tblOrderid) SELECT 2, p.id, 2 FROM tblProduct p WHERE p.name='Rau Má Đậu Xanh' AND p.type='DRINK';

-- BÀNG 3: Combo Bạn Bè + Bạc Xỉu
INSERT INTO tblOrder (tblCustomertblUserid, tblTableid) VALUES (6, 3);
INSERT INTO tblOrderDetail (quantity, tblProductid, tblOrderid) SELECT 1, p.id, 3 FROM tblProduct p WHERE p.name='Combo Bạn Bè' AND p.type='COMBO';
INSERT INTO tblOrderDetail (quantity, tblProductid, tblOrderid) SELECT 1, p.id, 3 FROM tblProduct p WHERE p.name='Bạc Xỉu' AND p.type='DRINK';

-- BÀNG 4: Bún Riêu Cua + Cà Phê Đen Đá
INSERT INTO tblOrder (tblCustomertblUserid, tblTableid) VALUES (4, 4);
INSERT INTO tblOrderDetail (quantity, tblProductid, tblOrderid) SELECT 3, p.id, 4 FROM tblProduct p WHERE p.name='Bún Riêu Cua' AND p.type='DISH';
INSERT INTO tblOrderDetail (quantity, tblProductid, tblOrderid) SELECT 3, p.id, 4 FROM tblProduct p WHERE p.name='Cà Phê Đen Đá' AND p.type='DRINK';

-- BÀNG 5: Bánh Xèo Miền Tây + Nước Mía Tắc
INSERT INTO tblOrder (tblCustomertblUserid, tblTableid) VALUES (5, 5);
INSERT INTO tblOrderDetail (quantity, tblProductid, tblOrderid) SELECT 2, p.id, 5 FROM tblProduct p WHERE p.name='Bánh Xèo Miền Tây' AND p.type='DISH';
INSERT INTO tblOrderDetail (quantity, tblProductid, tblOrderid) SELECT 2, p.id, 5 FROM tblProduct p WHERE p.name='Nước Mía Tắc' AND p.type='DRINK';

-- BÀNG 6: Combo Trưa Nhanh + Trà Tắc Mật Ong
INSERT INTO tblOrder (tblCustomertblUserid, tblTableid) VALUES (6, 6);
INSERT INTO tblOrderDetail (quantity, tblProductid, tblOrderid) SELECT 1, p.id, 6 FROM tblProduct p WHERE p.name='Combo Trưa Nhanh' AND p.type='COMBO';
INSERT INTO tblOrderDetail (quantity, tblProductid, tblOrderid) SELECT 2, p.id, 6 FROM tblProduct p WHERE p.name='Trà Tắc Mật Ong' AND p.type='DRINK';

-- BÀNG 7: Cá Kho Tộ + Sâm Bổ Lượng
INSERT INTO tblOrder (tblCustomertblUserid, tblTableid) VALUES (4, 7);
INSERT INTO tblOrderDetail (quantity, tblProductid, tblOrderid) SELECT 2, p.id, 7 FROM tblProduct p WHERE p.name='Cá Kho Tộ' AND p.type='DISH';
INSERT INTO tblOrderDetail (quantity, tblProductid, tblOrderid) SELECT 2, p.id, 7 FROM tblProduct p WHERE p.name='Sâm Bổ Lượng' AND p.type='DRINK';

-- BÀNG 8: Combo 4 Món Bắc + Sữa Đậu Nành Nóng
INSERT INTO tblOrder (tblCustomertblUserid, tblTableid) VALUES (5, 8);
INSERT INTO tblOrderDetail (quantity, tblProductid, tblOrderid) SELECT 1, p.id, 8 FROM tblProduct p WHERE p.name='Combo 4 Món Bắc' AND p.type='COMBO';
INSERT INTO tblOrderDetail (quantity, tblProductid, tblOrderid) SELECT 3, p.id, 8 FROM tblProduct p WHERE p.name='Sữa Đậu Nành Nóng' AND p.type='DRINK';

-- BÀNG 9: Bún Đậu Mắm Tôm + CaCao Nóng
INSERT INTO tblOrder (tblCustomertblUserid, tblTableid) VALUES (6, 9);
INSERT INTO tblOrderDetail (quantity, tblProductid, tblOrderid) SELECT 1, p.id, 9 FROM tblProduct p WHERE p.name='Bún Đậu Mắm Tôm' AND p.type='DISH';
INSERT INTO tblOrderDetail (quantity, tblProductid, tblOrderid) SELECT 2, p.id, 9 FROM tblProduct p WHERE p.name='CaCao Nóng' AND p.type='DRINK';

-- BÀNG 10: Combo Đôi Quán Nhà + Cà Phê Trứng Hà Nội
INSERT INTO tblOrder (tblCustomertblUserid, tblTableid) VALUES (4, 10);
INSERT INTO tblOrderDetail (quantity, tblProductid, tblOrderid) SELECT 2, p.id, 10 FROM tblProduct p WHERE p.name='Combo Đôi Quán Nhà' AND p.type='COMBO';
INSERT INTO tblOrderDetail (quantity, tblProductid, tblOrderid) SELECT 1, p.id, 10 FROM tblProduct p WHERE p.name='Cà Phê Trứng Hà Nội' AND p.type='DRINK';

-- BÀNG 11: Bánh Cuốn Nóng + Bạc Xỉu
INSERT INTO tblOrder (tblCustomertblUserid, tblTableid) VALUES (5, 11);
INSERT INTO tblOrderDetail (quantity, tblProductid, tblOrderid) SELECT 4, p.id, 11 FROM tblProduct p WHERE p.name='Bánh Cuốn Nóng' AND p.type='DISH';
INSERT INTO tblOrderDetail (quantity, tblProductid, tblOrderid) SELECT 4, p.id, 11 FROM tblProduct p WHERE p.name='Bạc Xỉu' AND p.type='DRINK';

-- BÀNG 12: Canh Chua Cá Lóc + Cà Phê Sữa Đá
INSERT INTO tblOrder (tblCustomertblUserid, tblTableid) VALUES (6, 12);
INSERT INTO tblOrderDetail (quantity, tblProductid, tblOrderid) SELECT 2, p.id, 12 FROM tblProduct p WHERE p.name='Canh Chua Cá Lóc' AND p.type='DISH';
INSERT INTO tblOrderDetail (quantity, tblProductid, tblOrderid) SELECT 3, p.id, 12 FROM tblProduct p WHERE p.name='Cà Phê Sữa Đá' AND p.type='DRINK';

-- BÀNG 13: Gỏi Cuốn Tôm Thịt + Nước Mía Tắc
INSERT INTO tblOrder (tblCustomertblUserid, tblTableid) VALUES (4, 13);
INSERT INTO tblOrderDetail (quantity, tblProductid, tblOrderid) SELECT 3, p.id, 13 FROM tblProduct p WHERE p.name='Gỏi Cuốn Tôm Thịt' AND p.type='DISH';
INSERT INTO tblOrderDetail (quantity, tblProductid, tblOrderid) SELECT 2, p.id, 13 FROM tblProduct p WHERE p.name='Nước Mía Tắc' AND p.type='DRINK';

-- BÀNG 14: Combo Gia Đình 4 Người (Mới) + Cà Phê Đen Đá
INSERT INTO tblOrder (tblCustomertblUserid, tblTableid) VALUES (5, 14);
INSERT INTO tblOrderDetail (quantity, tblProductid, tblOrderid) SELECT 1, p.id, 14 FROM tblProduct p WHERE p.name='Combo Gia Đình 4 Người (Mới)' AND p.type='COMBO';
INSERT INTO tblOrderDetail (quantity, tblProductid, tblOrderid) SELECT 2, p.id, 14 FROM tblProduct p WHERE p.name='Cà Phê Đen Đá' AND p.type='DRINK';

-- BÀNG 15: Bò Kho Bánh Mì + Trà Tắc Mật Ong
INSERT INTO tblOrder (tblCustomertblUserid, tblTableid) VALUES (6, 15);
INSERT INTO tblOrderDetail (quantity, tblProductid, tblOrderid) SELECT 1, p.id, 15 FROM tblProduct p WHERE p.name='Bò Kho Bánh Mì' AND p.type='DISH';
INSERT INTO tblOrderDetail (quantity, tblProductid, tblOrderid) SELECT 3, p.id, 15 FROM tblProduct p WHERE p.name='Trà Tắc Mật Ong' AND p.type='DRINK';

-- BÀNG 16: Combo Lẩu Hải Sản + Sâm Bổ Lượng
INSERT INTO tblOrder (tblCustomertblUserid, tblTableid) VALUES (4, 16);
INSERT INTO tblOrderDetail (quantity, tblProductid, tblOrderid) SELECT 1, p.id, 16 FROM tblProduct p WHERE p.name='Combo Lẩu Hải Sản' AND p.type='COMBO';
INSERT INTO tblOrderDetail (quantity, tblProductid, tblOrderid) SELECT 2, p.id, 16 FROM tblProduct p WHERE p.name='Sâm Bổ Lượng' AND p.type='DRINK';

-- BÀNG 17: Hủ Tiếu Nam Vang + Sữa Đậu Nành Nóng
INSERT INTO tblOrder (tblCustomertblUserid, tblTableid) VALUES (5, 17);
INSERT INTO tblOrderDetail (quantity, tblProductid, tblOrderid) SELECT 2, p.id, 17 FROM tblProduct p WHERE p.name='Hủ Tiếu Nam Vang' AND p.type='DISH';
INSERT INTO tblOrderDetail (quantity, tblProductid, tblOrderid) SELECT 2, p.id, 17 FROM tblProduct p WHERE p.name='Sữa Đậu Nành Nóng' AND p.type='DRINK';

-- BÀNG 18: Combo Miền Trung + CaCao Nóng
INSERT INTO tblOrder (tblCustomertblUserid, tblTableid) VALUES (6, 18);
INSERT INTO tblOrderDetail (quantity, tblProductid, tblOrderid) SELECT 1, p.id, 18 FROM tblProduct p WHERE p.name='Combo Miền Trung' AND p.type='COMBO';
INSERT INTO tblOrderDetail (quantity, tblProductid, tblOrderid) SELECT 1, p.id, 18 FROM tblProduct p WHERE p.name='CaCao Nóng' AND p.type='DRINK';

-- BÀNG 19: Lẩu Bò Nhúng Dấm + Cà Phê Sữa Đá
INSERT INTO tblOrder (tblCustomertblUserid, tblTableid) VALUES (4, 19);
INSERT INTO tblOrderDetail (quantity, tblProductid, tblOrderid) SELECT 1, p.id, 19 FROM tblProduct p WHERE p.name='Lẩu Bò Nhúng Dấm' AND p.type='DISH';
INSERT INTO tblOrderDetail (quantity, tblProductid, tblOrderid) SELECT 3, p.id, 19 FROM tblProduct p WHERE p.name='Cà Phê Sữa Đá' AND p.type='DRINK';

-- BÀNG 20: Combo Đặc Sản Hà Nội + Nước Mía Tắc
INSERT INTO tblOrder (tblCustomertblUserid, tblTableid) VALUES (5, 20);
INSERT INTO tblOrderDetail (quantity, tblProductid, tblOrderid) SELECT 1, p.id, 20 FROM tblProduct p WHERE p.name='Combo Đặc Sản Hà Nội' AND p.type='COMBO';
INSERT INTO tblOrderDetail (quantity, tblProductid, tblOrderid) SELECT 2, p.id, 20 FROM tblProduct p WHERE p.name='Nước Mía Tắc' AND p.type='DRINK';

SET FOREIGN_KEY_CHECKS = 1;
