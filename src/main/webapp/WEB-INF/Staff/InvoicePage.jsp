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
            padding: 0;
        }

        .header {
            background: rgba(255, 255, 255, 0.95);
            padding: 9px 30px;
            box-shadow: 0 2px 8px rgba(15, 23, 42, 0.06);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .header h1 {
            font-size: 28px;
            font-weight: 800;
            color: #0f172a;
        }

        .back-btn {
            padding: 10px 16px;
            background: #f3f4f6;
            border: 1px solid rgba(16, 24, 40, 0.08);
            border-radius: 8px;
            cursor: pointer;
            text-decoration: none;
            font-weight: 600;
            transition: all 200ms ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            color: #0f172a;
        }

        .back-btn:hover {
            background: #e5e7eb;
        }

        .invoice-wrapper {
            flex: 1;
            padding: 12px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
        }

        .invoice-container {
            width: 100%;
            max-width: 600px;
            background: white;
            border-radius: 8px;
            box-shadow: 0 4px 16px rgba(15, 23, 42, 0.1);
            overflow: hidden;
            display: flex;
            flex-direction: column;
        }

        .invoice-header-title {
            background: #f8f9fa;
            padding: 10px 14px;
            border-bottom: 1px solid rgba(15, 23, 42, 0.08);
            text-align: center;
        }

        .invoice-header-title h2 {
            font-size: 18px;
            font-weight: 700;
            color: #0f172a;
            margin: 0;
        }

        .invoice-content {
            padding: 11px 13px;
            flex: 1;
            overflow-y: auto;
            max-height: calc(100vh - 190px);
        }

        .info-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 10px;
            margin-bottom: 11px;
            padding-bottom: 9px;
            border-bottom: 1px solid rgba(15, 23, 42, 0.08);
        }

        .info-item h4 {
            font-size: 11px;
            color: #999;
            font-weight: 700;
            text-transform: uppercase;
            margin-bottom: 3px;
        }

        .info-item p {
            font-size: 14px;
            font-weight: 600;
            color: #0f172a;
            line-height: 1.3;
        }

        .items-section h3 {
            font-size: 13px;
            font-weight: 700;
            margin-bottom: 8px;
            margin-top: 9px;
            color: #0f172a;
        }

        .items-table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 9px;
            font-size: 13px;
            table-layout: fixed;
        }

        .items-table thead {
            background: rgba(15, 23, 42, 0.04);
        }

        .items-table th {
            padding: 6px 6px;
            text-align: left;
            font-size: 12px;
            font-weight: 700;
            color: #0f172a;
            border-bottom: 1px solid rgba(15, 23, 42, 0.1);
            word-wrap: break-word;
        }

        .items-table th:nth-child(1) {
            width: 50%;
        }

        .items-table th:nth-child(2) {
            width: 20%;
            text-align: right;
        }

        .items-table th:nth-child(3) {
            width: 15%;
            text-align: center;
        }

        .items-table th:nth-child(4) {
            width: 15%;
            text-align: right;
        }

        .items-table td {
            padding: 6px 6px;
            border-bottom: 1px solid rgba(15, 23, 42, 0.05);
            font-size: 13px;
            word-wrap: break-word;
        }

        .items-table .item-name {
            font-weight: 600;
            color: #0f172a;
        }

        .items-table td:nth-child(2) {
            text-align: right;
        }

        .items-table td:nth-child(3) {
            text-align: center;
        }

        .items-table .item-price {
            text-align: right;
        }

        .summary-section {
            background: rgba(15, 23, 42, 0.04);
            padding: 10px 12px;
            border-radius: 4px;
            margin-bottom: 9px;
            border: 1px solid rgba(15, 23, 42, 0.08);
        }

        .summary-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 4px;
            font-size: 13px;
        }

        .summary-row.total {
            font-size: 15px;
            font-weight: 800;
            padding-top: 6px;
            color: #0b8457;
            margin-bottom: 0;
        }

        .summary-row.bonus {
            color: #6b72e0;
            font-weight: 700;
            font-size: 12px;
        }

        .membercard-section {
            background: linear-gradient(135deg, rgba(107, 114, 224, 0.08) 0%, rgba(11, 132, 87, 0.08) 100%);
            border: 1px solid rgba(107, 114, 224, 0.15);
            padding: 10px 12px;
            border-radius: 4px;
            margin-bottom: 9px;
        }

        .membercard-header {
            font-size: 11px;
            font-weight: 700;
            color: #6b72e0;
            text-transform: uppercase;
            margin-bottom: 6px;
        }

        .membercard-row {
            display: flex;
            justify-content: space-between;
            font-size: 13px;
            margin-bottom: 3px;
        }

        .membercard-row:last-child {
            margin-bottom: 0;
        }

        .membercard-row strong {
            color: #0f172a;
            font-weight: 700;
        }

        .staff-info {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px 12px;
            background: rgba(15, 23, 42, 0.02);
            border-top: 1px solid rgba(15, 23, 42, 0.08);
            font-size: 12px;
            color: #666;
            line-height: 1.4;
        }

        .staff-info strong {
            color: #0f172a;
            font-weight: 700;
        }

        .staff-name {
            flex: 1;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .staff-time {
            white-space: nowrap;
            flex-shrink: 0;
            margin-left: 12px;
            font-size: 12px;
        }

        .action-buttons {
            padding: 10px 14px;
            background: rgba(15, 23, 42, 0.02);
            display: flex;
            gap: 8px;
            justify-content: center;
            flex-wrap: wrap;
            border-top: 1px solid rgba(15, 23, 42, 0.08);
        }

        .btn {
            padding: 9px 18px;
            border: none;
            border-radius: 6px;
            font-weight: 700;
            cursor: pointer;
            transition: all 200ms ease;
            font-size: 14px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        .btn-print {
            background: linear-gradient(90deg, #296265 0%, #112d59 100%);
            color: white;
        }

        .btn-print:hover {
            transform: translateY(-1px);
            box-shadow: 0 2px 8px rgba(25, 118, 210, 0.15);
        }

        @media print {
            body {
                background: white;
                min-height: auto;
            }

            .wrap {
                padding: 0;
                min-height: auto;
            }

            .header {
                display: none;
            }

            .invoice-wrapper {
                padding: 0;
                justify-content: flex-start;
            }

            .invoice-container {
                box-shadow: none;
                border-radius: 0;
                max-width: 100%;
            }

            .invoice-content {
                max-height: none;
                overflow: visible;
            }

            .action-buttons {
                display: none;
            }
        }

        @media (max-width: 640px) {
            .header {
                flex-direction: column;
                gap: 10px;
                padding: 8px 12px;
            }

            .header h1 {
                font-size: 22px;
            }

            .back-btn {
                width: 100%;
                justify-content: center;
                padding: 8px 12px;
                font-size: 13px;
            }

            .invoice-wrapper {
                padding: 8px;
            }

            .invoice-container {
                max-width: 100%;
            }

            .invoice-header-title h2 {
                font-size: 18px;
            }

            .invoice-content {
                max-height: calc(100vh - 160px);
            }

            .info-grid {
                grid-template-columns: 1fr;
                gap: 8px;
            }

            .items-table {
                font-size: 11px;
            }

            .items-table th,
            .items-table td {
                padding: 5px 5px;
            }

            .staff-info {
                flex-direction: column;
                align-items: flex-start;
                gap: 4px;
            }

            .staff-name {
                width: 100%;
            }

            .staff-time {
                margin-left: 0;
            }

            .action-buttons {
                padding: 8px 10px;
            }

            .btn {
                padding: 7px 14px;
                font-size: 12px;
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
    <div class="header">
        <h1>RestMan</h1>
        <a href="<%= request.getContextPath() %>/searchTable" class="back-btn">← Trở về</a>
    </div>

    <div class="invoice-wrapper">
        <div class="invoice-container">
            <div class="invoice-header-title">
                <h2>Hóa đơn</h2>
            </div>

            <div class="invoice-content">
            <div class="info-grid">
                <div class="info-item">
                    <h4>Bàn</h4>
                    <p><%= invoice.getTable().getName() %> (#<%= invoice.getTable().getId() %>)</p>
                </div>
                <div class="info-item">
                    <h4>Khách hàng</h4>
                    <p>
                        <%
                            if (invoice.getCustomer() != null && invoice.getCustomer().getId() > 0) {
                                out.print(invoice.getCustomer().getFullName());
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
                <div class="summary-row total">
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
            </div>

            <!-- Thẻ thành viên -->
            <%
                if (invoice.getCustomer() != null && invoice.getCustomer().getId() > 0 
                    && invoice.getCustomer().getMembercard() != null) {
            %>
            <div class="membercard-section">
                <div class="membercard-header">💳 Thẻ thành viên</div>
                <div class="membercard-row">
                    <span>ID thẻ:</span>
                    <strong>#<%= invoice.getCustomer().getMembercard().getId() %></strong>
                </div>
                <div class="membercard-row">
                    <span>Điểm hiện tại:</span>
                    <strong><%= invoice.getCustomer().getMembercard().getPoint() %> điểm</strong>
                </div>
            </div>
            <%
                }
            %>

            <!-- Thông tin nhân viên -->
            <div class="staff-info">
                <div class="staff-name">
                    <%
                        if (invoice.getServer() != null && invoice.getServer().getUser() != null) {
                    %>
                    Nhân viên: <strong><%= invoice.getServer().getUser().getFullName() %></strong>
                    <%
                        } else {
                    %>
                    <strong>Chưa có thông tin nhân viên</strong>
                    <%
                        }
                    %>
                </div>
                <div class="staff-time">
                    <%= invoice.getDatetime().format(formatter) %>
                </div>
            </div>
        </div>

        <!-- Action Buttons -->
        <div class="action-buttons">
            <button onclick="printInvoice()" class="btn btn-print">
                🖨️ In hóa đơn
            </button>
        </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
