<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Table" %>
<%@ page import="model.Staff" %>
<%
    Staff staff = (Staff) session.getAttribute("staff");
    if (staff == null) {
        response.sendRedirect(request.getContextPath() + "/");
        return;
    }
    
    List<Table> tables = (List<Table>) request.getAttribute("tables");
    String keyword = (String) request.getAttribute("keyword");
    String error = (String) request.getAttribute("error");
    
    if (tables == null) {
        tables = new java.util.ArrayList<>();
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width,initial-scale=1" />
    <title>Tìm kiếm bàn - Thanh toán - RestMan</title>
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
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .back-btn:hover {
            background: #e5e7eb;
        }

        .content {
            flex: 1;
            padding: 40px;
            max-width: 1200px;
            margin: 0 auto;
            width: 100%;
        }

        .search-section {
            background: rgba(255, 255, 255, 0.9);
            padding: 24px;
            border-radius: 12px;
            margin-bottom: 30px;
            box-shadow: 0 2px 6px rgba(15, 23, 42, 0.06);
        }

        .search-form {
            display: flex;
            gap: 12px;
            align-items: center;
        }

        .search-form input[type="text"] {
            flex: 1;
            min-width: 200px;
            padding: 12px 14px;
            border: 1px solid rgba(16, 24, 40, 0.08);
            border-radius: 8px;
            font-size: 15px;
        }

        .search-form input[type="text"]:focus {
            outline: none;
            border-color: #0f172a;
            box-shadow: 0 0 0 3px rgba(15, 23, 42, 0.1);
        }

        .search-form button {
            padding: 12px 24px;
            background: linear-gradient(90deg, #296265 0%, #112d59 100%);
            color: white;
            border: none;
            border-radius: 8px;
            font-weight: 700;
            cursor: pointer;
            transition: all 200ms ease;
        }

        .search-form button:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(25, 118, 210, 0.15);
        }

        .info-text {
            font-size: 14px;
            color: #666;
            margin-top: 12px;
        }

        .error-message {
            background-color: #fee;
            border: 1px solid #fcc;
            color: #c33;
            padding: 14px;
            border-radius: 8px;
            margin-bottom: 20px;
        }

        .tables-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 16px;
        }

        .table-card {
            background: rgba(255, 255, 255, 0.9);
            border: 2px solid rgba(15, 23, 42, 0.1);
            border-radius: 12px;
            padding: 20px;
            text-decoration: none;
            color: inherit;
            cursor: pointer;
            transition: all 200ms ease;
            text-align: center;
        }

        .table-card:hover {
            background: white;
            border-color: #0f172a;
            transform: translateY(-4px);
            box-shadow: 0 8px 24px rgba(15, 23, 42, 0.15);
        }

        .table-card:active {
            transform: translateY(-2px);
        }

        .table-id {
            font-size: 36px;
            font-weight: 800;
            color: #0f172a;
            margin-bottom: 8px;
        }

        .table-name {
            font-size: 16px;
            font-weight: 700;
            color: #0f172a;
            margin-bottom: 12px;
        }

        .table-info {
            font-size: 13px;
            color: #666;
            line-height: 1.4;
        }

        .no-tables {
            text-align: center;
            padding: 60px 20px;
            color: #666;
        }

        .no-tables h3 {
            font-size: 20px;
            margin-bottom: 8px;
        }

        .no-tables p {
            font-size: 14px;
        }

        @media (max-width: 640px) {
            .header {
                flex-direction: column;
                gap: 16px;
            }

            .content {
                padding: 20px;
            }

            .search-form {
                flex-direction: column;
            }

            .tables-grid {
                grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
                gap: 12px;
            }

            .table-id {
                font-size: 28px;
            }
        }
    </style>
</head>
<body>
<div class="wrap">
    <div class="header">
        <h1>Tìm kiếm bàn</h1>
        <a href="<%= request.getContextPath() %>/staffPage" class="back-btn">← Quay lại</a>
    </div>

    <div class="content">
        <div class="search-section">
            <p style="margin-bottom: 16px; font-weight: 700;">Tìm kiếm bàn cần thanh toán</p>
            <form action="<%= request.getContextPath() %>/searchTable" method="get" class="search-form">
                <input type="text" name="keyword" placeholder="Nhập ID bàn, tên bàn hoặc tên khách hàng..."
                       value="<%= keyword != null ? keyword : "" %>" />
                <button type="submit">🔍 Tìm kiếm</button>
            </form>
            <div class="info-text">
                💡 Các bàn hiển thị dưới đây đang được phục vụ. Nhấn vào bàn để xem hóa đơn tạm tính.
            </div>
        </div>

        <%
            if (error != null) {
        %>
        <div class="error-message">
            <%= error %>
        </div>
        <%
            }
        %>

        <%
            if (tables.isEmpty()) {
        %>
        <div class="no-tables">
            <h3>Không tìm thấy bàn nào</h3>
            <p>
                <%
                    if (keyword != null && !keyword.isEmpty()) {
                %>
                Không có bàn nào khớp với từ khóa "<%= keyword %>"
                <%
                    } else {
                %>
                Hiện không có bàn nào đang được phục vụ
                <%
                    }
                %>
            </p>
        </div>
        <%
            } else {
        %>
        <div class="tables-grid">
            <%
                for (Table table : tables) {
            %>
            <a href="<%= request.getContextPath() %>/order?tableId=<%= table.getId() %>" class="table-card">
                <div class="table-id">#<%= table.getId() %></div>
                <div class="table-name"><%= table.getName() %></div>
                <div class="table-info">
                    <% if (table.getDescription() != null && !table.getDescription().isEmpty()) { %>
                    <div><%= table.getDescription() %></div>
                    <% } %>
                </div>
            </a>
            <%
                }
            %>
        </div>
        <%
            }
        %>
    </div>
</div>
</body>
</html>
