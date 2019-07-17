<%@ page import="foodxpress.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    SQLProvider provider = new SQLProvider();
    Repository repository = new Repository(provider);

    Vendor vendor = (Vendor) session.getAttribute("vendor");
    int shopId = vendor.shop_id;
    Shop shop = repository.getShopInfo(shopId);
    ArrayList<String> categories = repository.getAllCategoriesInShop(shopId);
    ArrayList<Food> foods = repository.getAllFoodsInShop(shopId);
%>
<!DOCTYPE html>
<html lang="en" dir="ltr">
<head>
    <%@ include file="meta.jsp" %>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/test.css" type="text/css">
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/master.js" defer></script>
    <title>Menu | <%=shop.name%> | Food Xpress</title>
</head>
<body>
<div class="wrapper">
    <jsp:include page="vendor-header.jsp"/>
    <main class="main">
        <aside class="sidebar" id="js-home-sidebar">
            <button type="button" class="sidebar-btn square-icon-btn">
                <i class="fas fa-bars"></i>
            </button>
            <span class="sidebar-header">
            CATEGORY
          </span>
            <ul class="sidebar-content">
                <%
                    for (String category : categories) {
                %>
                <li><a href="#category-<%=category%>"><%=category%></a></li>
                <%
                    }
                %>
            </ul>
        </aside>
        <aside class="edit-menu-action-bar l-col-group-md" id="js-edit-menu-aside">
            <a class="btn" href="edit-menu">
                <i class="fas fa-edit"></i>
                Edit Menu
            </a>
        </aside>
        <main class="rest-box menu-box box-main">
            <div class="box-main-title">
                <%=shop.name%>
            </div>
            <%
                String previousCategory;
                int j = 0;
                for (int i = 0; i < foods.size(); i++) {
                    previousCategory = foods.get(i).category;
            %>
            <div class="box-list">
                <div class="box-list-title" id="category-<%=previousCategory%>">
                    <h5><%=previousCategory%></h5>
                </div>
                <%
                    do {
                        Food food = foods.get(i);
                %>
                <div class="card box">
                    <div class="box-picture">
                        <img src="<%=request.getContextPath()%>/images/burger.jpg" class="box-picture">
                    </div>
                    <div class="box-content">
                        <div class="box-detail">
                            <div class="box-title"><%=food.name%></div>
                            <div>
                                <span class="box-info">RM <%=Utils.toTwoDecimalPlaces(food.price)%></span>
                                <span class="box-info">
                     <i class="fas fa-hourglass-half"></i>
                     <%=Utils.printHourMinute(food.prepare_time)%>
                   </span>
                                <span class="box-info">
                     <span class="rating-star">
                             <%
                                 double rating = Double.parseDouble(Utils.toOneDecimalPlaces(food.rating));
                                 int fullStar = (int) rating;
                                 boolean halfStarExist = (rating - fullStar) > 0;
                                 int emptyStar = 5 - fullStar;
                                 if (halfStarExist)
                                     emptyStar--;
                                 for (int k = 0; k < fullStar; k++) {
                             %>
                             <i class="fas fa-star"></i>
                             <%
                                 }
                                 if (halfStarExist) {
                             %>
                             <i class="fas fa-star-half-alt"></i>
                             <%
                                 }
                                 for (int k = 0; k < emptyStar; k++) {
                             %>
                             <i class="far fa-star"></i>
                             <%
                                 }
                             %>
<%--                       <i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star-half-alt"></i><i class="far fa-star"></i>--%>
                     </span>
                     <%=Utils.toOneDecimalPlaces(food.rating)%>
                   </span>
                            </div>
                        </div>
                        <div class="box-description">
                            <%=food.description%>
                        </div>
                    </div>
                </div>
                <%
                        i++;
                    } while (i < foods.size() && foods.get(i).category.equals(previousCategory));
                    if (i < foods.size() && !foods.get(i).category.equals(previousCategory)) {
                        i--;
                        j++;
                    }
                %>
            </div>
            <%
                }
            %>
        </main>
        <div class="fab-container">
            <a class="fab-icon-holder round-icon-btn l-center" href="edit-menu">
                <i class="fas fa-edit"></i>
            </a>
        </div>
    </main>
    <%@ include file="footer.jsp" %>
</div>
</body>
</html>

