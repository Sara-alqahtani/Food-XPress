<%@ page import="foodxpress.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <%@ include file="meta.jsp" %>
    <title>Order List | Food Xpress</title>
  </head>
  <body>
  	<div class="wrapper">
      <jsp:include page="header.jsp"/>
        <%
            User user = (User) session.getAttribute("user");
            String username = user.username;
            SQLProvider provider = new SQLProvider();
            Repository repository = new Repository(provider);
            ArrayList<Order> orderlist = repository.getAllOrdersofUser(username);
        %>
  	  <main class="box-order-main orderlist-box">

            <h4 class="text-center">Order</h4>
            <hr/>
            <div class="order-list-title">
                <h5>Recent Orders</h5>
            </div>
          <%
              if (orderlist.isEmpty()) {
          %>
          <h5 class="text-center text-itallic">
              No order yet.<br /><br />
              Place your order now!
          </h5>
          <%
              }
          %>
        <%
          for (Order order : orderlist) {
        %>

          <a href=order-status?order_id=<%=order.id%>&shop_id=<%=order.shop_id%> >

          <div class="card box">
              <div class="box-content">
                <div class="order-status-chart">
                  <%
                      if (order.status.equals(OrderStatus.ORDERING)){
                  %>
                  <div class="c100 p25 green ">
                    <span><%=order.status%></span>
                    <div class="slice">
                      <div class="bar"></div>
                      <div class="fill"></div>
                    </div>
                  </div>
                   <%
                     }
                      else if (order.status.equals(OrderStatus.COOKING)){
                   %>
                    <div class="c100 p50 green ">
                      <span><%=order.status%></span>
                      <div class="slice">
                        <div class="bar"></div>
                        <div class="fill"></div>
                      </div>
                    </div>
                    <%
                      }
                      else if (order.status.equals(OrderStatus.DELIVERING)){
                    %>
                      <div class="c100 p75 green">
                        <span><%=order.status%></span>
                        <div class="slice">
                          <div class="bar"></div>
                          <div class="fill"></div>
                        </div>
                      </div>
                     <%
                       }
                      else{
                     %>
                      <div class="c100 p100 green">
                          <span><%=order.status%></span>
                          <div class="slice">
                              <div class="bar"></div>
                              <div class="fill"></div>
                          </div>
                      </div>
                      <%
                        }
                      %>

                </div>


                  <%
                      if ((order.status.equals(OrderStatus.ENJOY))&& (!order.is_reviewed)){
                  %>
                  <div class="review-icon">
                       <i class="fa fa-exclamation-circle" aria-hidden="true"></i>
                      <span title="review-hint" >Rate Us </span>
                  </div>

                  <%
                      }
                  %>



                <table class="orderlist-box-text">
                  <tr class="orderlist-box-detail">
                    <td class="orderlist-box-title">
                      Order No.:
                    </td>
                    <td class="orderlist-box-info">
                        <%=order.shop_name%> #<%=order.id%>
                    </td>
                  </tr>

                  <tr class="orderlist-box-detail">
                    <td class="orderlist-box-title">
                      Order Time:
                    </td>
                    <td class="orderlist-box-info">
                      <%=Utils.printDate(order.datetime)%>
                    </td>
                  </tr>

                  <tr class="orderlist-box-detail">
                    <td class="orderlist-box-title">
                        Pick Up At:
                    </td>
                    <td class="orderlist-box-info">
                        <%=order.pick_up_location.toString()%>
                    </td>
                  </tr>

                  <tr class="orderlist-box-detail">
                    <td class="orderlist-box-title">
                      Total Price:
                    </td>
                    <td class="orderlist-box-info">RM
                      <%=Utils.toTwoDecimalPlaces(order.total)%>
                    </td>
                  </tr>
                </table>


              </div>
            </div>

          </a>

        <%


          }
          %>
      </main>
      <%@ include file="footer.jsp"%>
    </div>
  </body>
</html>
