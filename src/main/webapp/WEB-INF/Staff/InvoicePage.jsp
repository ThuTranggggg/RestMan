<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="model.Invoice" %>
<%@ page import="model.OrderDetail" %>
<%@ page import="model.Staff" %>
<%
    Staff staff = (Staff) session.getAttribute("staff");
    if (staff == null) {
        response.sendRedirect(request.getContextPath() + "/");
        return;
    }
    
    Invoice invoice = (Invoice) request.getAttribute("invoice");
    List<OrderDetail> orderDetails = (List<OrderDetail>) request.getAttribute("orderDetails");
    Double total = (Double) request.getAttribute("total");
    
    if (invoice == null) {
        response.sendRedirect(request.getContextPath() + "/searchTable");
        return;
    }
    
    if (orderDetails == null) {
        orderDetails = new java.util.ArrayList<>();
    }
    if (total == null) {
        total = 0.0;
    }
    
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("HH:mm:ss dd/MM/yyyy");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width,initial-scale=1" />
    <title>Hóa đơn - RestMan</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
            background: linear-gradient(180deg, #f4cada 0%, #cef4f6 100%);
            color: #0f172a;
            -webkit-font-smoothing: antialiased;
            -moz-osx-font-smoothing: grayscale;
            min-height: 100vh;
        }

        .wrap {
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            padding: 40px 20px;
        }

        .invoice-container {
            max-width: 800px;
            margin: 0 auto;
            background: white;
            border-radius: 12px;
            box-shadow: 0 8px 32px rgba(15, 23, 42, 0.12);
            overflow: hidden;
        }

        .invoice-header {
            background: linear-gradient(90deg, #296265 0%, #112d59 100%);
            color: white;
            padding: 40px 30px;
            text-align: center;
        }

        .invoice-header h1 {
            font-size: 32px;
            margin-bottom: 8px;
        }

        .invoice-number {
            font-size: 14px;
            opacity: 0.9;
        }

        .invoice-content {
            padding: 30px;
        }

        .info-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid rgba(15, 23, 42, 0.1);
        }

        .info-item h4 {
            font-size: 12px;
            color: #666;
            font-weight: 700;
            text-transform: uppercase;
            margin-bottom: 6px;
        }

        .info-item p {
            font-size: 15px;
            font-weight: 600;
            color: #0f172a;
            line-height: 1.6;
        }

        .items-section h3 {
            font-size: 16px;
            font-weight: 700;
            margin-bottom: 16px;
            color: #0f172a;
        }

        .items-table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
        }

        .items-table thead {
            background: rgba(15, 23, 42, 0.05);
        }

        .items-table th {
            padding: 12px;
            text-align: left;
            font-size: 13px;
            font-weight: 700;
            color: #0f172a;
        }

        .items-table td {
            padding: 12px;
            border-bottom: 1px solid rgba(15, 23, 42, 0.08);
            font-size: 14px;
        }

        .items-table .item-name {
            font-weight: 700;
            color: #0f172a;
        }

        .items-table .item-price {
            text-align: right;
        }

        .summary-section {
            background: rgba(15, 23, 42, 0.05);
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 30px;
        }

        .summary-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
            font-size: 14px;
        }

        .summary-row.total {
            font-size: 18px;
            font-weight: 800;
            padding-top: 10px;
            border-top: 2px solid rgba(15, 23, 42, 0.1);
            color: #0b8457;
        }

        .summary-row.bonus {
            color: #6b72e0;
            font-weight: 700;
        }

        .staff-info {
            text-align: center;
            padding: 20px;
            background: rgba(15, 23, 42, 0.02);
            border-top: 1px solid rgba(15, 23, 42, 0.1);
            font-size: 13px;
            color: #666;
        }

        .staff-info strong {
            display: block;
            color: #0f172a;
            font-weight: 700;
            margin-bottom: 4px;
        }

        .action-buttons {
            padding: 30px;
            background: rgba(15, 23, 42, 0.02);
            display: flex;
            gap: 12px;
            justify-content: center;
            flex-wrap: wrap;
        }

        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 8px;
            font-weight: 700;
            cursor: pointer;
            transition: all 200ms ease;
            font-size: 14px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .btn-print {
            background: linear-gradient(90deg, #296265 0%, #112d59 100%);
            color: white;
        }

        .btn-print:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(25, 118, 210, 0.15);
        }

        .btn-back {
            background: #f3f4f6;
            color: #0f172a;
            border: 1px solid rgba(16, 24, 40, 0.08);
        }

        .btn-back:hover {
            background: #e5e7eb;
        }

        @media print {
            body {
                background: white;
            }

            .wrap {
                padding: 0;
            }

            .invoice-container {
                box-shadow: none;
            }

            .action-buttons {
                display: none;
            }
        }

        @media (max-width: 640px) {
            .invoice-content {
                padding: 20px;
            }

            .info-grid {
                grid-template-columns: 1fr;
            }

            .items-table {
                font-size: 12px;
            }

            .items-table th,
            .items-table td {
                padding: 8px;
            }

            .action-buttons {
                flex-direction: column;
                padding: 20px;
            }

            .btn {
                width: 100%;
                justify-content: center;
            }
        }
    </style>
    <script>
        function printInvoice() {
            window.print();
        }
    </script>
