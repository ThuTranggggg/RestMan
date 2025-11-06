<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>

<%-- Nếu chưa có dữ liệu dishes, redirect đến servlet để load sản phẩm mặc định --%>
<%
    List products = (List) request.getAttribute("dishes");
    if (products == null) {
        response.sendRedirect(request.getContextPath() + "/searchDish");
        return;
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

        body{ margin:0; font-family: "Segoe UI", Roboto, "Noto Sans", "Helvetica Neue", Arial, sans-serif;
               /* gradient requested */
               background: linear-gradient(180deg, #f4cada 0%, #cef4f6 100%);
               color:#0f172a; -webkit-font-smoothing:antialiased; -moz-osx-font-smoothing:grayscale; min-height:100vh }

    /* wrap/card act as layout shells; remove card visual so body background is sole background */
    .wrap{ min-height:100vh; display:block; padding:0 }
    /* add top padding so content flows below the header */
    .card{ width:100%; max-width:980px; margin:0 auto; background:transparent; border-radius:0; padding:0 18px; box-shadow:none; position:relative; min-height:100vh; padding-top:120px }

    /* Header at top center (keep visible at top) */
    .card > h2, .card > p { text-align:center; margin:0 }
    h2{ position:absolute; top:6vh; left:50%; transform:translateX(-50%); font-size:30px; color:#0f172a; font-weight:800 }
    p{ margin-top:6px; color:rgba(15,23,42,0.9); font-size:16px; position:absolute; top:calc(6vh + 50px); left:50%; transform:translateX(-50%); z-index:10; width:100%; max-width:300px; white-space:normal; line-height:1.3 }
    
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
    .dishes-grid{ display:grid; grid-template-columns: repeat(auto-fill, minmax(220px, 1fr)); gap:18px; margin:18px auto 60px; max-width:980px }
    .dish-tile{ background: rgba(255,255,255,0.9); border-radius:12px; padding:10px; box-shadow: 0 2px 6px rgba(15,23,42,0.06); display:flex; flex-direction:column; align-items:center; text-align:center }
    .dish-tile img{ width:100%; height:140px; object-fit:cover; border-radius:8px; margin-bottom:10px; display:block }
    .dish-name{ font-weight:700; color:#0f172a; margin-bottom:6px }
    .dish-price{ color:#0b8457; font-weight:700 }
    .product-type{ font-size:12px; color:#666; margin-bottom:4px; text-transform:uppercase; letter-spacing:0.5px }
    
    .product-type.drink { color: #0284c7; font-weight: 700 }
    .product-type.dish { color: #2e6a6c; font-weight: 700 }
    .product-type.combo { color: #2d2380; font-weight: 700 }
    
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
            .dish-tile img{ height:120px }
            .category-header { margin: 20px auto 12px }
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
    <div class="card">
        <h2>Thực đơn</h2>
        <p>Tìm sản phẩm yêu thích của bạn!</p>

        <form action="<%= request.getContextPath() %>/searchDish" method="get">
            <div class="form-row">
                <input type="text" name="keyword" placeholder="Nhập từ khóa..." value="<%= esc((String)request.getAttribute("keyword")) %>" />
                <button type="submit" class="btn btn--primary">Tìm kiếm</button>
            </div>
            <a href="<%= request.getContextPath() %>/link" class="btn btn--ghost" style="text-decoration:none;display:inline-flex;align-items:center;padding:10px 12px;border-radius:8px">Trở về</a>
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
