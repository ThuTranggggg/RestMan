<%@ page contentType="text/html;charset=UTF-8" language="java" import="java.util.List, model.Product" %>
<%!
    public static String esc(String s) {
        if (s == null) return "";
        return s.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;");
    }
%>
<%
    // Tạo URL quay lại thông minh
    String backUrl = request.getContextPath() + "/searchDish";
    String searchKeyword = (String) session.getAttribute("searchDishKeyword");
    
    if (searchKeyword != null && !searchKeyword.isEmpty()) {
        backUrl += "?keyword=" + java.net.URLEncoder.encode(searchKeyword, "UTF-8");
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width,initial-scale=1" />
    <title>Chi tiết sản phẩm - RestMan</title>
    <style>
     * {
         margin: 0;
         padding: 0;
         box-sizing: border-box;
     }

     /* Page background only (gradient) */
     html, body { height: 100%; }
     body{ 
         font-family: "Segoe UI", Roboto, "Noto Sans", "Helvetica Neue", Arial, sans-serif;
         background: linear-gradient(180deg, #f4cada 0%, #cef4f6 100%);
         color:#0f172a; 
         -webkit-font-smoothing:antialiased; 
         -moz-osx-font-smoothing:grayscale;
         /* prevent page from scrolling; content will scroll inside the card */
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
         color: #0f172a;
     }

     .back-btn:hover {
         background: #e5e7eb;
     }

     .header-right {
         display: flex;
         align-items: center;
         gap: 20px;
         pointer-events: auto;
     }

    /* Container spacing — card is visual removed (transparent) but used for layout */
    .container{ max-width:900px; margin:0 auto; padding:20px; height:100%; box-sizing:border-box; margin-top: 60px; }
    /* Make the card area scroll internally instead of letting the whole page scroll */
    .card{ background:transparent; border-radius:0; padding:0; box-shadow:none; position:relative; min-height:0; padding-top:20px; overflow:auto; max-height: calc(100vh - 140px); }

        /* Page title */
        .title{ margin:0 0 20px 0; font-size:30px; font-weight:800; color:#0f172a; text-align: center; }

    /* Detail rows layout: two-column with media on the right */
    .details{ width:100%; max-width:980px; margin:0 auto; padding:18px 20px; box-sizing:border-box; display:flex; gap:24px; align-items:flex-start }
    .content{ flex:1; }
    .media{ width:360px; flex:0 0 360px }
    .row{ display:flex; gap:20px; align-items:flex-start; padding:12px 0; border-bottom:1px solid rgba(16,24,40,0.04) }
    /* Let the label size to content but keep a reasonable min/max; value column grows */
    .label{ color:rgba(15,23,42,0.7); flex:0 0 180px; font-weight:700; white-space:nowrap }
    .value{ font-size:18px; color:#10203a; flex:1 1 auto; min-width:120px }

        /* Price styling */
        .price { font-size:20px; font-weight:800; color:#0f172a; background: rgba(255,255,255,0.12); padding:8px 12px; border-radius:8px; display:inline-block }

        /* Type badge */
        .product-type { display:inline-block; padding:4px 12px; border-radius:6px; font-size:12px; font-weight:700; text-transform:uppercase; letter-spacing:0.5px; margin-bottom:12px }
        .product-type.drink { background:#e0f2fe; color:#0284c7 }
        .product-type.dish { background: rgba(189, 255, 249, 0.78); color: #296265
        }
        .product-type.combo { background: #e8b5f8; color: #4a155a
        }

        /* Media sizing - smaller for drinks */
        .media { width: 360px; flex: 0 0 360px; }
        .media.drink-media { width: 240px; flex: 0 0 240px; }
        .media img { width: 100%; border-radius: 8px; object-fit: cover; display: block; }

            .btn--ghost{
                background: rgba(243, 244, 246, 0.46);
                color:#374151;
                border:1px solid rgba(16,24,40,0.04);
                text-decoration:none;
            }

         .back{
             position:fixed;
             top:12px;
             left:12px;
             display:inline-flex;
             align-items:center;
             padding:8px 10px;
             border-radius:8px;
             z-index:1200;
         }

        @media (max-width:720px){
            .row{ flex-direction:column; align-items:flex-start }
            .label{ width:100%; margin-bottom:6px; white-space:normal }
            .details{
                padding:12px;
                flex-direction:column;
                align-items: center;
                text-align: center;
            }
            .media{ width:100%; flex:0 0 auto; margin-top:12px }
            .title{ font-size:22px; top:18px }
            .card{ padding-top:100px }
        }
    </style>
    <script>
        function goBack(){ history.back(); }
    </script>
</head>
<body>
<div class="header">
    <h1>RestMan</h1>
    <a href="<%= backUrl %>" class="back-btn">Trở về</a>
</div>

<div class="container">
    <div class="card">
        <h1 class="title">Chi tiết sản phẩm</h1>
        
        <%
            model.Product dish = (model.Product) request.getAttribute("dish");
            String dishImageUrl = (String) request.getAttribute("dishImageUrl");
            String formattedPrice = (String) request.getAttribute("formattedPrice");
            String detailError = (String) request.getAttribute("detailError");
        %>

        <% if (dish == null) { %>
            <div style="color:darkred;padding:12px">
                <% if (detailError != null && !detailError.isEmpty()) { %>
                    <%= esc(detailError) %>
                <% } else { %>
                    Không tìm thấy thông tin sản phẩm.
                <% } %>
            </div>
            <div style="padding:12px"><a href="javascript:history.back();">Quay lại</a></div>
        <% } else { %>
            <div class="details">
                <div class="content">
                    <%
                        String type = dish.getType();
                        String typeClass = "dish";
                        String typeLabel = "Món lẻ";
                        if ("DRINK".equals(type)) {
                            typeClass = "drink";
                            typeLabel = "Nước";
                        } else if ("COMBO".equals(type)) {
                            typeClass = "combo";
                            typeLabel = "Combo";
                        }
                    %>
                    <span class="product-type <%= typeClass %>"><%= typeLabel %></span>
                    <div class="row"><div class="label">Tên sản phẩm</div><div class="value"><%= esc(dish.getName()) %></div></div>
                    <div class="row"><div class="label">Mô tả</div><div class="value"><%= esc(dish.getDescription()) %></div></div>
                    <div class="row"><div class="label">Giá</div><div class="value"><span class="price"><%= esc(formattedPrice) %> VNĐ</span></div></div>
                </div>
                <% if (dishImageUrl != null && !dishImageUrl.isEmpty()) { %>
                    <div class="media <%= "DRINK".equals(type) ? "drink-media" : "" %>">
                        <img src="<%= esc(dishImageUrl) %>" alt="<%= esc(dish.getName()) %>" style="max-height:420px;" 
                             onerror="this.src='<%= request.getContextPath() %>/img/defaultImage.png'; this.style.border='2px solid #ccc';" />
                    </div>
                <% } %>
            </div>
        <% } %>
    </div>
</div>
</body>
</html>
