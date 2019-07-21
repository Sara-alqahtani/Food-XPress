<%@ page import="foodxpress.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en" dir="ltr">
<head>
  <%@ include file="meta.jsp" %>
  <title>Review | Food Xpress</title>
</head>

  	<div class="wrapper">
      <jsp:include page="header.jsp"/>
  	  <main class="main">
        <section class="container review-main">

            <%
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

              System.out.println("shopid: " + shopId );
              System.out.println("orderid: " + orderId );

              SQLProvider provider = new SQLProvider();
              Repository repository = new Repository(provider);
              Shop shop = repository.getShopInfo(shopId);
            %>
          <h4 class="text-center"><%=shop.name%></h4>
          <hr />
          <main>
            <%

              ArrayList<Food> reviewItems = repository.getReviewFoodList(shopId, orderId);

              for (Food food : reviewItems) {
                System.out.println(food);


            %>

            <form class="review-form" method="post" action="review-servlet">
                <input type="number" name="shop_id" value="<%=shopId%>" hidden>
                <input type="number" name="order_id" value="<%=orderId%>" hidden>
            <div class="box">
              <div class="box-picture">
                <img src="images/foods/<%=shopId%>/<%=food.image_url%>" class="box-picture" alt="food image">
              </div>
              <div class="box-content">
                <div class="box-detail">
                  <div class="box-title"><%=food.name%></div>
                  <div class="">
                    <span class="box-info">RM<%=Utils.toTwoDecimalPlaces(food.price)%></span>
                    <span class="box-info">
                      <i class="fas fa-hourglass-half"></i>
                      <%=Utils.printHourMinute(food.prepare_time)%>
                    </span>
                    <div class="review-star">
<%--                        <form >--%>
                            <fieldset class="starability-grow">
                                <input type="radio" id="F<%=food.id%>-star5" name="<%=food.id%>" value="5" required/>
                                <label id="F<%=food.id%>-label5" for="F<%=food.id%>-star5" title="Amazing"></label>
                                <input type="radio"  id="F<%=food.id%>-star4" name="<%=food.id%>" value="4" required/>
                                <label id="F<%=food.id%>-label4" for="F<%=food.id%>-star4" title="Very good"></label>
                                <input type="radio"  id="F<%=food.id%>-star3" name="<%=food.id%>" value="3" required/>
                                <label id="F<%=food.id%>-label3" for="F<%=food.id%>-star3" title="Average"></label>
                                <input type="radio"  id="F<%=food.id%>-star2" name="<%=food.id%>" value="2" required/>
                                <label id="F<%=food.id%>-label2" for="F<%=food.id%>-star2" title="Not good"></label>
                                <input type="radio"  id="F<%=food.id%>-star1" name="<%=food.id%>" value="1" required/>
                                <label id="F<%=food.id%>-label1" for="F<%=food.id%>-star1" title="Terrible"></label>
                            </fieldset>
<%--                        </form>--%>
                    </div>
                  </div>
                </div>
              </div>
            </div>
             <%
               }
             %>
              <div class="rate-shop">
                <span class="review-text-shop">Rate Us:</span>
                <span class="review-star-shop">

                  <fieldset class="starability-grow">
                    <input type="radio" id="S-star5" name="shop_rating" value="5" required/>
                    <label for="S-star5" title="Amazing"></label>
                    <input type="radio" id="S-star4" name="shop_rating" value="4" required/>
                    <label for="S-star4" title="Very good"></label>
                    <input type="radio" id="S-star3" name="shop_rating" value="3" required/>
                    <label for="S-star3" title="Average"></label>
                    <input type="radio" id="S-star2" name="shop_rating" value="2" required/>
                    <label for="S-star2" title="Not good"></label>
                    <input type="radio" id="S-star1" name="shop_rating" value="1" required/>
                    <label for="S-star1" title="Terrible"></label>
                  </fieldset>
                </span>
              </div>

              <div class="container-footer-right">
                  <button class="btn" type="submit">Submit</button>
              </div>
            </form>

  	    	</main>
        </section>
      </main>
      <%@ include file="footer.jsp"%>
    </div>
</body>
</html>
