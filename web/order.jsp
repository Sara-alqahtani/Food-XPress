<%@ page import="foodxpress.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    User user = (User) session.getAttribute("user");

    SQLProvider provider = new SQLProvider();
    Repository repository = new Repository(provider);

    int shopId;
    try {
        shopId = Integer.parseInt(request.getParameter("shop_id"));
    } catch (NumberFormatException e) {
        e.printStackTrace();
        response.sendRedirect("home");
        return;
    }
    Shop shop = repository.getShopInfo(shopId);
    ArrayList<String> categories = repository.getCategoriesWithFoodsInShop(shopId);
    ArrayList<Food> foods = repository.getAllFoodsInShop(shopId);
%>
<!DOCTYPE html>
<html lang="en" dir="ltr">
<head>
    <%@ include file="meta.jsp" %>
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/master.js" defer></script>
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/cart.js" defer></script>
    <title><%=shop.name%> | Food Xpress</title>
</head>
<body>
<div class="wrapper">
    <jsp:include page="header.jsp"/>
    <main class="main">
        <aside class="sidebar" id="js-sidebar">
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
        <aside class="cart">
            <button type="button" class="cart-btn square-icon-btn">
                <i class="fas fa-shopping-cart"></i>
            </button>
            <div class="cart-header">
                <div>MY CART</div>
            </div>
            <div class="cart-content" id="js-cart-content">
                <table class="cart-order-table" id="js-cart-order-table">
                    <thead id="js-cart-order-table-header">
                    <tr class="cart-order-header">
                        <th>FOOD</th>
                        <th>QTY</th>
                        <th>RM</th>
                        <th></th>
                    </tr>
                    </thead>
                    <tbody class="cart-order">
                    <tr class="cart-order-item">
                        <td>
                            Food Name
                        </td>
                        <td>
                            <button class="quantity-control"><i class="fas fa-minus-circle"></i></button>
                            0
                            <button class="quantity-control"><i class="fas fa-plus-circle"></i></button>
                        </td>
                        <td>0.00</td>
                        <td>
                            <button type="button" class="btn-order-delete">
                                <i class="fas fa-trash-alt"></i>
                            </button>
                        </td>
                    </tr>
                    <tr class="cart-order-remark">
                        <td colspan="3">
                            <i class="fas fa-angle-right"></i>
                            <span>Remark</span>
                        </td>
                        <td></td>
                    </tr>
                    </tbody>
                    <tfoot id="js-cart-order-table-footer">
                    <tr class="cart-order-footer">
                        <td>SUBTOTAL</td>
                        <td colspan="2" id="js-cart-subtotal">0.00</td>
                    </tr>
                    <tr class="cart-order-footer">
                        <td>Delivery Fee</td>
                        <td colspan="2" id="js-cart-delivery_fee"><%=Utils.toTwoDecimalPlaces(shop.delivery_fee)%></td>
                    </tr>
                    <tr class="cart-order-footer">
                        <td>Discount</td>
                        <td colspan="2" id="js-cart-discount">(0.00)</td>
                    </tr>
                    <tr class="cart-order-footer">
                        <td>TOTAL</td>
                        <td colspan="2" id="js-cart-total"><%=Utils.toTwoDecimalPlaces(shop.delivery_fee)%></td>
                    </tr>
                    </tfoot>
                </table>
                <div class="cart-promo">
                    <input class="form-control" type="text" placeholder="Promo Code">
                    <button type="button" class="btn-rect">APPLY</button>
                </div>
                <div class="form-group">
                    <label class="label" for="js-pick-up-location">Pick Up Location: </label>
                    <select name="location" id="js-pick-up-location" class="select-option">
                        <%
                            for (PickUpLocation location : PickUpLocation.values()) {
                        %>
                        <option value="<%=location.toString()%>" <%=location.equals(user.location)?"selected":""%> > <%=location%></option>
                        <%
                            }
                        %>
                    </select>
                </div>
                <div class="cart-checkout-btn-container">
                    <button type="button" class="btn" id="js-checkout-btn">CHECKOUT</button>
                </div>
            </div>
        </aside>
        <main class="food-box box-main">
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
                <div class="card box js-food-pop-up-btn" data-food_id=<%=food.id%>>
                    <div>
                        <img src="images/foods/<%=shopId%>/<%=food.image_url%>" class="box-picture">
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
                        <%
                            if (!food.description.isEmpty()) {
                        %>
                        <p class="box-description"><%=food.description%></p>
                        <%
                            }
                        %>
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

        <div id="js-food-pop-up" class="pop-up" data-shop_id=<%=shopId%>>
            <div class="card box pop-up-card">
                <div id="js-food-pop-up-close-btn" class="pop-up-close-btn">
                    <i class="fas fa-times"></i>
                </div>
                <div class="pop-up-picture-container">
                    <img src="" class="pop-up-picture" id="js-pop-up-picture">
                </div>
                <div class="box-title pop-up-food-name">Food Name</div>
                <div class="pop-up-info">
                    <span class="box-info">RM 0.00</span>
                    <span class="box-info">
                   <i class="fas fa-hourglass-half"></i>
                   0h 0min
                 </span>
                    <span class="box-info">
                   <span class="rating-star">
                     <i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i>
                   </span>
                   5.0
                 </span>
                </div>
                <div class="box-content">

<%--                    <div class="box-detail">--%>
<%--                        --%>
<%--                    </div>--%>
                    <div class="box-description">Description</div>
<%--                    <div>--%>
<%--                        Remark:--%>
                        <div>
                            <textarea class="review-text-area" rows="3" placeholder="Write remarks."></textarea>
                        </div>
<%--                    </div>--%>
                    <div class="container-footer-right l-vertical-center l-row-group-md">
                        <span class="l-vertical-center l-row-group-sm">
                            <label>QTY:</label>
                            <button class="sm-round-icon-btn quantity-btn" type="button" id="js-minus-qty-btn"><i class="fas fa-minus"></i></button>
                            <input class="form-control quantity-input" id="js-quantity-input" value="1" type="number" min="1" required />
                            <button class="sm-round-icon-btn quantity-btn" type="button" id="js-add-qty-btn"><i class="fas fa-plus"></i></button>
                        </span>
                        <button class="btn" type="button" id="js-add-order-item-btn">Add</button>
                    </div>
                </div>
            </div>
        </div>
    </main>
    <%@ include file="footer.jsp" %>
</div>
</body>
</html>

