<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width,initial-scale=1" />
    <title>Đăng nhập - Nhân viên - RestMan</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
            background: linear-gradient(180deg, #a8e8ec 0%, #d8c6fb 50%, #f3bacf 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            -webkit-font-smoothing: antialiased;
            -moz-osx-font-smoothing: grayscale;
        }

        .login-container {
            width: 100%;
            max-width: 400px;
            padding: 40px;
            background: rgba(255, 255, 255, 0.95);
            border-radius: 12px;
            box-shadow: 0 10px 40px rgba(22, 40, 70, 0.12);
            backdrop-filter: blur(10px);
        }

        .login-container h1 {
            text-align: center;
            font-size: 28px;
            color: #0f172a;
            margin-bottom: 30px;
            font-weight: 800;
        }

        .form-group {
            margin-bottom: 20px;
        }

        label {
            display: block;
            margin-bottom: 8px;
            color: #1f2937;
            font-weight: 600;
            font-size: 14px;
        }

        input[type="text"],
        input[type="password"] {
            width: 100%;
            padding: 12px 14px;
            border: 1px solid rgba(16, 24, 40, 0.08);
            border-radius: 8px;
            font-size: 15px;
            transition: border-color 200ms ease;
        }

        input[type="text"]:focus,
        input[type="password"]:focus {
            outline: none;
            border-color: #0f172a;
            box-shadow: 0 0 0 3px rgba(15, 23, 42, 0.1);
        }

        .form-actions {
            margin-top: 30px;
        }

        .btn {
            width: 100%;
            padding: 12px 16px;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 700;
            cursor: pointer;
            transition: all 200ms ease;
        }

        .btn-primary {
            background: linear-gradient(90deg, #296265 0%, #112d59 100%);
            color: white;
            box-shadow: 0 4px 12px rgba(25, 118, 210, 0.15);
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(25, 118, 210, 0.25);
        }

        .btn-primary:active {
            transform: translateY(0);
        }

        .back-link {
            text-align: center;
            margin-top: 20px;
        }

        .back-link a {
            color: #0f172a;
            text-decoration: none;
            font-size: 14px;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            transition: color 200ms ease;
        }

        .back-link a:hover {
            color: #4b5563;
        }

        .error-message {
            background-color: #fee;
            border: 1px solid #fcc;
            color: #c33;
            padding: 12px 14px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-size: 14px;
        }

        .info-message {
            background-color: #efe;
            border: 1px solid #cfc;
            color: #3c3;
            padding: 12px 14px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-size: 14px;
        }

        @media (max-width: 480px) {
            .login-container {
                padding: 24px;
            }

            .login-container h1 {
                font-size: 24px;
            }
        }
    </style>
</head>
<body>
<div class="login-container">
    <h1>Đăng nhập Nhân viên</h1>

    <%
        String error = request.getParameter("error");
        if (error != null) {
            if ("invalid".equals(error)) {
    %>
    <div class="error-message">
        Tên đăng nhập hoặc mật khẩu không chính xác!
    </div>
    <%
            } else if ("empty".equals(error)) {
    %>
    <div class="error-message">
        Vui lòng nhập đầy đủ tên đăng nhập và mật khẩu!
    </div>
    <%
            } else if ("db".equals(error)) {
    %>
    <div class="error-message">
        Lỗi cơ sở dữ liệu. Vui lòng thử lại sau!
    </div>
    <%
            }
        }
    %>

    <form action="<%= request.getContextPath() %>/login" method="post">
        <input type="hidden" name="role" value="staff" />

        <div class="form-group">
            <label for="username">Tên đăng nhập</label>
            <input type="text" id="username" name="username" placeholder="Nhập tên đăng nhập..." required />
        </div>

        <div class="form-group">
            <label for="password">Mật khẩu</label>
            <input type="password" id="password" name="password" placeholder="Nhập mật khẩu..." required />
        </div>

        <div class="form-actions">
            <button type="submit" class="btn btn-primary">Đăng nhập</button>
        </div>
    </form>
</div>
</body>
</html>
