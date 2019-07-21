<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en" dir="ltr">
<head>
    <%@ include file="meta.jsp" %>
    <%
        String newUserUsername = (String) session.getAttribute("new_user_username");
        if (newUserUsername != null) {
            session.removeAttribute("new_user_username");
    %>
    <script defer>
        window.addEventListener('load', function() {
            alert("Register successfully. Login now to enjoy delicious food in a few clicks away.");
        });
    </script>
    <%
        }
    %>
    <title>Login | Food Xpress</title>
</head>
<body>
<div class="wrapper">
    <%@ include file="welcome-header.jsp" %>
    <main class="welcome-main">
        <section class="container login-box">
            <h4 class="text-center">Login</h4>
            <hr />
            <form method="post" action="login-servlet">
                <div class="form-group">
                    <label class="label" for="login-username">Username</label>
                    <input type="text" name="username" class="form-control" placeholder="Enter username" id="login-username" value="<%=newUserUsername != null ? newUserUsername : ""%>" required>
                </div>
                <div class="form-group">
                    <label class="label" for="login-password">Password</label>
                    <input type="password" name="password" class="form-control" placeholder="Enter password" id="login-password" required>
                </div>
                <div class="login-register-link">
                    <a class="internal-link" href="register">Don't have an account? Register now!</a>
                </div>
                <div class="container-footer-right">
                    <button type="submit" class="btn">Login</button>
                </div>
            </form>
        </section>
    </main>
    <%@ include file="footer.jsp" %>
</div>
</body>
</html>

