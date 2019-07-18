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
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/edit-menu.js" defer></script>
    <title>Edit Menu | <%=shop.name%> | Food Xpress</title>
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
            <button class="btn js-new-item-btn">
                <i class="fas fa-utensils"></i>
                New Food
            </button>
            <button class="btn js-new-category-btn">
                <i class="fas fa-bars"></i>
                New Category
            </button>
            <a class="btn-black" href="view-menu">
                <i class="fas fa-times"></i>
                Discard
            </a>
            <button class="btn-green">
                <i class="fas fa-check"></i>
                Confirm
            </button>
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
                <div class="box-list-title hover-hidden-parent l-stack" id="category-<%=previousCategory%>">
                    <h5><%=previousCategory%></h5>
                    <span class="l-row-group-sm hover-hidden-child edit-menu-category-bar">
                        <i class="fas fa-edit js-category-pop-up-btn" data-category="<%=previousCategory%>"></i>
                        <i class="fas fa-trash-alt"></i>
                    </span>
                </div>
                <%
                    do {
                        Food food = foods.get(i);
                %>
                <div class="card box js-edit-menu-item hover-hidden-parent l-stack">
                    <span class="l-row-group-sm hover-hidden-child edit-menu-food-bar">
                        <i class="fas fa-edit js-food-pop-up-btn" data-food_id="<%=food.id%>" data-category="<%=previousCategory%>"></i>
                        <i class="fas fa-trash-alt"></i>
                    </span>
                    <img src="<%=request.getContextPath()%>/images/burger.jpg" class="box-picture">
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
                        <p class="box-description"><%=food.description%></p>
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
            <div class="fab-icon-holder round-icon-btn l-center">
                <i class="fas fa-plus"></i>
            </div>
            <ul class="fab-options">
                <li>
                    <span class="fab-label">Confirm</span>
                    <div class="fab-icon-holder round-icon-btn l-center btn-green">
                        <i class="fas fa-check"></i>
                    </div>
                </li>
                <li>
                    <span class="fab-label">Discard</span>
                    <a class="fab-icon-holder-black round-icon-btn l-center" href="view-menu">
                        <i class="fas fa-times"></i>
                    </a>
                </li>
                <li>
                    <span class="fab-label">New Category</span>
                    <div class="fab-icon-holder-red round-icon-btn l-center js-new-category-btn">
                        <i class="fas fa-bars"></i>
                    </div>
                </li>
                <li>
                    <span class="fab-label">New Food</span>
                    <div class="fab-icon-holder-red round-icon-btn l-center js-new-item-btn">
                        <i class="fas fa-utensils"></i>
                    </div>
                </li>
            </ul>
        </div>
        <div id="js-category-pop-up" class="pop-up">
            <div class="card box pop-up-card">
                <div class="form-group">
                    <label class="label" for="js-category-name" style="min-width: 100px;">Category:</label>
                    <input class="form-control" type="text" id="js-category-name" placeholder="Enter category name.">
                </div>
                <div class="container-footer-right l-row-group-sm">
                    <button class="round-icon-btn btn-green">
                        <i class="fas fa-check"></i>
                    </button>
                    <button class="round-icon-btn" id="js-category-pop-up-close-btn">
                        <i class="fas fa-times"></i>
                    </button>
                </div>
            </div>
        </div>
        <div id="js-food-pop-up" class="pop-up">
            <div class="card box pop-up-card">
                <div id="js-food-pop-up-close-btn" class="pop-up-close-btn">
                    <i class="fas fa-times"></i>
                </div>
                <form>
                    <div class="pop-up-picture-container">
                        <div class="l-stack pop-up-picture">
                            <img src="<%=request.getContextPath()%>/images/default-food.svg" class="pop-up-picture" id="js-pop-up-picture" alt="food image">
                            <label class="round-icon-btn upload-food-picture-btn l-center" for="js-upload-image">
                                <i class="fas fa-camera"></i>
                            </label>
                        </div>
                    </div>
                    <input type="file" accept="image/*" id="js-upload-image" name="image" hidden>
                    <div class="form-group">
                        <label class="label" for="food-category">Category:</label>
                        <select id="food-category">
                            <%
                                for (String category: categories) {
                            %>
                            <option value="<%=category%>"> <%=category%></option>
                            <%
                                }
                            %>
                        </select>
                    </div>
                    <div class="form-group">
                        <label class="label" for="food-name">Name:</label>
                        <input type="text" class="form-control" id="food-name" placeholder="Enter food name.">
                    </div>
                    <div class="l-flex-wrap">
                        <div class="form-group">
                            <label class="label" for="food-price">Price:</label>
                            <pre>RM </pre>
                            <input type="number" class="form-control" id="food-price" placeholder="0.00">
                        </div>
                        <div class="form-group">
                            <label class="label" for="preparation-time">Time:</label>
                            <input type="number" class="form-control" id="preparation-time" placeholder="0">
                            <pre> minute(s)</pre>
                        </div>
                    </div>

                </form>
                <div class="edit-menu-description">
                    <label class="label">Description:</label>
                    <textarea class="review-text-area" rows="5" placeholder="Write description."></textarea>
                </div>
                <div class="container-footer-right l-row-group-md">
                    <button class="btn" type="button">Confirm</button>
                </div>
            </div>
        </div>
    </main>
    <%@ include file="footer.jsp" %>
</div>
</body>
</html>

