<%@ page import="foodxpress.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  Vendor vendor= (Vendor) session.getAttribute("vendor");
  SQLProvider provider = new SQLProvider();
  Repository repository = new Repository(provider);
  Shop shop = repository.getShopInfo(vendor.shop_id);
%>

<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <%@ include file="meta.jsp" %>
    <title>Shop Profile | Food XPress</title>
  </head>
  <body>
    <div class="wrapper">
      <jsp:include page="vendor-header.jsp"/>
      <main class="main">
        <section class="container shop-profile-box">
          <h4 class="text-center">Shop Profile</h4>
          <hr />
          <main class="l-flex-wrap vendor-profile">
            <div>
                <div class="profile-picture">
                    <img src="images/shop-image/<%=shop.image_url%>?shop_id=<%=shop.id%>" class="profile-picture" alt="profile image">
                </div>
              <div class="l-center shop-rating-display ">
                <span class="big-rating-star">
                  <%
                     double rating = Double.parseDouble(Utils.toOneDecimalPlaces(shop.rating));
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
               </span>
                  <span class="big-rating-star-text"><%=Utils.toOneDecimalPlaces(shop.rating)%></span>

             </div>
            </div>
            <form class="user-profile-form">
              <div class="form-group">
                <label class="label">Shop Name</label>
                <input type="text" class="form-control" value="<%=shop.name%>" disabled>
              </div>
              <div class="form-group">
                <label class="label" >Location</label>
                <input type="text" class="form-control" value="<%=shop.location.toString().replace('_','#')%>" disabled>
              </div>
              <div class="form-group">
                <label class="label" >Description</label>
                <textarea rows="5" class="form-control review-text-area" disabled><%=shop.description%></textarea>
              </div>
              <div class="form-group">
                <label class="label" >Operating Time</label>
                <input type="text" class="form-control" value="<%=Utils.printTime(shop.operation_start_time)%> to <%=Utils.printTime(shop.operation_end_time)%>" disabled>
              </div>
              <div class="form-group">
                <label class="label" >Delivery Time </label>
                <input type="text" class="form-control" value="<%=shop.delivery_time%> minutes" disabled>
              </div>
              <div class="form-group">
                <label class="label" >Delivery Fee</label>
                <input type="text" class="form-control" value="RM <%=Utils.toTwoDecimalPlaces(shop.delivery_fee)%>" disabled>
              </div>
              <div class="container-footer-right">
                <a class="link-btn" href="shop-edit-profile">
                  <i class="fas fa-user-edit"></i>
                  Edit
                </a>
              </div>
            </form>
          </main>
        </section>
      </main>
      <%@ include file="footer.jsp" %>
    </div>
  </body>
</html>
