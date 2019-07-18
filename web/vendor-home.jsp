<%@ page import="foodxpress.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Vendor vendor = (Vendor) session.getAttribute("vendor");
    SQLProvider provider = new SQLProvider();
    Repository repository = new Repository(provider);

    Shop shop = repository.getShopInfo(vendor.shop_id);

    ArrayList<Order> orders = repository.getAllOrdersOfShop(shop.id);
    Integer orderId = null;
    try {
        orderId = Integer.parseInt(request.getParameter("order_id"));
    } catch (NumberFormatException e) {
        if (! orders.isEmpty()) {
            orderId = orders.get(0).id;
            response.sendRedirect("vendor-home?order_id=" + orderId);
            return;
        }
    }
    Order order = null;
%>
<html>
<head>
    <%@ include file="meta.jsp"%>
    <title>Order List | <%=shop.name%> | Food Xpress</title>
</head>
<body>
<div class="wrapper">
    <jsp:include page="vendor-header.jsp"/>
    <main>
        <aside class="sidebar" id="js-home-sidebar">
            <button type="button" class="sidebar-btn square-icon-btn">
                <i class="fas fa-bars"></i>
            </button>
            <span class="sidebar-header">
            ORDER LIST
          </span>
            <ul class="sidebar-content">
                <%
                    for (Order orderTemp : orders) {
                        if (orderId != null && orderId == orderTemp.id) {
                            order = orderTemp;
                        }
                %>
                <li class="<%=(orderId != null && orderId == orderTemp.id) ? "sidebar-item-selected" : ""%>">
                    <a href="vendor-home?order_id=<%=orderTemp.id%>">
                        #<%=orderTemp.id%> <%=orderTemp.username%>
                    </a>
                </li>
                <%
                    }
                %>
            </ul>
        </aside>
        <main class="vendor-order-main container-borderless l-center">
            <section class="vendor-order-section">
                <%
                    if (order == null) {
                %>
                <h5 class="text-center text-itallic">
                    No order yet.<br /><br />
                    Waiting for order...
                </h5>
                <%
                    } else {
                        User user = repository.getUserInfo(order.username);
                %>
                <div class="l-flex-wrap l-vertical-center l-row-group-md hover-hidden-parent">
                    <h4>#<%=order.id%> <%=user.username%></h4>
                    <h6>
                        <i class="fas fa-phone"></i>
                        <span class="hover-hidden-child"><%=user.mobile%></span>
                    </h6>
                    <h6>
                        <i class="fas fa-map-marker-alt"></i>
                        <span class="hover-hidden-child"><%=user.location%></span>
                    </h6>
                    <img src="images/user-profile/<%=user.image_url%>" class="profile-picture-sm" alt="user image"/>
                </div>
                <hr />
                <main class="l-col-group-md">
                    <h6><%=Utils.printDate(order.datetime)%></h6>
                    <div class="invoice-table">
                        <table class="invoice-order-table">
                            <thead>
                            <tr class="cart-order-header">
                                <th>FOOD</th>
                                <th>QTY</th>
                                <th>RM</th>
                            </tr>
                            </thead>
                            <%
                                ArrayList<OrderItem> orderItems = repository.getAllOrderItemsInOrder(shop.id, order.id);
                                for (OrderItem item : orderItems) {
                            %>
                            <tbody class="cart-order">
                            <tr class="cart-order-item">
                                <td><%=item.food_name%></td>
                                <td><%=item.quantity%></td>
                                <td><%=String.format("%.2f", item.subtotal)%></td>
                            </tr>
                            <tr class="cart-order-remark">
                                <td colspan="3">
                                    <%
                                        if (item.remark != null) {
                                    %>
                                    <i class="fas fa-angle-right"></i>
                                    <span><%=item.remark%></span>
                                    <%
                                        }
                                    %>
                                </td>
                                <td></td>
                            </tr>
                            </tbody>
                            <%
                                }
                            %>
                            <tfoot>
                            <tr class="cart-order-footer">
                                <td>SUBTOTAL</td>
                                <td colspan="2"><%=Utils.toTwoDecimalPlaces(order.subtotal)%></td>
                            </tr>
                            <tr class="cart-order-footer">
                                <td>Delivery Fee</td>
                                <td colspan="2"><%=Utils.toTwoDecimalPlaces(order.delivery_fee)%></td>
                            </tr>
                            <%
                                if (order.promo_code > 0) {
                            %>
                            <tr class="cart-order-footer">
                                <td>Discount (Promo #<%=order.promo_code%>)</td>
                                <td colspan="2">(<%=Utils.toTwoDecimalPlaces(order.discount)%>)</td>
                            </tr>
                            <%
                                }
                            %>
                            <tr class="cart-order-footer">
                                <td>TOTAL</td>
                                <td colspan="2"><%=Utils.toTwoDecimalPlaces(order.total)%></td>
                            </tr>
                            </tfoot>
                        </table>
                    </div>
                    <div class="invoice-status">
                        <%
                            String[] iconClasses = new String[] {
                                    "fas fa-clipboard-list",
                                    "fas fa-clipboard-check",
                                    "fas fa-truck",
                                    "fas fa-utensils"
                            };
                            int i = 0;
                            for (OrderStatus status : OrderStatus.values()) {
                        %>
                        <a class="order-status" href="update-order-status-servlet?order_id=<%=order.id%>&status=<%=status.toString().toLowerCase()%>">
                            <div class="parallelogram<%=order.status.compareTo(status)<0?" parallelogram-inactive":""%>"></div>
                            <div class="parallelogram2<%=order.status.compareTo(status)<0?" parallelogram-inactive":""%>"></div>
                            <span class="order-status-content">
                  <i class="<%=iconClasses[i++]%>"></i>
                  <span class="order-status-text"><%=Utils.capitalize(status.toString())%></span>
                </span>
                        </a>
                        <%
                            }
                        %>
                    </div>
                </main>
                <%
                    }
                %>
            </section>
        </main>
    </main>
    <%@ include file="footer.jsp"%>
<%--    <footer class="footer l-horizontal-center">--%>
<%--        Exclusive for XMUM ~ copyright@ 2019 FoodXpress all right reserved ~--%>
<%--    </footer>--%>
</div>
</body>
</html>
