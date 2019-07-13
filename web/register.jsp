<%@ page import="foodxpress.PickUpLocation" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en" dir="ltr">
<head>
    <%@ include file="meta.jsp" %>
    <title>Register | Food Xpress</title>
</head>
<body>
<div class="wrapper">
    <%@ include file="welcome-header.jsp" %>
    <main class="welcome-main">
        <section class="container register-box">
            <h4 class="text-center">Register New Account</h4>
            <hr />
            <form method="post" action="register-servlet">
                <div class="form-group">
                    <label class="label" for="register-username">Username</label>
                    <input type="text" name="username" class="form-control" placeholder="Enter username" id="register-username" required>
                </div>
                <div class="form-group">
                    <label class="label" for="register-password">Password</label>
                    <input type="password" name="password" class="form-control" placeholder="Enter password" id="register-password" required>
                </div>
                <div class="form-group">
                    <label class="label" for="register-confirm-password">Confirm Password</label>
                    <input type="password" name="confirm-password" class="form-control" placeholder="Confirm password" id="register-confirm-password" required>
                </div>
                <div class="form-group">
                    <label class="label" for="register-phone-number">Phone Number</label>
                    <input type="tel" name="mobile" class="form-control" placeholder="Enter phone number" id="register-phone-number" required>
                </div>
                <div class="form-group">
                    <label class="label" for="collection-location">Pick Up Location</label>
                    <div >
                        <select name="location" id="collection-location" class="select-option">
                            <%
                                for (PickUpLocation location : PickUpLocation.values()) {
                            %>
                            <option value="<%=location.toString()%>"> <%=location%></option>
                            <%
                                }
                            %>
                        </select>
                    </div>
                </div>
                <div class="container-footer-right">
                    <button type="submit" class="btn">Register</button>
                </div>
            </form>
        </section>
    </main>
    <%@ include file="footer.jsp" %>
</div>
</body>
</html>
