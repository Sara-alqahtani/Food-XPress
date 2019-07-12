<%@ page import="foodxpress.User" %>
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
          <h4 class="text-center">User Profile</h4>
          <hr />
          <main class="l-flex-wrap l-center">
            <div>
              <img src="../images/profile.png" class="profile-picture" alt="Profile Picture">
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
                <label class="label" >Preferred Order Collection Location</label>
                <input type="text" class="form-control" value="<%=user.location%>" disabled>
              </div>
            </form>
          </main>
          <footer class="container-footer-right">
            <a class="link-btn" href="edit-profile">
              <i class="fas fa-user-edit"></i>
              Edit
            </a>
          </footer>
        </section>
      </main>
      <%@ include file="footer.jsp" %>
    </div>
  </body>
</html>
