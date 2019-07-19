<%@ page import="foodxpress.PickUpLocation" %>
<%@ page import="foodxpress.User" %>
<%
  User user = (User) session.getAttribute("user");
%>
<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <%@ include file="meta.jsp" %>
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/edit-profile.js" defer></script>
    <title>Edit Profile | Food XPress</title>
  </head>
  <body>
    <div class="wrapper">
      <jsp:include page="header.jsp"/>
      <main class="main">
        <section class="container user-profile-box">
          <h4 class="text-center">Edit Profile</h4>
          <hr />
          <main class="l-flex-wrap l-center">
            <div class="l-stack">
              <img src="images/user-profile/<%=user.image_url%>" class="profile-picture" id="js-edit-profile-picture" alt="profile image">
              <label class="round-icon-btn upload-profile-picture-btn l-center" for="js-upload-image">
                <i class="fas fa-camera"></i>
              </label>
              <label class="sm-round-icon-btn remove-profile-picture-btn" for="js-remove-image" id="js-remove-profile-picture-btn">
                <i class="fas fa-times"></i>
              </label>
            </div>
            <form class="user-profile-form" method="post" enctype="multipart/form-data" action="edit-profile-servlet">
              <input type="file" accept="image/*" id="js-upload-image" name="image" hidden>
              <input type="radio" id="js-remove-image" name="remove-image" value="true" hidden>
              <div class="form-group">
                <label class="label">User Name</label>
                <input type="text" class="form-control" value="<%=user.username%>" disabled>
              </div>
              <div class="form-group">
                <label class="label" for="mobile-number">Mobile Number</label>
                <input type="tel" name="mobile" class="form-control" id="mobile-number" value="<%=user.mobile%>" required>
              </div>
              <div class="form-group">
                <label class="label" for="collection-location">Pick Up Location</label>
                <div >
                  <select name="location" id="collection-location" class="select-option">
                    <%
                      for (PickUpLocation location : PickUpLocation.values()) {
                    %>
                    <option value="<%=location.toString()%>" <%=location.equals(user.location)?"selected":""%> > <%=location%></option>
                    <%
                      }
                    %>
                  </select>
                </div>
              </div>
              <div class="container-footer-right l-row-group-md">
                <a class="link-btn" href="view-profile">Discard</a>
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
