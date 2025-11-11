# RestMan20 - Restaurant Management System

[![Java](https://img.shields.io/badge/Java-21-orange.svg)](https://www.oracle.com/java/)
[![Maven](https://img.shields.io/badge/Maven-3.6+-blue.svg)](https://maven.apache.org/)
[![MySQL](https://img.shields.io/badge/MySQL-8.0-blue.svg)](https://www.mysql.com/)
[![Servlet](https://img.shields.io/badge/Servlet-4.0-green.svg)](https://jakarta.ee/specifications/servlet/)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

> A modern restaurant management system built with Java Servlet, JSP, and MySQL. Designed for efficient order management, table tracking, and billing operations.

---

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Technology Stack](#technology-stack)
- [Architecture](#architecture)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Configuration](#configuration)
- [Usage](#usage)
- [Project Structure](#project-structure)
- [Database Schema](#database-schema)
- [API Endpoints](#api-endpoints)
- [Contributing](#contributing)
- [License](#license)

---

## 🎯 Overview

**RestMan20** is a comprehensive restaurant management system that streamlines restaurant operations including:
- Staff authentication and authorization
- Table management and status tracking
- Order creation and modification
- Billing and invoice generation
- Customer and membership management
- Product catalog with combo support

---

## Features

### Staff Management
- Secure login/logout with session management
- Role-based access control (Server, Manager, Stock Clerk)
- Staff profile and position tracking

### Table & Order Management
- Real-time table status monitoring
- Advanced search by table ID, name, or customer
- Order creation with multiple products
- Order modification (add/remove items, adjust quantity)

### Billing & Invoice
- Automatic total calculation
- Loyalty points integration
- Print-friendly invoice format
- Complete transaction history

### Product Management
- Individual dish catalog
- Combo meal support
- Price and description tracking
- Product status (active/inactive)

### Customer Features
- Browse menu and dish details
- Search products by name
- Membership card integration

---

## Technology Stack

### Backend
- **Java 21** - Core programming language
- **Java Servlet 4.0** - Web request handling
- **JSP 2.3** - Dynamic page rendering
- **JSTL 1.2** - Tag library for JSP

### Database
- **MySQL 8.0** - Relational database
- **JDBC** - Database connectivity

### Build & Deployment
- **Maven 3.6+** - Dependency management and build automation
- **Apache Tomcat 9.0** - Servlet container

### Additional Libraries
- **MySQL Connector/J 8.1.0** - MySQL JDBC driver
- **Dotenv Java 3.0.0** - Environment variable management
- **JUnit 4.13.2** - Unit testing

---

## Architecture

RestMan20 follows a **3-tier MVC architecture**:

```
┌─────────────────────────────────────────┐
│         Presentation Layer              │
│  (JSP Views + HTML/CSS/JavaScript)      │
└───────────────┬─────────────────────────┘
                │
┌───────────────▼─────────────────────────┐
│         Application Layer               │
│   (Servlets + Business Logic)           │
└───────────────┬─────────────────────────┘
                │
┌───────────────▼─────────────────────────┐
│         Data Access Layer               │
│      (DAO Pattern + Models)             │
└───────────────┬─────────────────────────┘
                │
┌───────────────▼─────────────────────────┐
│         Database Layer                  │
│      (MySQL Database)                   │
└─────────────────────────────────────────┘
```

### Design Patterns Used
- **DAO Pattern** - Data access abstraction
- **MVC Pattern** - Separation of concerns
- **Singleton Pattern** - Database connection management
- **Factory Pattern** - Object creation

---

## Prerequisites

Before you begin, ensure you have the following installed:

- **JDK 21** or higher ([Download](https://www.oracle.com/java/technologies/downloads/))
- **Apache Maven 3.6+** ([Download](https://maven.apache.org/download.cgi))
- **MySQL 8.0+** ([Download](https://dev.mysql.com/downloads/))
- **Apache Tomcat 9.0+** ([Download](https://tomcat.apache.org/download-90.cgi))
- **Git** (optional, for cloning)

---

## Installation

### 1. Clone the Repository

```bash
git clone https://github.com/ThuTranggggg/RestMan.git
cd RestMan20
```

### 2. Setup Database

Create the database and tables:

```bash
mysql -u root -p < database_schema.sql
```

Load sample data:

```bash
mysql -u root -p restman < insertData.sql
```

### 3. Configure Environment Variables

Create a `.env` file in the project root:

```env
DB_URL=jdbc:mysql://localhost:3306/restman?useSSL=false&serverTimezone=UTC
DB_USER=root
DB_PASS=your_password_here
```

### 4. Build the Project

```bash
mvn clean package
```

This will generate `RestMan20.war` in the `target/` directory.

### 5. Deploy to Tomcat

**Option A: Manual Deployment**
```bash
cp target/RestMan20.war $TOMCAT_HOME/webapps/
```

**Option B: Using Maven Tomcat Plugin**
```bash
mvn tomcat7:deploy
```

### 6. Start Tomcat Server

```bash
cd $TOMCAT_HOME/bin
./startup.sh  # Linux/Mac
# or
startup.bat   # Windows
```

### 7. Access the Application

Open your browser and navigate to:
```
http://localhost:8080/RestMan20/
```

---

## Configuration

### Database Connection

Edit `src/main/java/dao/DAO.java` or use `.env` file:

```java
// Option 1: Direct configuration (not recommended)
private static final String DB_URL  = "jdbc:mysql://localhost:3306/restman";
private static final String DB_USER = "root";
private static final String DB_PASS = "your_password";

// Option 2: Using environment variables (recommended)
private static final Dotenv dotenv = Dotenv.load();
private static final String DB_URL  = dotenv.get("DB_URL");
private static final String DB_USER = dotenv.get("DB_USER");
private static final String DB_PASS = dotenv.get("DB_PASS");
```

### Session Configuration

Edit `src/main/webapp/WEB-INF/web.xml`:

```xml
<session-config>
    <session-timeout>30</session-timeout> <!-- minutes -->
</session-config>
```

---

## Usage

### Staff Workflow

1. **Login**
   - Navigate to `http://localhost:8080/RestMan20/`
   - Click "Tôi là Nhân viên" (I am Staff)
   - Enter credentials (e.g., `staff1` / `password123`)

2. **View Dashboard**
   - See staff information and available actions
   - Access "Thanh toán hóa đơn" (Billing)

3. **Search Tables**
   - View all active tables
   - Search by table ID, name, or customer name
   - Click on a table to view its order

4. **Process Order**
   - Review ordered items
   - Modify quantities or remove items
   - Enter loyalty points (if applicable)
   - Confirm payment

5. **Generate Invoice**
   - View complete invoice details
   - Print invoice (Ctrl+P or Print button)
   - Return to table list for next transaction

### Customer Workflow

1. **Browse Menu**
   - Navigate to Customer section
   - View available dishes and combos
   - Search for specific items

2. **View Details**
   - Click on any dish to see details
   - View price, description, and image

---

## Project Structure

```
RestMan20/
├── src/
│   └── main/
│       ├── java/
│       │   ├── dao/                    # Data Access Objects
│       │   │   ├── DAO.java           # Abstract base DAO
│       │   │   ├── StaffDAO.java      # Staff data operations
│       │   │   ├── TableDAO.java      # Table data operations
│       │   │   ├── OrderDAO.java      # Order data operations
│       │   │   ├── InvoiceDAO.java    # Invoice data operations
│       │   │   └── ProductDAO.java    # Product data operations
│       │   │
│       │   ├── model/                  # Domain Models
│       │   │   ├── User.java          # Base user entity
│       │   │   ├── Staff.java         # Staff entity
│       │   │   ├── Customer.java      # Customer entity
│       │   │   ├── Table.java         # Table entity
│       │   │   ├── Order.java         # Order entity
│       │   │   ├── OrderDetail.java   # Order line items
│       │   │   ├── Product.java       # Product entity
│       │   │   ├── ComboItem.java     # Combo components
│       │   │   ├── Invoice.java       # Invoice entity
│       │   │   └── Membercard.java    # Loyalty card
│       │   │
│       │   └── servlet/                # Controllers
│       │       ├── LoginServlet.java          # Authentication
│       │       ├── StaffPageServlet.java      # Staff dashboard
│       │       ├── SearchTableServlet.java    # Table search
│       │       ├── OrderServlet.java          # Order management
│       │       ├── CheckoutServlet.java       # Payment processing
│       │       ├── InvoiceServlet.java        # Invoice display
│       │       ├── SearchDishServlet.java     # Product search
│       │       └── ViewDishDetailServlet.java # Product details
│       │
│       └── webapp/                     # Web Resources
│           ├── index.jsp              # Landing page
│           ├── img/                   # Images
│           └── WEB-INF/
│               ├── web.xml            # Deployment descriptor
│               ├── Customer/          # Customer views
│               │   ├── CustomerPage.jsp
│               │   ├── SearchPage.jsp
│               │   └── DishDetailPage.jsp
│               └── Staff/             # Staff views
│                   ├── LoginPage.jsp
│                   ├── StaffPage.jsp
│                   ├── SearchTablePage.jsp
│                   ├── OrderPage.jsp
│                   └── InvoicePage.jsp
│
├── target/                            # Build output
├── pom.xml                            # Maven configuration
├── database_schema.sql                # Database schema
├── insertData.sql                     # Sample data
├── .env                               # Environment variables
└── README.md                          # This file
```

---

## Database Schema

### Main Tables

#### tblUser
Core user information for both staff and customers.
```sql
CREATE TABLE tblUser (
  id         INT PRIMARY KEY AUTO_INCREMENT,
  fullName   VARCHAR(255) NOT NULL,
  phone      VARCHAR(50),
  email      VARCHAR(255) UNIQUE,
  username   VARCHAR(255) NOT NULL UNIQUE,
  password   VARCHAR(255) NOT NULL,
  role       VARCHAR(255) NOT NULL  -- CUSTOMER/STAFF/ADMIN
);
```

#### tblStaff
Staff-specific information with position.
```sql
CREATE TABLE tblStaff (
  tblUserId  INT PRIMARY KEY,
  position   VARCHAR(255) NOT NULL,
  FOREIGN KEY (tblUserId) REFERENCES tblUser(id)
);
```

#### tblTable
Restaurant table management.
```sql
CREATE TABLE tblTable (
  id          INT PRIMARY KEY AUTO_INCREMENT,
  name        VARCHAR(255) NOT NULL,
  status      INT NOT NULL DEFAULT 0,  -- 0=free, 1=occupied
  description VARCHAR(255)
);
```

#### tblProduct
Products including both dishes and combos.
```sql
CREATE TABLE tblProduct (
  id          INT PRIMARY KEY AUTO_INCREMENT,
  name        VARCHAR(255) NOT NULL,
  description VARCHAR(255),
  price       DECIMAL(12,2) NOT NULL,
  type        VARCHAR(50) NOT NULL,  -- 'DISH' or 'COMBO'
  imageUrl    VARCHAR(255),
  status      INT NOT NULL DEFAULT 1  -- 1=active, 0=inactive
);
```

#### tblOrder
Customer orders linked to tables.
```sql
CREATE TABLE tblOrder (
  id                     INT PRIMARY KEY AUTO_INCREMENT,
  tblCustomertblUserid   INT,
  tblTableid             INT,
  FOREIGN KEY (tblCustomertblUserid) REFERENCES tblCustomer(tblUserid),
  FOREIGN KEY (tblTableid) REFERENCES tblTable(id)
);
```

#### tblOrderDetail
Line items for each order.
```sql
CREATE TABLE tblOrderDetail (
  id              INT PRIMARY KEY AUTO_INCREMENT,
  quantity        INT NOT NULL,
  tblProductid    INT NOT NULL,
  tblOrderid      INT NOT NULL,
  FOREIGN KEY (tblOrderid) REFERENCES tblOrder(id),
  FOREIGN KEY (tblProductid) REFERENCES tblProduct(id)
);
```

#### tblInvoice
Final invoices for completed orders.
```sql
CREATE TABLE tblInvoice (
  id                         INT PRIMARY KEY AUTO_INCREMENT,
  tblOrderid                 INT NOT NULL UNIQUE,
  datetime                   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  bonusPoint                 INT DEFAULT 0,
  tblServertblStafftblUserid INT,
  FOREIGN KEY (tblOrderid) REFERENCES tblOrder(id),
  FOREIGN KEY (tblServertblStafftblUserid) REFERENCES tblServer(tblStafftblUserId)
);
```

### Entity Relationships

```
User (1) ──→ (1) Staff ──→ (1) {Manager/Server/StockClerk}
User (1) ──→ (1) Customer ──→ (0..1) MemberCard
Customer (1) ──→ (0..*) Order
Table (1) ──→ (0..*) Order
Order (1) ──→ (1..*) OrderDetail
Order (1) ──→ (0..1) Invoice
Product (1) ──→ (0..*) OrderDetail
Product (1) ──→ (0..*) ComboItem (as Combo)
Product (1) ──→ (0..*) ComboItem (as Dish)
```

---

## API Endpoints

### Authentication
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/login?role=staff` | Display staff login page |
| POST | `/login` | Authenticate staff credentials |
| POST | `/staffPage?action=logout` | Log out and clear session |

### Staff Operations
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/staffPage` | Display staff dashboard |
| GET | `/searchTable` | List all tables |
| GET | `/searchTable?search={query}` | Search tables by ID/name/customer |

### Order Management
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/order?tableId={id}` | View order details for table |
| POST | `/order?action=remove&detailId={id}` | Remove item from order |
| POST | `/order?action=update&detailId={id}&qty={n}` | Update item quantity |

### Billing
| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/checkout` | Process payment and create invoice |
| GET | `/invoice?id={invoiceId}` | Display invoice details |

### Customer Operations
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/searchDish?query={name}` | Search dishes by name |
| GET | `/viewDishDetail?id={productId}` | View product details |

---

## Testing

### Run Unit Tests

```bash
mvn test
```

### Manual Testing Credentials

| Username | Password | Role |
|----------|----------|------|
| staff1 | password123 | Server |
| staff2 | password123 | Server |
| staff3 | password123 | Server |

### Sample Test Scenarios

1. **Login Flow**
   ```
   Navigate → Login → Enter credentials → Verify dashboard
   ```

2. **Order Processing**
   ```
   Search table → Select table → Modify order → Checkout → Verify invoice
   ```

3. **Product Search**
   ```
   Enter search term → Verify results → Click product → Verify details
   ```

---

## Troubleshooting

### Database Connection Issues

**Problem:** `SQLException: Access denied for user`
```bash
# Solution: Check credentials in .env file
mysql -u root -p
# Then verify database exists
SHOW DATABASES LIKE 'restman';
```

### Build Failures

**Problem:** `Maven compile error`
```bash
# Solution: Clean and rebuild
mvn clean install -U
```

### Deployment Issues

**Problem:** `404 - Application not found`
```bash
# Solution: Verify WAR file deployment
ls $TOMCAT_HOME/webapps/
# Check Tomcat logs
tail -f $TOMCAT_HOME/logs/catalina.out
```

### Session Timeout

**Problem:** User logged out unexpectedly
```xml
<!-- Solution: Increase timeout in web.xml -->
<session-config>
    <session-timeout>60</session-timeout> <!-- 60 minutes -->
</session-config>
```

---

## Deployment

### Production Deployment Checklist

- [ ] Update `.env` with production database credentials
- [ ] Enable HTTPS/SSL
- [ ] Configure firewall rules
- [ ] Set up database backups
- [ ] Enable application logging
- [ ] Configure error pages
- [ ] Implement password hashing (BCrypt)
- [ ] Set up monitoring and alerts

### Docker Deployment (Optional)

```dockerfile
FROM tomcat:9.0-jdk21
COPY target/RestMan20.war /usr/local/tomcat/webapps/
EXPOSE 8080
CMD ["catalina.sh", "run"]
```

---

## Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

### Code Style Guidelines

- Follow Java naming conventions
- Write meaningful commit messages
- Add comments for complex logic
- Include unit tests for new features

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## Authors

- **ThuTrang** - *Initial work* - [ThuTranggggg](https://github.com/ThuTranggggg)

---

## Acknowledgments

- Apache Tomcat Foundation
- MySQL Community
- Java Servlet Specification Team
- Maven Central Repository

---

## Support

For support, please:
- Open an issue on [GitHub Issues](https://github.com/ThuTranggggg/RestMan/issues)
- Check existing documentation in `/docs`
- Review Tomcat logs at `$TOMCAT_HOME/logs/`

---

## Project Status

**Current Version:** 1.0.0  
**Status:** Active Development  
**Last Updated:** November 11, 2025

---

