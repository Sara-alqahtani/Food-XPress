<%@ page import="foodxpress.User" %>
<%
  User user = (User) session.getAttribute("user");
%>
<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <%@ include file="meta.jsp" %>
    <title>User Profile | Food XPress</title>
  </head>
  <body>
    <div class="wrapper">
      <jsp:include page="header.jsp"/>
      <main class="main">
        <section class="container user-profile-box">
          <h4 class="text-center">User Profile</h4>
          <hr />
          <main class="l-flex-wrap l-center">
            <div class="profile-picture">
              <img src="images/user-profile/<%=user.image_url%>" class="profile-picture" alt="profile image">
            </div>
            <form class="user-profile-form">
              <div class="form-group">
                <label class="label">User Name</label>
                <input type="text" class="form-control" value="<%=user.username%>" disabled>
              </div>
              <div class="form-group">
                <label class="label" >Mobile Number</label>
                <input type="tel" class="form-control" value="<%=user.mobile%>" disabled>
              </div>
              <div class="form-group">
                <label class="label" >Pick Up Location</label>
                <input type="text" class="form-control" value="<%=user.location%>" disabled>
              </div>
              <div class="container-footer-right">
                <a class="link-btn" href="edit-profile">
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
