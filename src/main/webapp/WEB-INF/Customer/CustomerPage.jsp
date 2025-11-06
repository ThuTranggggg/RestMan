<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width,initial-scale=1" />
    <title>Trang chủ - RestMan</title>
    <style>

    /* Simple, widely-available font stack (better Vietnamese support) and soft solid background */
    body{
        margin:0; font-family: "Segoe UI", Roboto, "Noto Sans", "Helvetica Neue", Arial, sans-serif;
        /* Cross-browser linear gradient */
        background: linear-gradient(180deg, #f4cada 0%, #cef4f6 100%);
        color: #0f172a;
        -webkit-font-smoothing:antialiased; -moz-osx-font-smoothing:grayscale;
        min-height:100vh;
    }

    /* Container: full viewport to position header and center button */
    .wrap{ min-height:100vh; display:block; padding:0; }

    /* Card kept transparent so only body background shows */
    .card{ width:100%;
        max-width:980px;
        margin:0 auto;
        background:transparent;
        border-radius:0;
        box-shadow:none;
        padding:0;
        position:relative;
        min-height:100vh }

    /* Header (title + lead) placed near top center with larger typography */
    .header{
        position:absolute;
        top:13vh;
        left:0;
        right:0;
        width:100%;
        max-width:820px;
        margin:0 auto;
        text-align:center;
        padding:0 18px;
    }

    h1{ margin:0; font-size:34px; color:#0f172a; font-weight:800; letter-spacing:-0.4px }
    p.lead{ margin:12px auto 0; color:#0f172a; opacity:0.86; font-size:18px; max-width:760px }

    .controls{
        position: fixed;         /* bám theo viewport */
        left: 50%;
        top: 50%;
        transform: translate(-50%, -50%);
        display: flex;
        gap: 12px;
        justify-content: center;
        width: max-content;
        z-index: 10;
    }

    /* Button visual: make the ghost button visible and styled as primary (do not change HTML) */
    .btn{ padding:16px 30px; border-radius:14px; border:0; cursor:pointer; font-weight:800; font-size:17px; color:#fff; font-family: inherit;
        box-shadow: 0 8px 22px rgba(49,50,111,0.12); transition: transform 160ms ease, box-shadow 160ms ease, opacity 140ms }
    .btn--ghost{ display:inline-block; background: #0f172a; }
    /* Provide a subtle alternative hover using a slightly darker overlay */
    .btn--ghost:hover{ transform: translateY(-6px); box-shadow: 0 20px 44px rgba(49,50,111,0.18); opacity:0.98 }
    .btn--ghost:active{ transform: translateY(-2px) }
    .btn:focus{ outline: 3px solid rgba(99,122,185,0.18); outline-offset:6px }

    /* Mobile tweaks */
    @media (max-width:640px){
        h1{ font-size:24px }
        p.lead{ font-size:16px }
        .header{ top:5vh }
        .controls{ top:58% }
        .btn{ width:88%; max-width:400px; border-radius:12px; font-size:17px }
    }
    </style>
</head>
<body>
<div class="wrap">
    <div class="card">
    <div class="header">
            <div>
                <h1>Trang chủ</h1>
                <p class="lead">Hãy tìm kiếm và xem RestMan có gì nhé!</p>
            </div>
            <div class="controls">
                <!-- Open search in same tab (this page is typically opened from index in a new tab) -->
                <form action="<%= request.getContextPath() %>/link" method="get" style="margin:0">
                    <input type="hidden" name="page" value="searchdish" />
                    <button type="submit" class="btn btn--ghost">Tìm kiếm</button>
                </form>

            </div>

    </div>
    </div>
</div>
</body>
</html>