<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>

<%-- Lấy dữ liệu dishes từ request --%>
<%
    List products = (List) request.getAttribute("dishes");
    if (products == null) {
        products = new java.util.ArrayList();
    }
    
    // Lưu từ khóa tìm kiếm vào session
    String keyword = (String) request.getAttribute("keyword");
    if (keyword != null && !keyword.isEmpty()) {
        session.setAttribute("searchDishKeyword", keyword);
    }
%>

<%-- Small HTML-escape helper to avoid external dependencies --%>
<%!
    public static String esc(String s) {
        if (s == null) return "";
        return s.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;");
    }
    
    public static String getTypeLabel(String type) {
        if ("DRINK".equals(type)) return "Nước";
        if ("DISH".equals(type)) return "Món lẻ";
        if ("COMBO".equals(type)) return "Combo";
        return type;
    }
    
    public static String getTypeClass(String type) {
        if ("DRINK".equals(type)) return "drink";
        if ("DISH".equals(type)) return "dish";
        if ("COMBO".equals(type)) return "combo";
        return "other";
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width,initial-scale=1" />
    <title>Thực đơn - RestMan</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body{ 
            font-family: "Segoe UI", Roboto, "Noto Sans", "Helvetica Neue", Arial, sans-serif;
            background: linear-gradient(180deg, #f4cada 0%, #cef4f6 100%);
            color:#0f172a; 
            -webkit-font-smoothing:antialiased; 
            -moz-osx-font-smoothing:grayscale; 
            min-height:100vh;
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

    /* wrap/card act as layout shells; remove card visual so body background is sole background */
    .wrap{ 
        min-height:100vh; 
        display:flex;
        flex-direction: column;
        padding:0;
    }
    /* add top padding so content flows below the header */
    .card{ 
        width:100%; 
        max-width:980px; 
        margin:0 auto; 
        background:transparent; 
        border-radius:0; 
        padding:0 18px; 
        box-shadow:none; 
        position:relative; 
        min-height:100vh; 
        padding-top:80px;
        flex: 1;
    }

    /* Header at top center (keep visible at top) */
    .card > h2, .card > p { text-align:center; margin:0 }
    h2{ font-size:30px; color:#0f172a; font-weight:800 }
    p.subtitle { 
        margin-top:6px; 
        color:rgba(15,23,42,0.9); 
        font-size:16px;
        line-height:1.3;
    }
    
    /* Sửa cho thẻ p bên trong div message */
    .message p { position:static; transform:none; margin:0; color:#666; font-size:16px }

    /* Form controls positioned near top, below title */
    .form-row{ display:flex; gap:12px; align-items:center; justify-content:center; margin:12px auto 18px; max-width:920px }
        input[type="text"]{
            /* increase base width so the input is longer on wider screens */
            flex:0 1 560px;
            min-width:300px;
            padding:12px 14px;
            border-radius:12px;
            border:1px solid rgba(16,24,40,0.08);
            font-size:16px
        }
        .btn{ padding:12px 18px;
            border-radius:12px;
            border:0;
            cursor:pointer;
            font-weight:700
        }
        /* Make search button wider to fit longer labels */
        .btn--primary{
            background:#0f172a;
            color:#fff;
            padding:12px 28px;
            min-width:150px;
        }

    .btn--ghost{
        background: rgba(243, 244, 246, 0.46);
        color:#374151;
        border:1px solid rgba(16,24,40,0.04);
    }

    .card a.btn--ghost{
        position:fixed;
        top:12px;
        left:12px;
        display:inline-flex;
        align-items:center;
        padding:8px 10px;
        border-radius:8px;
        text-decoration:none;
        z-index:1200
    }

    /* Section header for product categories */
    .category-header {
        margin: 30px auto 18px;
        max-width: 980px;
        padding: 0 10px;
        font-size: 20px;
        font-weight: 700;
        color: #0f172a;
        border-left: 4px solid #0f172a;
        padding-left: 12px;
    }

    /* Grid for product tiles shown in remaining page area */
    .dishes-grid{ 
        display: grid; 
        grid-template-columns: repeat(auto-fill, minmax(180px, 1fr)); 
        gap: 16px; 
        margin: 18px auto 60px; 
        max-width: 980px;
        padding: 0 10px;
    }
    
    .dish-tile{ 
        background: rgba(255,255,255,0.92); 
        border-radius: 10px; 
        padding: 12px; 
        box-shadow: 0 2px 8px rgba(15,23,42,0.08); 
        display: flex; 
        flex-direction: column; 
        align-items: center; 
        text-align: center;
        transition: all 200ms ease;
        cursor: pointer;
    }
    
    .dish-tile:hover {
        box-shadow: 0 4px 12px rgba(15,23,42,0.12);
        transform: translateY(-2px);
    }
    
    .dish-tile img{ 
        width: 100%; 
        height: 110px; 
        object-fit: contain;
        object-position: center;
        border-radius: 6px; 
        margin-bottom: 10px; 
        display: block;
        background: rgba(240, 240, 240, 0.5);
        padding: 4px;
    }
    
    .dish-name{ 
        font-weight: 700; 
        color: #0f172a; 
        margin-bottom: 4px;
        font-size: 13px;
        line-height: 1.2;
        min-height: 26px;
        display: -webkit-box;
        -webkit-line-clamp: 2;
        line-clamp: 2;
        -webkit-box-orient: vertical;
        overflow: hidden;
    }
    
    .dish-price{ 
        color: #0b8457; 
        font-weight: 700;
        font-size: 14px;
    }
    
    .product-type{ 
        font-size: 11px; 
        color: #fff;
        margin-bottom: 6px; 
        text-transform: uppercase; 
        letter-spacing: 0.5px;
        padding: 3px 8px;
        border-radius: 4px;
        font-weight: 600;
    }
    
    .product-type.drink { 
        background: #0284c7;
        color: #fff;
        font-weight: 700 
    }
    .product-type.dish { 
        background: #2e6a6c;
        color: #fff;
        font-weight: 700 
    }
    .product-type.combo { 
        background: #2d2380;
        color: #fff;
        font-weight: 700 
    }
    
    .dish-link{ text-decoration:none; color:inherit; display:block }
    .dish-link:focus, .dish-link:hover .dish-tile{
        box-shadow: 0 6px 18px rgba(15,23,42,0.12);
        transform: translateY(-2px);
        transition: all 180ms ease;
        background: rgb(244, 202, 218);
    }

        @media (max-width:640px){
            .form-row{ flex-direction:column; align-items:stretch }
            input[type="text"]{ width:100%; flex:1 }
            .card a.btn--ghost{ top:10px; left:10px }
            .dish-tile img{ height:90px; }
            .category-header { margin: 20px auto 12px }
            .dishes-grid { grid-template-columns: repeat(auto-fill, minmax(150px, 1fr)); gap: 12px; }
        }

        /* Nút scroll to top */
        #scrollToTopBtn {
            display: none;
            position: fixed;
            bottom: 30px;
            right: 30px;
            z-index: 99;
            border: none;
            outline: none;
            background: rgba(224, 242, 254, 0.58);
            color: #090923;
            cursor: pointer;
            padding: 15px 20px;
            border-radius: 60px;
            font-size: 18px;
            font-weight: 700;
            box-shadow: 0 4px 15px rgba(102, 51, 153, 0.4);
            transition: all 0.3s ease;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        #scrollToTopBtn:hover {
            background: #10203a;
            color: #fce7f3;
            box-shadow: 0 6px 20px rgba(102, 51, 153, 0.6);
            transform: translateY(-3px);
        }

        #scrollToTopBtn:active {
            transform: translateY(-1px);
        }

        @media (max-width:640px) {
            #scrollToTopBtn {
                bottom: 20px;
                right: 20px;
                padding: 12px 16px;
                font-size: 16px;
            }
        }
    </style>
    <script>
        // Hiển thị/ẩn nút scroll to top khi load trang
        document.addEventListener('DOMContentLoaded', function() {
            window.addEventListener('scroll', function() {
                const btn = document.getElementById('scrollToTopBtn');
                if (btn) {
                    if (window.pageYOffset > 300) {
                        btn.style.display = 'block';
                    } else {
                        btn.style.display = 'none';
                    }
                }
            });

            // Gán click listener cho nút
            const scrollBtn = document.getElementById('scrollToTopBtn');
            if (scrollBtn) {
                scrollBtn.addEventListener('click', function(e) {
                    e.preventDefault();
                    // Scroll to top
                    window.scrollTo({
                        top: 0,
                        behavior: 'smooth'
                    });
                });
            }
        });
    </script>
</head>
<body>
<div class="wrap">
    <div class="header">
        <h1>RestMan</h1>
        <a href="<%= request.getContextPath() %>/link" class="back-btn">Trở về</a>
    </div>

    <div class="card">
        <h2>Tìm kiếm món ăn</h2>
        <p class="subtitle">Cùng khám phá thực đơn hôm nay của RestMan nhé!</p>

        <%-- Hiển thị error message nếu có --%>
        <% 
            String error = (String) request.getAttribute("error");
            if (error != null && !error.isEmpty()) {
        %>
            <div class="message" style="text-align:center; margin:20px auto; color:#d32f2f; font-size:16px; background:#ffebee; padding:15px; border-radius:8px; border-left:4px solid #d32f2f;">
                <p><%= esc(error) %></p>
            </div>
        <% } %>

        <form action="<%= request.getContextPath() %>/searchDish" method="get">
            <div class="form-row">
                <input type="text" name="keyword" placeholder="Nhập từ khóa..." value="<%= esc((String)request.getAttribute("keyword")) %>" />
                <button type="submit" class="btn btn--primary">Tìm kiếm</button>
            </div>
        </form>

        <%-- Presentation: products list (Drink, Dish and Combo) is provided by servlets --%>
        <% if (products != null && !products.isEmpty()) { 
            String currentType = "";
            int productCount = 0;
        %>
            <% for (Object _o : products) {
                   model.Product p = (model.Product) _o;
                   String productType = p.getType();
                   
                   // Hiển thị category header nếu loại sản phẩm thay đổi
                   if (!productType.equals(currentType)) {
                       currentType = productType;
                       if (productCount > 0) {
        %>
            </div>
        <%     
                       }
        %>
            <div class="category-header"><%= getTypeLabel(productType) %></div>
            <div class="dishes-grid">
        <% 
                   }
                   productCount++;
        %>
                    <a class="dish-link" href="<%= request.getContextPath() %>/viewDish?id=<%= p.getId() %>">
                        <div class="dish-tile" role="button">
                            <img src="<%= esc(p.getImageUrl()) %>" alt="<%= esc(p.getName()) %>" onerror="this.style.display='none'" />
                            <div class="product-type <%= getTypeClass(productType) %>"><%= getTypeLabel(productType) %></div>
                            <div class="dish-name"><%= esc(p.getName()) %></div>
                            <div class="dish-price"><%= String.format("%,.0f", p.getPrice()) %> đ</div>
                        </div>
                    </a>
            <% } %>
            </div>
        <% } else { %>
            <div class="message" style="text-align:center; margin:30px auto 40px; color:#666; font-size:16px;">
                <p><%= request.getAttribute("keyword") != null && !((String)request.getAttribute("keyword")).isEmpty() ? "Không tìm thấy sản phẩm nào." : "Hãy tìm kiếm sản phẩm!" %></p>
            </div>
        <% } %>
    </div>
</div>

<!-- Nút scroll to top -->
<button id="scrollToTopBtn" title="Cuộn lên đầu trang">⬆</button>

</body>
</html>
