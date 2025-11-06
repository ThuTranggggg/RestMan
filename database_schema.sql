DROP DATABASE IF EXISTS restman;
CREATE DATABASE restman
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE restman;

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- =========================
-- USER / STAFF / CUSTOMER
-- =========================
CREATE TABLE tblUser (
  id         INT PRIMARY KEY AUTO_INCREMENT,
  fullName   VARCHAR(255) NOT NULL,
  phone      VARCHAR(50),
  email      VARCHAR(255),
  username   VARCHAR(255) NOT NULL,
  password   VARCHAR(255) NOT NULL,
  role       VARCHAR(255) NOT NULL,         -- ví dụ: CUSTOMER / STAFF / ADMIN
  CONSTRAINT uq_user_username UNIQUE (username),
  CONSTRAINT uq_user_email UNIQUE (email)
) ENGINE=InnoDB;

CREATE TABLE tblStaff (
  tblUserId  INT PRIMARY KEY,               -- PK cũng là FK sang tblUser
  position   VARCHAR(255) NOT NULL,
  CONSTRAINT fk_staff_user FOREIGN KEY (tblUserId) REFERENCES tblUser(id)
    ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

-- Các vai trò con của Staff (mỗi dòng mapping 1-1 tới staff)
CREATE TABLE tblManager (
  tblStafftblUserId INT PRIMARY KEY,
  CONSTRAINT fk_manager_staff FOREIGN KEY (tblStafftblUserId) REFERENCES tblStaff(tblUserId)
    ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE tblServer (
  tblStafftblUserId INT PRIMARY KEY,
  CONSTRAINT fk_server_staff FOREIGN KEY (tblStafftblUserId) REFERENCES tblStaff(tblUserId)
    ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE tblStockClerk (
  tblStafftblUserId INT PRIMARY KEY,
  CONSTRAINT fk_stockclerk_staff FOREIGN KEY (tblStafftblUserId) REFERENCES tblStaff(tblUserId)
    ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

-- =========================
-- MEMBER CARD / CUSTOMER
-- =========================
CREATE TABLE tblMemberCard (
  id        INT PRIMARY KEY AUTO_INCREMENT,
  point     INT DEFAULT 0,
  issueDate DATE
) ENGINE=InnoDB;

CREATE TABLE tblCustomer (
  tblUserid       INT PRIMARY KEY,          -- PK cũng là FK sang tblUser
  tblMemberCardid INT DEFAULT NULL,
  CONSTRAINT fk_customer_user FOREIGN KEY (tblUserid) REFERENCES tblUser(id)
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_customer_membercard FOREIGN KEY (tblMemberCardid) REFERENCES tblMemberCard(id)
    ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB;

-- =========================
-- TABLE
-- =========================
CREATE TABLE tblTable (
  id          INT PRIMARY KEY AUTO_INCREMENT,
  name        VARCHAR(255) NOT NULL,
  status      INT NOT NULL DEFAULT 0,       -- 0=free,1=occupied,...
  description VARCHAR(255)
) ENGINE=InnoDB;

-- ==============================================
-- PRODUCT (Superclass - Lớp cha)
-- Lưu trữ cả Dish (món lẻ) và Combo (bó món)
-- ==============================================
CREATE TABLE tblProduct (
  id          INT PRIMARY KEY AUTO_INCREMENT,
  name        VARCHAR(255) NOT NULL,
  description VARCHAR(255),
  price       DECIMAL(12,2) NOT NULL,
  sold        INT NOT NULL DEFAULT 0,
  type        VARCHAR(50) NOT NULL,        -- 'DISH' hoặc 'COMBO'
  imageUrl    VARCHAR(255),
  status      INT NOT NULL DEFAULT 1,      -- 1=active, 0=inactive
  created_at  DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at  DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- =========================
-- COMBO ITEM (Bảng kết nối)
-- Combo gồm nhiều Dish
-- =========================
CREATE TABLE tblComboItem (
  id          INT PRIMARY KEY AUTO_INCREMENT,
  quantity    INT NOT NULL,
  tblProductid_Dish INT NOT NULL,     -- ID của Dish (từ tblProduct)
  tblProductid_Combo INT NOT NULL,    -- ID của Combo (từ tblProduct)
  CONSTRAINT fk_comboitem_dish FOREIGN KEY (tblProductid_Dish) REFERENCES tblProduct(id)
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_comboitem_combo FOREIGN KEY (tblProductid_Combo) REFERENCES tblProduct(id)
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT uq_comboitem UNIQUE (tblProductid_Combo, tblProductid_Dish)
) ENGINE=InnoDB;

-- =========================
-- ORDER / ORDER DETAIL / INVOICE
-- =========================
CREATE TABLE tblOrder (
  id                     INT PRIMARY KEY AUTO_INCREMENT,
  tblCustomertblUserid   INT,                -- khách đặt
  tblTableid             INT,                -- bàn
  created_at             DATETIME DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_order_customer FOREIGN KEY (tblCustomertblUserid) REFERENCES tblCustomer(tblUserid)
    ON UPDATE CASCADE ON DELETE SET NULL,
  CONSTRAINT fk_order_table FOREIGN KEY (tblTableid) REFERENCES tblTable(id)
    ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB;

-- =====================================================
-- ORDER DETAIL (Chi tiết đơn hàng)
-- Thay vì tblOrderDish tham chiếu riêng Dish/Combo
-- Giờ tham chiếu tới tblProduct (có thể là Dish hoặc Combo)
-- =====================================================
CREATE TABLE tblOrderDetail (
  id              INT PRIMARY KEY AUTO_INCREMENT,
  quantity        INT NOT NULL,
  status          VARCHAR(255) DEFAULT 'PENDING',
  tblProductid    INT NOT NULL,         -- FK tới tblProduct (Dish hoặc Combo)
  tblOrderid      INT NOT NULL,
  CONSTRAINT fk_orderdetail_order FOREIGN KEY (tblOrderid) REFERENCES tblOrder(id)
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_orderdetail_product FOREIGN KEY (tblProductid) REFERENCES tblProduct(id)
    ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE tblInvoice (
  id                         INT PRIMARY KEY AUTO_INCREMENT,
  datetime                   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  bonusPoint                 INT DEFAULT 0,
  tblOrderid                 INT NOT NULL,
  tblServertblStafftblUserid INT,            -- người thu ngân/phục vụ lập hoá đơn
  CONSTRAINT fk_invoice_order FOREIGN KEY (tblOrderid) REFERENCES tblOrder(id)
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_invoice_server FOREIGN KEY (tblServertblStafftblUserid) REFERENCES tblServer(tblStafftblUserId)
    ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB;

-- =========================
-- SUPPLIER / INGREDIENT / GOODS RECEIVE
-- =========================
CREATE TABLE tblSupplier (
  id      INT PRIMARY KEY AUTO_INCREMENT,
  email   VARCHAR(255),
  name    VARCHAR(255) NOT NULL,
  address VARCHAR(255),
  phone   VARCHAR(50)
) ENGINE=InnoDB;

CREATE TABLE tblIngredient (
  id          INT PRIMARY KEY AUTO_INCREMENT,
  name        VARCHAR(255) NOT NULL,
  quantity    INT NOT NULL DEFAULT 0,
  description VARCHAR(255)
) ENGINE=InnoDB;

CREATE TABLE tblGoodsReceive (
  id                               INT PRIMARY KEY AUTO_INCREMENT,
  date                             DATE NOT NULL,
  quantity                         INT NOT NULL,
  price                            DECIMAL(12,2) NOT NULL,
  tblStockClerktblStafftblUserid   INT,    -- nhân viên kho nhập hàng
  tblSupplierid                    INT,
  tblIngredientid                  INT,
  CONSTRAINT fk_gr_stockclerk FOREIGN KEY (tblStockClerktblStafftblUserid) REFERENCES tblStockClerk(tblStafftblUserId)
    ON UPDATE CASCADE ON DELETE SET NULL,
  CONSTRAINT fk_gr_supplier FOREIGN KEY (tblSupplierid) REFERENCES tblSupplier(id)
    ON UPDATE CASCADE ON DELETE SET NULL,
  CONSTRAINT fk_gr_ingredient FOREIGN KEY (tblIngredientid) REFERENCES tblIngredient(id)
    ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB;

-- =============================================
-- INDEXING (một số chỉ mục hay dùng)
-- =============================================
CREATE INDEX idx_user_phone ON tblUser(phone);
CREATE INDEX idx_product_type ON tblProduct(type);
CREATE INDEX idx_product_name ON tblProduct(name);
CREATE INDEX idx_product_status ON tblProduct(status);
CREATE INDEX idx_order_created ON tblOrder(created_at);
CREATE INDEX idx_orderdetail_order ON tblOrderDetail(tblOrderid);
CREATE INDEX idx_orderdetail_product ON tblOrderDetail(tblProductid);
CREATE INDEX idx_invoice_order ON tblInvoice(tblOrderid);
CREATE INDEX idx_gr_date ON tblGoodsReceive(date);
CREATE INDEX idx_comboitem_combo ON tblComboItem(tblProductid_Combo);
CREATE INDEX idx_comboitem_dish ON tblComboItem(tblProductid_Dish);

-- =============================================
-- SAMPLE DATA
-- =============================================

-- Thêm user
INSERT INTO tblUser (fullName, phone, email, username, password, role) VALUES
('Admin User', '0901111111', 'admin@restman.com', 'admin001', 'admin123', 'ADMIN'),
('Manager User', '0902222222', 'manager@restman.com', 'manager001', 'manager123', 'STAFF'),
('Server User', '0903333333', 'server@restman.com', 'server001', 'server123', 'STAFF'),
('Stock Clerk', '0904444444', 'stock@restman.com', 'stock001', 'stock123', 'STAFF'),
('Nguyễn Văn A', '0905555555', 'nguyenvana@gmail.com', 'customer001', 'cust123', 'CUSTOMER');

-- Thêm staff
INSERT INTO tblStaff (tblUserId, position) VALUES (2, 'Manager'), (3, 'Server'), (4, 'Stock Clerk');

-- Thêm manager
INSERT INTO tblManager (tblStafftblUserId) VALUES (2);

-- Thêm server
INSERT INTO tblServer (tblStafftblUserId) VALUES (3);

-- Thêm stock clerk
INSERT INTO tblStockClerk (tblStafftblUserId) VALUES (4);

-- Thêm member card
INSERT INTO tblMemberCard (point, issueDate) VALUES (0, CURDATE());

-- Thêm customer
INSERT INTO tblCustomer (tblUserid, tblMemberCardid) VALUES (5, 1);

-- Thêm bàn ăn
INSERT INTO tblTable (name, status, description) VALUES
('Bàn 1', 0, 'Bàn 2 chỗ'),
('Bàn 2', 0, 'Bàn 4 chỗ'),
('Bàn 3', 0, 'Bàn 6 chỗ'),
('Bàn 4', 0, 'Bàn 8 chỗ');

-- Thêm sản phẩm DRINK (Nước)
INSERT INTO tblProduct (name, description, price, sold, type, imageUrl, status) VALUES
('Nước Lọc', 'Nước lọc suối tinh khiết', 10000, 500, 'DRINK', '/img/nuocMia.png', 1),
('Coca Cola', 'Nước ngọt Coca Cola lạnh', 15000, 300, 'DRINK', '/img/cafe.png', 1),
('Nước Ép Cam', 'Nước ép cam tươi mỗi ngày', 25000, 200, 'DRINK', '/img/cafe.png', 1),
('Trà Đen Lạnh', 'Trà đen không đường lạnh', 12000, 150, 'DRINK', '/img/cafe.png', 1),
('Smoothie Dâu', 'Smoothie dâu mix sữa chua', 35000, 80, 'DRINK', '/img/cafe.png', 1);

-- Thêm sản phẩm DISH (Món lẻ)
INSERT INTO tblProduct (name, description, price, sold, type, imageUrl, status) VALUES
('Cơm Chiên Dương Châu', 'Cơm chiên với tôm, gà, trứng', 55000, 120, 'DISH', '/img/bunDau.png', 1),
('Phở Bò', 'Phở bò truyền thống Việt Nam', 45000, 85, 'DISH', '/img/bunRieu.png', 1),
('Bánh Mì Thịt Nướng', 'Bánh mì nóng với thịt nướng', 35000, 156, 'DISH', '/img/bunCha.png', 1),
('Gà Nướng', 'Gà nướng xả ớt chuẩn vị', 85000, 45, 'DISH', '/img/bunDau.png', 1);

-- Thêm sản phẩm COMBO (Bó món)
INSERT INTO tblProduct (name, description, price, sold, type, imageUrl, status) VALUES
('Combo Đôi Yêu Thương', 'Cơm chiên + Nước ép trái cây', 75000, 45, 'COMBO', '/img/combo01.png', 1),
('Combo Gia Đình', 'Cơm chiên + Phở Bò + Gà Nướng + Nước ép', 200000, 28, 'COMBO', '/img/combo02.png', 1);

-- Thêm combo items (Combo 1: Cơm chiên + Nước ép)
INSERT INTO tblComboItem (quantity, tblProductid_Dish, tblProductid_Combo) VALUES
(1, 6, 11),  -- 1 cơm chiên vào combo 1
(1, 10, 11);  -- 1 nước ép vào combo 1

-- Thêm combo items (Combo 2: Cơm chiên + Phở + Gà + Nước ép)
INSERT INTO tblComboItem (quantity, tblProductid_Dish, tblProductid_Combo) VALUES
(1, 6, 12),  -- 1 cơm chiên vào combo 2
(1, 7, 12),  -- 1 phở bò vào combo 2
(1, 9, 12),  -- 1 gà nướng vào combo 2
(1, 10, 12);  -- 1 nước ép vào combo 2

-- Thêm supplier
INSERT INTO tblSupplier (name, email, address, phone) VALUES
('Nhà Cung Cấp A', 'supplier_a@email.com', '123 Nguyễn Huệ, TP.HCM', '0911111111'),
('Nhà Cung Cấp B', 'supplier_b@email.com', '456 Lê Lợi, TP.HCM', '0922222222');

-- Thêm ingredient
INSERT INTO tblIngredient (name, quantity, description) VALUES
('Gạo', 1000, 'Gạo tẻ thơm'),
('Trứng', 500, 'Trứng gà tươi'),
('Tôm', 300, 'Tôm sú'),
('Gà', 200, 'Thịt gà'),
('Rau cải', 400, 'Rau cải xanh');

SET FOREIGN_KEY_CHECKS = 1;
