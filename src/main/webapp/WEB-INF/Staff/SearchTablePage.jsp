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
    
    // Phân trang: 2 hàng bàn x 6 cột = 12 bàn/trang
    int tablesPerPage = 12;
    int currentPage = 1;
    String pageParam = request.getParameter("page");
    if (pageParam != null) {
        try {
            currentPage = Integer.parseInt(pageParam);
            if (currentPage < 1) currentPage = 1;
        } catch (NumberFormatException e) {
            currentPage = 1;
        }
    }
    
    int totalPages = (int) Math.ceil((double) tables.size() / tablesPerPage);
    if (currentPage > totalPages && totalPages > 0) {
        currentPage = totalPages;
    }
    
    int startIndex = (currentPage - 1) * tablesPerPage;
    int endIndex = Math.min(startIndex + tablesPerPage, tables.size());
    List<Table> pageTablesList = tables.subList(startIndex, endIndex);
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
            flex-shrink: 0;
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
            display: inline-flex;
            align-items: center;
            gap: 8px;
            pointer-events: auto;
            box-shadow: 0 2px 8px rgba(15, 23, 42, 0.06);
        }

        .back-btn:hover {
            background: #e5e7eb;
        }

        .content {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: flex-start;
            padding: 40px;
            width: 100%;
            overflow-y: auto;
            margin-top: 0;
        }

        .search-menu {
            width: 100%;
            max-width: 1200px;
            text-align: center;
            flex-shrink: 0;
        }

        .search-menu h2 {
            font-size: 32px;
            font-weight: 800;
            color: #0f172a;
            margin-bottom: 12px;
            text-align: center;
        }

        .search-menu > p {
            font-size: 16px;
            color: #666;
            margin-bottom: 24px;
            text-align: center;
        }

        .search-section {
            background: none;
            padding: 10px;
            border-radius: 12px;
            margin-bottom: 30px;
            flex-shrink: 0;
        }

        .search-form {
            display: flex;
            gap: 15px;
            align-items: center;
            justify-content: center;
        }

        .search-form input[type="text"] {
            flex: 0 1 400px;
            min-width: 200px;
            max-width: 500px;
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
            max-width: 1000px;
            width: 100%;
            flex-shrink: 0;
        }

        .tables-grid {
            display: grid;
            grid-template-columns: repeat(6, minmax(120px, 1fr));
            gap: 12px;
            width: 100%;
            max-width: 1000px;
            margin: 0 auto;
            flex-shrink: 0;
        }

        .table-card {
            background: rgba(255, 255, 255, 0.9);
            border: 2px solid rgba(15, 23, 42, 0.1);
            border-radius: 12px;
            padding: 14px 12px;
            text-decoration: none;
            color: inherit;
            cursor: pointer;
            transition: all 200ms ease;
            text-align: center;
            min-height: auto;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            gap: 5px;
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
            font-size: 26px;
            font-weight: 800;
            color: #0f172a;
            line-height: 1;
        }

        .table-name {
            font-size: 13px;
            font-weight: 500;
            color: #666666;
            line-height: 1.2;
            word-break: break-word;
        }

        .table-info {
            font-size: 12px;
            color: #666;
            line-height: 1.2;
            word-break: break-word;
        }

        .no-tables {
            text-align: center;
            padding: 60px 20px;
            color: #666;
            flex-shrink: 0;
        }

        .no-tables h3 {
            font-size: 20px;
            margin-bottom: 8px;
        }

        .no-tables p {
            font-size: 14px;
        }

        .pagination-wrapper {
            display: flex;
            flex-direction: column;
            align-items: center;
            width: 100%;
            flex-shrink: 0;
        }

        .pagination {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 8px;
            margin-top: 20px;
            margin-bottom: 0;
            flex-wrap: wrap;
            flex-shrink: 0;
            width: 100%;
            max-width: 1000px;
        }

        .pagination a, .pagination span {
            padding: 8px 12px;
            border: 1px solid rgba(15, 23, 42, 0.1);
            border-radius: 6px;
            text-decoration: none;
            color: #0f172a;
            font-weight: 600;
            transition: all 200ms ease;
            cursor: pointer;
            font-size: 13px;
        }

        .pagination a:hover {
            background: #0f172a;
            color: white;
            border-color: #0f172a;
        }

        .pagination a.active {
            background: #0f172a;
            color: white;
            border-color: #0f172a;
        }

        .pagination span.disabled {
            color: #ccc;
            cursor: not-allowed;
            border-color: #e5e7eb;
        }

        .pagination span {
            cursor: default;
        }

        .pagination-info {
            text-align: center;
            color: #999;
            font-size: 13px;
            margin-bottom: 12px;
            margin-top: 20px;
            flex-shrink: 0;
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
                grid-template-columns: repeat(3, minmax(100px, 1fr));
                gap: 10px;
                max-width: 100%;
            }

            .table-id {
                font-size: 24px;
            }
        }
    </style>
