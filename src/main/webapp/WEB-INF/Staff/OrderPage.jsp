<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Order" %>
<%@ page import="model.OrderDetail" %>
<%@ page import="model.Table" %>
<%@ page import="model.Staff" %>
<%
    Staff staff = (Staff) session.getAttribute("staff");
    if (staff == null) {
        response.sendRedirect(request.getContextPath() + "/");
        return;
    }
    
    Order order = (Order) request.getAttribute("order");
    List<OrderDetail> orderDetails = (List<OrderDetail>) request.getAttribute("orderDetails");
    Double total = (Double) request.getAttribute("total");
    Table table = (Table) request.getAttribute("table");
    
    if (order == null || table == null) {
        response.sendRedirect(request.getContextPath() + "/searchTable");
        return;
    }
    
    if (orderDetails == null) {
        orderDetails = new java.util.ArrayList<>();
    }
    if (total == null) {
        total = 0.0;
    }
    
    // Tạo URL quay lại thông minh
    String backUrl = request.getContextPath() + "/searchTable";
    String searchKeyword = (String) session.getAttribute("searchTableKeyword");
    Integer currentPage = (Integer) session.getAttribute("searchTableCurrentPage");
    
    if (searchKeyword != null && !searchKeyword.isEmpty()) {
        backUrl += "?keyword=" + java.net.URLEncoder.encode(searchKeyword, "UTF-8");
        if (currentPage != null && currentPage > 1) {
            backUrl += "&page=" + currentPage;
        }
    } else if (currentPage != null && currentPage > 1) {
        backUrl += "?page=" + currentPage;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width,initial-scale=1" />
    <title>Hóa đơn tạm tính - RestMan</title>
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
            position: relative;
        }

        .header {
            background: transparent;
            padding: 0;
            box-shadow: none;
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            z-index: 100;
            padding: 12px 30px;
            pointer-events: none;
        }

        .header h1 {
            font-size: 28px;
            font-weight: 800;
            color: #0f172a;
            pointer-events: auto;
        }

        .back-btn {
            padding: 10px 16px;
            background: rgba(255, 255, 255, 0.95);
            border: 1px solid rgba(16, 24, 40, 0.08);
            border-radius: 8px;
            cursor: pointer;
            text-decoration: none;
            font-weight: 600;
            transition: all 200ms ease;
            pointer-events: auto;
            box-shadow: 0 2px 8px rgba(15, 23, 42, 0.06);
        }

        .back-btn:hover {
            background: #e5e7eb;
        }

        .content {
            flex: 1;
            padding: 20px;
            max-width: 600px;
            margin: 0 auto;
            width: 100%;
            display: flex;
            flex-direction: column;
            justify-content: center;
            min-height: 100vh;
        }

        .invoice-card {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 8px;
            padding: 16px;
            box-shadow: 0 4px 16px rgba(15, 23, 42, 0.1);
            max-height: calc(100vh - 24px);
            overflow: visible;
        }

        .invoice-menu {
            width: 100%;
            margin-bottom: 16px;
        }

        .invoice-menu h2 {
            font-size: 28px;
            font-weight: 800;
            color: #0f172a;
            margin-bottom: 8px;
            text-align: center;
        }

        .invoice-menu > p {
            font-size: 14px;
            color: #666;
            margin-bottom: 16px;
            text-align: center;
        }

        .invoice-header {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px;
            margin-bottom: 16px;
            padding-bottom: 12px;
            border-bottom: 2px solid rgba(15, 23, 42, 0.1);
        }

        .header-item h3 {
            font-size: 11px;
            color: #666;
            font-weight: 700;
            text-transform: uppercase;
            margin-bottom: 4px;
        }

        .header-item p {
            font-size: 16px;
            font-weight: 700;
            color: #0f172a;
        }

        .membercard-info {
            background: rgba(59, 130, 246, 0.1);
            border: 1px solid rgba(59, 130, 246, 0.3);
            padding: 6px 10px;
            border-radius: 6px;
            margin-top: 6px;
            display: inline-block;
        }

        .membercard-info p {
            font-size: 12px;
            color: #1e40af;
            font-weight: 600;
            margin: 0;
        }

        .items-section h3 {
            font-size: 14px;
            font-weight: 700;
            margin-bottom: 10px;
            color: #0f172a;
        }

        .items-table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 12px;
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
            width: 10%;
            text-align: left;
        }

        .items-table th:nth-child(2) {
            width: 40%;
            text-align: left;
        }

        .items-table th:nth-child(3) {
            width: 20%;
            text-align: right;
        }

        .items-table th:nth-child(4) {
            width: 15%;
            text-align: center;
        }

        .items-table th:nth-child(5) {
            width: 15%;
            text-align: right;
        }

        .items-table td {
            padding: 6px 6px;
            border-bottom: 1px solid rgba(15, 23, 42, 0.05);
            font-size: 13px;
            word-wrap: break-word;
        }

        .items-table td:nth-child(1) {
            text-align: left;
        }

        .items-table td:nth-child(2) {
            text-align: left;
        }

        .items-table td:nth-child(3) {
            text-align: right;
        }

        .items-table td:nth-child(4) {
            text-align: center;
        }

        .items-table td:nth-child(5) {
            text-align: right;
        }

        .items-table .item-name {
            font-weight: 600;
            color: #0f172a;
        }

        .total-section {
            background: rgba(15, 23, 42, 0.05);
            padding: 8px;
            border-radius: 8px;
            margin-bottom: 16px;
        }

        .total-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 8px;
            font-size: 13px;
        }

        .total-row.final {
            font-size: 16px;
            font-weight: 800;
            padding-top: 8px;
            color: #0b8457;
        }

        .bonus-section {
            background: rgba(107, 114, 128, 0.05);
            padding: 12px;
            border-radius: 8px;
            margin-bottom: 16px;
        }

        .bonus-form {
            display: flex;
            gap: 10px;
            align-items: center;
            font-size: 13px;
        }

        .bonus-form label {
            font-weight: 600;
            color: #0f172a;
            white-space: nowrap;
        }

        .bonus-form input {
            flex: 1;
            max-width: 120px;
            padding: 8px 10px;
            border: 1px solid rgba(16, 24, 40, 0.08);
            border-radius: 6px;
            font-size: 12px;
        }

        .action-buttons {
            display: flex;
            gap: 10px;
            justify-content: flex-end;
        }

        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 8px;
            font-weight: 700;
            cursor: pointer;
            transition: all 200ms ease;
            font-size: 13px;
        }

        .btn-checkout {
            background: linear-gradient(90deg, #0b8457 0%, #056b3f 100%);
            color: white;
        }

        .btn-checkout:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(11, 132, 87, 0.15);
        }

        .no-items {
            text-align: center;
            padding: 20px;
            color: #666;
            font-size: 13px;
        }

        @media (max-width: 640px) {
            .header {
                flex-direction: column;
                gap: 12px;
            }

            .content {
                padding: 12px;
            }

            .invoice-header {
                grid-template-columns: 1fr;
            }

            .items-table {
                font-size: 11px;
            }

            .items-table th,
            .items-table td {
                padding: 6px;
            }

            .action-buttons {
                flex-direction: column;
            }

            .btn {
                width: 100%;
            }
        }
    </style>
