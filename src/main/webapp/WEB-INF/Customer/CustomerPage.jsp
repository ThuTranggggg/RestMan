<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width,initial-scale=1" />
    <title>Trang chủ - RestMan</title>
    <style>
    * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
    }

    /* Simple, widely-available font stack (better Vietnamese support) and soft solid background */
    body{
        font-family: "Segoe UI", Roboto, "Noto Sans", "Helvetica Neue", Arial, sans-serif;
        /* Cross-browser linear gradient */
        background: linear-gradient(180deg, #f4cada 0%, #cef4f6 100%);
        color: #0f172a;
        -webkit-font-smoothing:antialiased; -moz-osx-font-smoothing:grayscale;
        min-height:100vh;
        overflow: hidden;
    }

    /* Container: full viewport to position header and center button */
    .wrap{ 
        height: 100vh;
        display:flex;
        flex-direction: column;
        padding:0;
        position: relative;
        overflow: hidden;
    }

    /* Header styling */
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

    .logout-btn {
        padding: 8px 16px;
        background: rgba(255, 255, 255, 0.95);
        border: 1px solid rgba(16, 24, 40, 0.08);
        border-radius: 8px;
        cursor: pointer;
        font-weight: 600;
        transition: all 200ms ease;
        box-shadow: 0 2px 8px rgba(15, 23, 42, 0.06);
        text-decoration: none;
        color: #0f172a;
    }

    .logout-btn:hover {
        background: #e5e7eb;
        border-color: rgba(16, 24, 40, 0.12);
    }

    .header-right {
        display: flex;
        align-items: center;
        gap: 20px;
        pointer-events: auto;
    }

    /* Card kept transparent so only body background shows */
    .card{ 
        width:100%;
        max-width:980px;
        margin:0 auto;
        background:transparent;
        border-radius:0;
        box-shadow:none;
        padding:0;
        position:relative;
        height: 100vh;
        margin-top: 0;
        display: flex;
        align-items: center;
        justify-content: center;
    }

    /* Main content area */
    .content-section {
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        padding: 20px;
    }

    /* Header (title + lead) placed center with larger typography */
    .page-header{
        text-align:center;
        padding:0 18px;
    }

    h2{ margin:0; font-size:34px; color:#0f172a; font-weight:800; letter-spacing:-0.4px }
    p.lead{ margin:12px auto 0; color:#0f172a; opacity:0.86; font-size:18px; max-width:760px }

    .controls{
        display: flex;
        gap: 12px;
        justify-content: center;
        width: max-content;
        z-index: 10;
        margin-top: 30px;
    }

    /* Button visual */
    .btn{ padding:16px 30px; border-radius:14px; border:0; cursor:pointer; font-weight:800; font-size:17px; color:#fff; font-family: inherit;
        box-shadow: 0 8px 22px rgba(49,50,111,0.12); transition: transform 160ms ease, box-shadow 160ms ease, opacity 140ms; text-decoration: none; display: inline-block; }
    .btn--primary{ display:inline-block; background: #0f172a; }
    /* Provide a subtle alternative hover using a slightly darker overlay */
    .btn--primary:hover{ transform: translateY(-6px); box-shadow: 0 20px 44px rgba(49,50,111,0.18); opacity:0.98 }
    .btn--primary:active{ transform: translateY(-2px) }
    .btn:focus{ outline: 3px solid rgba(99,122,185,0.18); outline-offset:6px }

    /* Mobile tweaks */
    @media (max-width:640px){
        h2{ font-size:24px }
        p.lead{ font-size:16px }
        .controls{ flex-direction: column; gap: 12px }
        .btn{ width:100%; max-width:400px; border-radius:12px; font-size:17px }
    }
    </style>
</head>
<body>
<div class="wrap">
    <div class="header">
        <h1>RestMan</h1>
    </div>

    <div class="card">
        <div class="content-section">
            <div class="page-header">
                <h2>Trang chủ</h2>
                <p class="lead">Hãy tìm kiếm và xem RestMan có gì nhé!</p>
            </div>
            <div class="controls">
                <!-- Open search in same tab -->
                <form action="<%= request.getContextPath() %>/searchDish" method="get" style="margin:0">
                    <button type="submit" class="btn btn--primary">Tìm kiếm</button>
                </form>
            </div>
        </div>
    </div>
</div>
</body>
</html>