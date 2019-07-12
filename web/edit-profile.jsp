<%@ page import="foodxpress.User" %>
<%@ page import="foodxpress.PickUpLocation" %>
<%
  User user = (User) session.getAttribute("user");
%>
<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <%@ include file="meta.jsp" %>
    <title>Food XPress</title>
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
              <img src="../images/profile.png" class="profile-picture" alt="Profile Picture">
              <button class="round-icon-btn upload-profile-picture-btn"><i class="fas fa-camera"></i></button>
            </div>
            <form class="user-profile-form" method="post" action="edit-profile-servlet">
              <div class="form-group">
                <label class="label" >User Name</label>
                <input type="text" class="form-control" name="username" value="<%=user.username%>" disabled>
              </div>
              <div class="form-group">
                <label class="label" for="mobile-number">Mobile Number</label>
                <input type="tel" name="mobile" class="form-control" id="mobile-number" value="<%=user.mobile%>" required>
              </div>
              <div class="form-group">
                <label class="label" for="collection-location">Preferred Order Collection Location</label>
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
