<%@ page import="foodxpress.*" %>
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
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/edit-profile.js" defer></script>
    <title>Edit Shop Profile | Food XPress</title>
  </head>
  <body>
    <div class="wrapper">
      <jsp:include page="vendor-header.jsp"/>
      <main class="main">
        <section class="container shop-profile-box">
          <h4 class="text-center">Edit Shop Profile</h4>
          <hr />
          <main class="l-flex-wrap vendor-profile">
            <div class="l-stack">
              <img src="images/shop-image/<%=shop.image_url%>" class="profile-picture" id="js-edit-profile-picture" alt="profile image">
              <label class="round-icon-btn upload-profile-picture-btn l-center" for="js-upload-image">
                <i class="fas fa-camera"></i>
              </label>
            </div>
            <form class="user-profile-form" method="post" enctype="multipart/form-data" action="vendor-update-profile-servlet">
              <input type="file" accept="image/*" id="js-upload-image" name="image" hidden>
              <input type="radio" id="js-remove-image" name="remove-image" value="true" hidden>
              <div class="form-group">
                <label class="label">Shop Name</label>
                <input type="text" class="form-control" value="<%=shop.name%>" disabled>
              </div>
              <div class="form-group">
                <label class="label" for="shop-location">Location</label>
                <div >
                  <select name="location" id="shop-location" class="shop-select-option">
                    <%
                      for (ShopLocation location : ShopLocation.values()) {
                    %>
                    <option value="<%=location.toString()%>" <%=location.equals(shop.location)?"selected":""%>>
                      <%=location.toString().replace('_', '#')%>
                    </option>
                    <%
                      }
                    %>
                  </select>
                </div>
                <div class="form-group">
                  <label class="label" for="description">Description</label>
                  <textarea rows="5" name="description" class="form-control review-text-area" id="description" required><%=shop.description%></textarea>
                </div>
                <div class="form-group">
                  <label class="label" for="operating-time">Operating Time</label>
                  <div class="form-control">
                    <input type="time" name="operation_start_time" id="operating-time" value="<%=shop.operation_start_time%>" required>
                    to
                    <input type="time" name="operation_end_time" id="operating-time-end" value="<%=shop.operation_end_time%>" required>
                  </div>
                </div>
                <div class="form-group">
                  <label class="label" for="delivery-time">Delivery Time (min)</label>
                  <input type="text" name="deliveryTime" class="form-control" id="delivery-time" value="<%=shop.delivery_time%>" required>
                </div>
                <div class="form-group">
                  <label class="label" for="delivery-fee">Delivery Fee (RM)</label>
                  <input type="text" name="deliveryFee" class="form-control" id="delivery-fee" value="<%=Utils.toTwoDecimalPlaces(shop.delivery_fee)%>" required>
                </div>
              </div>
              <div class="container-footer-right l-row-group-md">
                <a class="link-btn" href="shop-profile">Discard</a>
                <button class="btn-green" type="submit">Save</button>
              </div>
            </form>
          </main>
        </section>
      </main>
      <%@ include file="footer.jsp" %>
    </div>
  </body>
</html>