</head>
<body>
<div class="wrap">
    <div class="header">
        <h1>RestMan</h1>
        <a href="<%= request.getContextPath() %>/staffPage" class="back-btn">Quay lại</a>
    </div>

    <div class="content">
        <div class="search-menu">
            <h2>Tìm kiếm bàn</h2>
            <p>Chọn bàn để xem và thanh toán hóa đơn</p>

            <div class="search-section">
                <form action="<%= request.getContextPath() %>/searchTable" method="get" class="search-form">
                    <input type="text" name="keyword" placeholder="Nhập ID bàn, tên bàn hoặc tên khách hàng..."
                           value="<%= keyword != null ? keyword : "" %>" />
                    <button type="submit">Tìm kiếm</button>
                </form>
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
                for (Table table : pageTablesList) {
            %>
            <a href="<%= request.getContextPath() %>/order?tableId=<%= table.getId() %>" class="table-card">
                <div class="table-id">#<%= table.getId() %></div>
                <div class="table-name">
                    <%= table.getName() %>
                    <% if (table.getDescription() != null && !table.getDescription().isEmpty()) { %>
                    - <%= table.getDescription() %>
                    <% } %>
                </div>
            </a>
            <%
                }
            %>
        </div>

        <div class="pagination-wrapper">
            <%
                if (totalPages > 1) {
            %>
            <div class="pagination-info">
                Tổng cộng <%= tables.size() %> bàn đang được phục vụ
            </div>

            <div class="pagination">
            <%
                if (currentPage > 1) {
            %>
            <a href="<%= request.getContextPath() %>/searchTable?page=<%= currentPage - 1 %><%= keyword != null && !keyword.isEmpty() ? "&keyword=" + java.net.URLEncoder.encode(keyword, "UTF-8") : "" %>">
                ←
            </a>
            <%
                } else {
            %>
            <span class="disabled">←</span>
            <%
                }
            %>

            <%
                // Hiển thị các trang
                int startPage = Math.max(1, currentPage - 2);
                int endPage = Math.min(totalPages, currentPage + 2);

                if (startPage > 1) {
            %>
            <span>...</span>
            <%
                }

                for (int i = startPage; i <= endPage; i++) {
                    if (i == currentPage) {
            %>
            <a href="<%= request.getContextPath() %>/searchTable?page=<%= i %><%= keyword != null && !keyword.isEmpty() ? "&keyword=" + java.net.URLEncoder.encode(keyword, "UTF-8") : "" %>" class="active">
                <%= i %>
            </a>
            <%
                    } else {
            %>
            <a href="<%= request.getContextPath() %>/searchTable?page=<%= i %><%= keyword != null && !keyword.isEmpty() ? "&keyword=" + java.net.URLEncoder.encode(keyword, "UTF-8") : "" %>">
                <%= i %>
            </a>
            <%
                    }
                }

                if (endPage < totalPages) {
            %>
            <span>...</span>
            <%
                }
            %>

            <%
                if (currentPage < totalPages) {
            %>
            <a href="<%= request.getContextPath() %>/searchTable?page=<%= currentPage + 1 %><%= keyword != null && !keyword.isEmpty() ? "&keyword=" + java.net.URLEncoder.encode(keyword, "UTF-8") : "" %>">
                →
            </a>
            <%
                } else {
            %>
            <span class="disabled">→</span>
            <%
                }
            %>
            </div>
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
