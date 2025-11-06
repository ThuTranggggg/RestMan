<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8" />
	<title>RestMan - Chào mừng</title>
	<style>
		/* Layout and page background */
		html, body {
            height: 100%;
            margin: 0;
            padding: 0;
        }
		body {
			font-family: "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
			background: linear-gradient(180deg, #a8e8ec 0%, #d8c6fb 50%, #f3bacf 100%);
			display: flex;
            align-items: center;
            justify-content: center;
            padding: 0;
			-webkit-font-smoothing: antialiased;
            -moz-osx-font-smoothing: grayscale;
		}

		/* Card */
		.wrap {
			width: 100%;
            padding: 36px;
            /*background: rgba(255,255,255,0.86);*/
			/*border-radius: 12px; */
            /*box-shadow: 0 6px 28px rgba(22,40,70,0.12);*/
			text-align: center;
            /*backdrop-filter: blur(6px); */
            /*border: 1px solid rgba(20,30,60,0.04);*/
		}

		h1 {
			margin: 0 0 100px 0;
            font-size: 33px;
            color: #0f3057;
            letter-spacing: -0.2px;
		}
		p.lead { margin: 8px 0 22px 0; color: #3b546a; font-size: 15px; }

		/* Buttons */
		.btn { display: inline-block; padding: 12px 20px; margin: 15px; font-size: 17px; cursor: pointer;
			   border: none; border-radius: 10px; transition: transform 160ms cubic-bezier(.2,.9,.2,1), box-shadow 160ms, opacity 160ms;
			   box-shadow: 0 6px 14px rgba(16,40,80,0.06); color: #fff; text-decoration: none; }

		.btn:focus { outline: 3px solid rgba(25,198,210,0.18); outline-offset: 3px; }
		.btn:active { transform: translateY(1px) scale(0.998); }

		.btn.primary {
			background: linear-gradient(90deg, #296265 0%, #112d59 100%);
			box-shadow: 0 8px 24px rgba(25,118,210,0.12);
		}
		.btn.primary:hover { transform: translateY(-3px); box-shadow: 0 14px 30px rgba(25,118,210,0.14); }

		.btn.secondary {
			background: linear-gradient(90deg, #312978 0%, #4a155a 100%);
			box-shadow: 0 8px 24px rgba(107,91,255,0.10);
		}
		.btn.secondary:hover { transform: translateY(-3px); box-shadow: 0 14px 30px rgba(107,91,255,0.12); }

		/* Responsive tweaks */
		@media (max-width:520px) {
			.wrap { padding: 20px; }
			h1 { font-size: 20px; }
			.btn { width: 100%; max-width: 340px; }
			.btn + .btn { margin-top: 8px; }
		}
	</style>
</head>
<body>
<div class="wrap">
	<h1>Chào mừng đến với nhà hàng số RestMan</h1>

	<!-- Truy cập dưới vai trò Khách hàng: gọi servlet /link (doGet will forward to customer page) -->
	<form action="<%= request.getContextPath() %>/link" method="get" target="_blank" style="display:inline-block;">
		<button type="submit" class="btn primary">Tôi là Khách hàng</button>
	</form>

	<!-- Truy cập dưới vai trò Nhân viên -->
	<form action="<%= request.getContextPath() %>/login" method="get" target="_blank" style="display:inline-block;">
		<input type="hidden" name="role" value="staff" />
		<button type="submit" class="btn secondary">Tôi là Nhân viên</button>
	</form>
</div>
</body>
</html>
