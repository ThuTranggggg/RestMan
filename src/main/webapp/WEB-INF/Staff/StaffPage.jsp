<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Staff" %>
<%
    Staff staff = (Staff) session.getAttribute("staff");
    if (staff == null) {
        response.sendRedirect(request.getContextPath() + "/");
        return;
    }
    
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width,initial-scale=1" />
    <title>Trang chủ Nhân viên - RestMan</title>
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
        }

        .header h1 {
            font-size: 28px;
            font-weight: 800;
            color: #0f172a;
            pointer-events: auto;
        }

        .user-info {
            display: flex;
            align-items: center;
            gap: 20px;
            pointer-events: auto;
        }

        .user-name {
            font-size: 14px;
            color: #666;
            text-align: right;
        }

        .user-name strong {
            display: block;
            color: #0f172a;
            font-weight: 700;
        }

        .logout-btn {
            padding: 8px 16px;
            background: rgba(255, 255, 255, 0.95);
            border: 1px solid rgba(16, 24, 40, 0.08);
            border-radius: 8px;
            cursor: pointer;
            font-weight: 600;
            transition: all 200ms ease;
            box-shadow: 0 2px 8px rgba(15, 23, 42, 0.06);
        }

        .logout-btn:hover {
            background: #e5e7eb;
            border-color: rgba(16, 24, 40, 0.12);
        }

        .content {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 60px 40px;
            min-height: 100vh;
        }

        .staff-menu {
            text-align: center;
        }

        .staff-menu h2 {
            font-size: 32px;
            margin-bottom: 12px;
            color: #0f172a;
        }

        .staff-menu p {
            font-size: 16px;
            color: #666;
            margin-bottom: 40px;
        }

        .menu-buttons {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
            gap: 20px;
            max-width: 250px;
            margin: 0 auto;
        }

        .menu-btn {
            padding: 14px 12px;
            background: rgba(255, 255, 255, 0.9);
            border: 2px solid rgba(15, 23, 42, 0.1);
            border-radius: 12px;
            cursor: pointer;
            text-decoration: none;
            font-size: 16px;
            font-weight: 700;
            color: #0f172a;
            transition: all 200ms ease;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 12px;
        }

        .menu-btn:hover {
            background: #0f172a;
            color: white;
            transform: translateY(-4px);
            box-shadow: 0 8px 24px rgba(15, 23, 42, 0.15);
        }

        .menu-btn:active {
            transform: translateY(-2px);
        }

        .menu-btn.primary {
            background: linear-gradient(90deg, #296265 0%, #112d59 100%);
            color: white;
            border-color: transparent;
        }

        .menu-btn.primary:hover {
            background: linear-gradient(90deg, #1f4a4d 0%, #0a1e44 100%);
        }

        .error-message {
            background-color: #fee;
            border: 1px solid #fcc;
            color: #c33;
            padding: 14px;
            border-radius: 8px;
            margin-bottom: 20px;
            text-align: center;
            font-weight: 500;
        }

        .error-message::before {
            content: "⚠️ ";
            margin-right: 8px;
        }

        @media (max-width: 640px) {

            .user-info {
                width: 100%;
                justify-content: space-between;
            }

            .content {
                padding: 40px 20px;
            }

            .menu-buttons {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
<div class="wrap">
    <div class="header">
        <h1>RestMan</h1>
        <div class="user-info">
            <div class="user-name">
                <strong><%= staff.getFullName() %></strong>
                <span><%= staff.getPosition() %></span>
            </div>
            <form action="<%= request.getContextPath() %>/staffPage" method="post" style="margin: 0;">
                <input type="hidden" name="action" value="logout" />
                <button type="submit" class="logout-btn">Đăng xuất</button>
            </form>
        </div>
    </div>

    <div class="content">
        <div class="staff-menu">
            <h2>Trang chủ nhân viên</h2>
            <p>Hãy thanh toán hóa đơn cho khách ở đây nhé!</p>

            <%
                if (error != null) {
            %>
            <div class="error-message">
                <%= error %>
            </div>
            <%
                }
            %>

            <div class="menu-buttons">
                <a href="<%= request.getContextPath() %>/searchTable" class="menu-btn primary">
                    Thanh toán
                </a>
            </div>
        </div>
    </div>
</div>
</body>
</html>
