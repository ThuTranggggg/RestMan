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
        }

        .header {
            background: rgba(255, 255, 255, 0.95);
            padding: 24px 40px;
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
        }

        .back-btn:hover {
            background: #e5e7eb;
        }

        .content {
            flex: 1;
            padding: 40px;
            max-width: 900px;
            margin: 0 auto;
            width: 100%;
        }

        .invoice-card {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 12px;
            padding: 30px;
            box-shadow: 0 4px 12px rgba(15, 23, 42, 0.08);
        }

        .invoice-header {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 30px;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid rgba(15, 23, 42, 0.1);
        }

        .header-item h3 {
            font-size: 12px;
            color: #666;
            font-weight: 700;
            text-transform: uppercase;
            margin-bottom: 6px;
        }

        .header-item p {
            font-size: 18px;
            font-weight: 700;
            color: #0f172a;
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

        .items-table .quantity-input {
            width: 60px;
            padding: 6px;
            border: 1px solid rgba(16, 24, 40, 0.08);
            border-radius: 6px;
            text-align: center;
        }

        .remove-btn {
            padding: 6px 10px;
            background: #fee;
            border: 1px solid #fcc;
            border-radius: 6px;
            color: #c33;
            font-weight: 600;
            cursor: pointer;
            font-size: 12px;
            transition: all 200ms ease;
        }

        .remove-btn:hover {
            background: #fdd;
            border-color: #fbb;
        }

        .total-section {
            background: rgba(15, 23, 42, 0.05);
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 30px;
        }

        .total-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 12px;
            font-size: 14px;
        }

        .total-row.final {
            font-size: 20px;
            font-weight: 800;
            padding-top: 12px;
            border-top: 2px solid rgba(15, 23, 42, 0.1);
            color: #0b8457;
        }

        .bonus-section {
            background: rgba(107, 114, 128, 0.05);
            padding: 16px;
            border-radius: 8px;
            margin-bottom: 30px;
        }

        .bonus-form {
            display: flex;
            gap: 12px;
            align-items: center;
        }

        .bonus-form label {
            font-weight: 600;
            color: #0f172a;
        }

        .bonus-form input {
            flex: 1;
            max-width: 150px;
            padding: 10px 12px;
            border: 1px solid rgba(16, 24, 40, 0.08);
            border-radius: 6px;
            font-size: 14px;
        }

        .action-buttons {
            display: flex;
            gap: 12px;
            justify-content: flex-end;
        }

        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 8px;
            font-weight: 700;
            cursor: pointer;
            transition: all 200ms ease;
            font-size: 15px;
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
            padding: 40px 20px;
            color: #666;
        }

        @media (max-width: 640px) {
            .header {
                flex-direction: column;
                gap: 12px;
            }

            .content {
                padding: 20px;
            }

            .invoice-header {
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
        <h1>Hóa đơn tạm tính</h1>
        <a href="<%= request.getContextPath() %>/searchTable" class="back-btn">← Quay lại</a>
    </div>

    <div class="content">
        <div class="invoice-card">
            <!-- Thông tin hóa đơn -->
            <div class="invoice-header">
                <div class="header-item">
                    <h3>Bàn</h3>
                    <p><%= table.getName() %> (#<%= table.getId() %>)</p>
                </div>
                <div class="header-item">
                    <h3>Khách hàng</h3>
                    <p>
                        <%
                            if (order.getCustomer() != null && order.getCustomer().getId() > 0) {
                                out.print(order.getCustomer().getFullName());
                            } else {
                                out.print("(Chưa chỉ định)");
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
                            <th>Sản phẩm</th>
                            <th>Giá</th>
                            <th>Số lượng</th>
                            <th>Thành tiền</th>
                            <th></th>
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
                            <td><%= detail.getQuantity() %></td>
                            <td class="item-price"><%= String.format("%,.0f", itemTotal) %> đ</td>
                            <td>
                                <form action="<%= request.getContextPath() %>/order" method="post" style="display: inline;">
                                    <input type="hidden" name="action" value="removeProduct" />
                                    <input type="hidden" name="detailId" value="<%= detail.getId() %>" />
                                    <input type="hidden" name="orderId" value="<%= order.getId() %>" />
                                    <button type="submit" class="remove-btn">Xóa</button>
                                </form>
                            </td>
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
                <div class="total-row">
                    <span>Tổng tiền:</span>
                    <span><%= String.format("%,.0f", total) %> đ</span>
                </div>
                <div class="total-row final">
                    <span>Thanh toán</span>
                    <span><%= String.format("%,.0f", total) %> đ</span>
                </div>
            </div>

            <!-- Điểm thưởng -->
            <div class="bonus-section">
                <form action="<%= request.getContextPath() %>/checkout" method="post" class="bonus-form" id="checkoutForm">
                    <label for="bonusPoint">💎 Điểm thưởng cộng thêm:</label>
                    <input type="number" id="bonusPoint" name="bonusPoint" value="0" min="0" />
                    <input type="hidden" name="orderId" value="<%= order.getId() %>" />
                </form>
            </div>

            <!-- Nút hành động -->
            <div class="action-buttons">
                <button type="submit" form="checkoutForm" class="btn btn-checkout">
                    ✓ Xác nhận thanh toán
                </button>
            </div>
        </div>
    </div>
</div>
</body>
</html>