</head>
<body>
<div class="wrap">
    <div class="invoice-container">
        <!-- Header -->
        <div class="invoice-header">
            <h1>HÓA ĐƠN</h1>
            <div class="invoice-number">Số hiệu: <%= invoice.getId() %></div>
        </div>

        <!-- Content -->
        <div class="invoice-content">
            <!-- Thông tin chi tiết -->
            <div class="info-grid">
                <div class="info-item">
                    <h4>Thời gian</h4>
                    <p><%= invoice.getDatetime().format(formatter) %></p>
                </div>
                <div class="info-item">
                    <h4>Nhân viên</h4>
                    <p>
                        <%
                            if (invoice.getStaff() != null && invoice.getStaff().getUser() != null) {
                                out.print(invoice.getStaff().getUser().getFullName());
                            } else {
                                out.print("(Không có thông tin)");
                            }
                        %>
                    </p>
                </div>
                <div class="info-item">
                    <h4>Bàn</h4>
                    <p><%= invoice.getOrder().getTable().getName() %> (#<%= invoice.getOrder().getTable().getId() %>)</p>
                </div>
                <div class="info-item">
                    <h4>Khách hàng</h4>
                    <p>
                        <%
                            if (invoice.getOrder().getCustomer() != null && invoice.getOrder().getCustomer().getId() > 0) {
                                out.print(invoice.getOrder().getCustomer().getFullName());
                            } else {
                                out.print("(Khách vãng lai)");
                            }
                        %>
                    </p>
                </div>
            </div>

            <!-- Danh sách sản phẩm -->
            <div class="items-section">
                <h3>Chi tiết sản phẩm</h3>
                <table class="items-table">
                    <thead>
                        <tr>
                            <th>Sản phẩm</th>
                            <th>Đơn giá</th>
                            <th>Số lượng</th>
                            <th>Thành tiền</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            for (OrderDetail detail : orderDetails) {
                                double itemTotal = detail.getQuantity() * detail.getProduct().getPrice();
                        %>
                        <tr>
                            <td class="item-name"><%= detail.getProduct().getName() %></td>
                            <td class="item-price"><%= String.format("%,.0f", detail.getProduct().getPrice()) %> đ</td>
                            <td style="text-align: center;"><%= detail.getQuantity() %></td>
                            <td class="item-price"><%= String.format("%,.0f", itemTotal) %> đ</td>
                        </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
            </div>

            <!-- Tóm tắt -->
            <div class="summary-section">
                <div class="summary-row">
                    <span>Tổng tiền:</span>
                    <span><%= String.format("%,.0f", total) %> đ</span>
                </div>
                <%
                    if (invoice.getBonusPoint() > 0) {
                %>
                <div class="summary-row bonus">
                    <span>Điểm thưởng:</span>
                    <span>+<%= invoice.getBonusPoint() %> điểm</span>
                </div>
                <%
                    }
                %>
                <div class="summary-row total">
                    <span>Thanh toán:</span>
                    <span><%= String.format("%,.0f", total) %> đ</span>
                </div>
            </div>

            <!-- Thông tin nhân viên -->
            <div class="staff-info">
                <%
                    if (invoice.getStaff() != null && invoice.getStaff().getUser() != null) {
                %>
                <strong><%= invoice.getStaff().getUser().getFullName() %></strong>
                Nhân viên bán hàng - <%= invoice.getStaff().getPosition() %>
                <%
                    } else {
                %>
                <strong>Nhân viên</strong>
                Chưa có thông tin
                <%
                    }
                %>
            </div>
        </div>

        <!-- Action Buttons -->
        <div class="action-buttons">
            <button onclick="printInvoice()" class="btn btn-print">
                🖨️ In hóa đơn
            </button>
            <a href="<%= request.getContextPath() %>/searchTable" class="btn btn-back">
                ← Quay lại
            </a>
        </div>
    </div>
</div>
</body>
</html>
