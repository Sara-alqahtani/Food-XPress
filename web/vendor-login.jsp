<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en" dir="ltr">
<head>
    <%@ include file="meta.jsp" %>
    <title>Vendor Login | Food Xpress</title>
</head>
<body>
<div class="wrapper">
    <%@ include file="welcome-header.jsp" %>
    <main class="welcome-main">
        <section class="container login-box">
            <h4 class="text-center">Vendor Login</h4>
            <hr />
            <form method="post" action="vendor-login-servlet">
                <div class="form-group">
                    <label class="label" for="login-vendor_id">Vendor Id</label>
                    <input type="text" name="vendor_id" class="form-control" placeholder="Enter vendor id" id="login-vendor_id" required>
                </div>
                <div class="form-group">
                    <label class="label" for="login-password">Password</label>
                    <input type="password" name="password" class="form-control" placeholder="Enter password" id="login-password" required>
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

