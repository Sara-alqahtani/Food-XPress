<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en" dir="ltr">
<head>
    <%@ include file="meta.jsp" %>
    <title>Welcome | Food Xpress</title>
</head>
<body>
<div class="wrapper">
    <%@ include file="welcome-header.jsp" %>
    <main class="welcome-main">
        <div class="welcome-container welcome-box">
            <h4 class="welcome-header-text">
                Order. Relax. Delivered. Enjoy.
            </h4>
            <hr />
            <p class="paragraph-welcome">
                This is a platform for our students to get the food more easier.
                <br /><br />
                Did you experience sometimes you do not want to leave your room but you still have to eat something?
                <br /><br />
                Let's start Food Xpress! Get your all new food experience at your room!
                <br />
            </p>
            <div class="welcome-container-footer">
                <a class="link-btn btn-welcome" href="register">
                    Register
                </a>
                <a class="link-btn btn-welcome" href="login">
                    Login
                </a>
            </div>
        </div>
    </main>
    <%@ include file="footer.jsp" %>
</div>
</body>
</html>
