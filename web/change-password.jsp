<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <%@ include file="meta.jsp" %>
    <title>Change Password | Food XPress</title>
  </head>
  <body>
    <div class="wrapper">
      <jsp:include page="header.jsp"/>
      <main class="main">
        <section class="container change-password-box">
          <h4 class="text-center">Change Password</h4>
          <hr />
          <main>
            <form method="post" action="change-password-servlet">
              <div class="form-group">
                <label class="label" for="current-password">Current password</label>
                <input type="password" class="form-control" id="current-password" name="current-password" placeholder="Enter current password" required>
              </div>
              <div class="form-group">
                <label class="label" for="new-password">New password</label>
                <input type="password" class="form-control" id="new-password" name="new-password" placeholder="Enter new password" required>
              </div>
              <div class="form-group">
                <label class="label" for="confirm-password">Confirm password</label>
                <input type="password" class="form-control" id="confirm-password" name="confirm-password" placeholder="Confirm new password" required>
              </div>
              <div class="container-footer-right">
                <button class="btn" type="submit">Confirm</button>
              </div>
            </form>
          </main>
        </section>
      </main>
      <%@ include file="footer.jsp" %>
    </div>
  </body>
</html>