</head>
<body>
<div class="wrap">
    <div class="header">
        <h1>RestMan</h1>
        <a href="<%= backUrl %>" class="back-btn">Quay lại</a>
    </div>

    <div class="content">
        <div class="invoice-menu">
            <h2>Hóa đơn tạm tính</h2>
            <p>Thông tin bàn và danh sách sản phẩm</p>
        </div>

        <div class="invoice-card">
            <!-- Thông tin hóa đơn -->
            <div class="invoice-header">
                <div class="header-item">
                    <h3>Bàn</h3>
                    <p><%= table.getName() %> (ID: <%= table.getId() %>)</p>
                </div>
                <div class="header-item">
                    <h3>Khách hàng</h3>
                    <p>
                        <%
                            if (order.getCustomer() != null && order.getCustomer().getId() > 0) {
                                out.print(order.getCustomer().getFullName());
                                if (order.getCustomer().getMembercard() != null) {
                        %>
                    </p>
                    <div class="membercard-info">
                        <p>💳 THẺ THÀNH VIÊN: #<%= order.getCustomer().getMembercard().getId() %></p>
                    </div>
                    <p>
                        <%
                                }
                            } else {
                                out.print("(Khách vãng lai)");
                            }
                        %>
                    </p>
                </div>
            </div>

            <!-- Danh sách sản phẩm -->
            <div class="items-section">
                <h3>Danh sách sản phẩm</h3>

                <%
                    if (orderDetails.isEmpty()) {
                %>
                <div class="no-items">
                    <p>🛒 Chưa có sản phẩm nào trong đơn hàng</p>
                </div>
                <%
                    } else {
                %>
                <table class="items-table">
                    <thead>
                        <tr>
                            <th>STT</th>
                            <th>Sản phẩm</th>
                            <th>Giá</th>
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
                            <td><%= orderDetails.indexOf(detail) + 1 %></td>
                            <td class="item-name"><%= detail.getProduct().getName() %></td>
                            <td><%= String.format("%,.0f", detail.getProduct().getPrice()) %> đ</td>
                            <td><%= detail.getQuantity() %></td>
                            <td><%= String.format("%,.0f", itemTotal) %> đ</td>
                        </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
                <%
                    }
                %>
            </div>

            <!-- Tổng tiền -->
            <div class="total-section">
                <div class="total-row final">
                    <span>Tổng tiền:</span>
                    <span><%= String.format("%,.0f", total) %> đ</span>
                </div>
            </div>

            <!-- Điểm thưởng (chỉ hiển thị nếu khách hàng có thẻ thành viên) -->
            <%
                if (order.getCustomer() != null && order.getCustomer().getId() > 0 && order.getCustomer().getMembercard() != null) {
            %>
            <div class="bonus-section">
                <form action="<%= request.getContextPath() %>/checkout" method="post" class="bonus-form" id="checkoutForm">
                    <label for="bonusPoint">💎 Điểm thưởng:</label>
                    <input type="number" id="bonusPoint" name="bonusPoint" value="0" min="0" />
                    <input type="hidden" name="orderId" value="<%= order.getId() %>" />
                </form>
            </div>
            <%
                } else {
            %>
            <div class="bonus-section" style="background: rgba(107, 114, 128, 0.1);">
                <p style="font-size: 13px; color: #666; margin: 0;">ℹ️ Khách hàng không có thẻ thành viên, không thể cộng điểm thưởng</p>
            </div>
            <form action="<%= request.getContextPath() %>/checkout" method="post" id="checkoutForm" style="display: none;">
                <input type="hidden" name="bonusPoint" value="0" />
                <input type="hidden" name="orderId" value="<%= order.getId() %>" />
            </form>
            <%
                }
            %>

            <!-- Nút hành động -->
            <div class="action-buttons">
                <button type="submit" form="checkoutForm" class="btn btn-checkout">
                    Xác nhận
                </button>
            </div>
        </div>
    </div>
</div>
</body>
</html>
