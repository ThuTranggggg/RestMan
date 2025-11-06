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
  type        VARCHAR(50) NOT NULL,        -- 'DISH' hoặc 'COMBO'
  imageUrl    VARCHAR(255),
  status      INT NOT NULL DEFAULT 1       -- 1=active, 0=inactive
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
  tblProductid    INT NOT NULL,         -- FK tới tblProduct (Dish hoặc Combo)
  tblOrderid      INT NOT NULL,
  CONSTRAINT fk_orderdetail_order FOREIGN KEY (tblOrderid) REFERENCES tblOrder(id)
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_orderdetail_product FOREIGN KEY (tblProductid) REFERENCES tblProduct(id)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE tblInvoice (
  id                         INT PRIMARY KEY AUTO_INCREMENT,
  datetime                   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  bonusPoint                 INT DEFAULT 0,
  tblOrderid                 INT NOT NULL,
  tblServertblStafftblUserid INT,            -- người phục vụ lập hoá đơn
  CONSTRAINT fk_invoice_order FOREIGN KEY (tblOrderid) REFERENCES tblOrder(id)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_invoice_server FOREIGN KEY (tblServertblStafftblUserid) REFERENCES tblServer(tblStafftblUserId)
    ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB;

-- =============================================
-- INDEXING (một số chỉ mục hay dùng)
-- =============================================
CREATE INDEX idx_user_phone ON tblUser(phone);
CREATE INDEX idx_product_type ON tblProduct(type);
CREATE INDEX idx_product_name ON tblProduct(name);
CREATE INDEX idx_product_status ON tblProduct(status);
CREATE INDEX idx_orderdetail_order ON tblOrderDetail(tblOrderid);
CREATE INDEX idx_orderdetail_product ON tblOrderDetail(tblProductid);
CREATE INDEX idx_invoice_order ON tblInvoice(tblOrderid);
CREATE INDEX idx_comboitem_combo ON tblComboItem(tblProductid_Combo);
CREATE INDEX idx_comboitem_dish ON tblComboItem(tblProductid_Dish);

SET FOREIGN_KEY_CHECKS = 1;
