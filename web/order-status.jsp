<%@ page import="java.util.ArrayList" %>
<%@ page import="foodxpress.*" %>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en" dir="ltr">
<head>
    <%@ include file="meta.jsp" %>
    <title>Order Status | Food Xpress</title>
</head>
<body>
<div class="wrapper">
    <jsp:include page="header.jsp"/>
    <%
        SQLProvider provider = new SQLProvider();
        Repository repository = new Repository(provider);

        int orderId;
        int shopId;
        try {
            orderId = Integer.parseInt(request.getParameter("order_id")) ;
            shopId = Integer.parseInt(request.getParameter("shop_id")) ;
        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendRedirect("order-list");
            return;
        }
        Order order = repository.getOrderInfo(shopId, orderId);
        ArrayList<OrderItem> orderItems = repository.getAllOrderItemsInOrder(shopId, orderId);
    %>
    <main class="main">
        <section class="container invoice-main">
            <h4 class="text-center">Invoice</h4>
            <hr />
            <main class="l-col-group-md">
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
                    <div class="order-status">
                        <div class="parallelogram<%=order.status.compareTo(status)<0?" parallelogram-inactive":""%>"></div>
                        <div class="parallelogram2<%=order.status.compareTo(status)<0?" parallelogram-inactive":""%>"></div>
                        <span class="order-status-content">
                  <i class="<%=iconClasses[i++]%>"></i>
                  <span class="order-status-text"><%=Utils.capitalize(status.toString())%></span>
                </span>
                    </div>
                    <%
                        }
                    %>
                </div>
                <div class="invoice-header">
                    <div class="form-group">
                        <label class="label">Order No.:</label>
                        <input type="text" class="form-control" value="<%=order.shop_name%> #<%=order.id%>" disabled>
                    </div>
                    <div class="form-group">
                        <label class="label">Order Time:</label>
                        <input type="text" class="form-control" value="<%=Utils.printDate(order.datetime)%>" disabled>
                    </div>
                    <div class="form-group">
                        <label class="label">Promo Code:</label>
                        <input type="text" class="form-control" value="<%=order.promo_code == 0 ? "N/A" : order.promo_code%>" disabled>
                    </div>
                </div>

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
                            for (OrderItem item : orderItems) {
                                System.out.println(item);
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
                        <tr class="cart-order-footer">
                            <td>Discount</td>
                            <td colspan="2">(<%=Utils.toTwoDecimalPlaces(order.discount)%>)</td>
                        </tr>
                        <tr class="cart-order-footer">
                            <td>TOTAL</td>
                            <td colspan="2"><%=Utils.toTwoDecimalPlaces(order.total)%></td>
                        </tr>
                        </tfoot>
                    </table>
                </div>
            </main>
        </section>
    </main>
    <%@ include file="footer.jsp"%>
</div>
</body>
</html>