<%@ page import="foodxpress.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    User user = (User) session.getAttribute("user");
%>
<header class="header">
    <div>
        <img src="<%=request.getContextPath()%>/images/logo.png" alt="Logo">
    </div>
    <div class="header-navigation">
        <nav>
            <ul class="navigation-horizontal">
                <li>
                    <a href="<%=request.getContextPath()%>/home">
                        <button type="button" class="nav-btn">
                            <i class="fas fa-home"></i>
                            <span>HOME</span>
                        </button>
                    </a>
                </li>
                <li>
                    <a href="<%=request.getContextPath()%>/order-status">
                        <button type="button" class="nav-btn">
                            <i class="fas fa-clipboard-list"></i>
                            <span>STATUS</span>
                        </button>
                    </a>
                </li>
            </ul>
        </nav>
        <div class="l-row-group-sm l-center">
                <span class="header-username-text">
                    <%=user.username!=null?user.username:"User"%>
                </span>
            <nav class="dropdown">
                <button type="button" class="round-icon-btn">
                    <i class="fas fa-user"></i>
                </button>
                <ul class="navigation-vertical dropdown-content">
                    <li><a href="view-profile.html">User Profile</a></li>
                    <li><a href="change-password.html">Change Password</a></li>
                    <li><a href="#">Log Out</a></li>
                </ul>
            </nav>
        </div>
    </div>
</header>