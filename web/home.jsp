<%@ page import="java.util.ArrayList" %>
<%@ page import="foodxpress.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en" dir="ltr">
<head>
    <%@ include file="meta.jsp" %>
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/master.js" defer></script>
    <title>All Shops | Food Xpress</title>
</head>
<body>
<div class="wrapper">
    <jsp:include page="header.jsp"/>
    <main>
        <aside class="sidebar" id="js-home-sidebar">
            <button type="button" class="sidebar-btn square-icon-btn">
                <i class="fas fa-bars"></i>
            </button>
            <span class="sidebar-header">
            CANTEEN
          </span>
            <ul class="sidebar-content">
                <%
                    for (ShopLocation location : ShopLocation.values()) {
                %>
                <li><a href="#<%=location%>"><%=location.toString().replace("_", " # ")%></a></li>
                <%
                    }
                %>
            </ul>
        </aside>
        <main class="rest-box box-main">
            <%
                SQLProvider provider = new SQLProvider();
                Repository repository = new Repository(provider);
                ArrayList<Shop> shops = repository.getAllShops();
//                for (Shop shop : shops) {
//                    System.out.println(shop.id + ", " + shop.name + ", " + shop.location);
//                }

                String[] locations = new String[] {
                        "B1 # Ground Floor",
                        "D6 # Ground Floor",
                        "D6 # First Floor",
                        "D6 # Second Floor",
                        "LY3 # First Floor"
                };
                ShopLocation previousLocation;
                int j = 0;
                for (int i = 0; i < shops.size(); i++) {
                    previousLocation = shops.get(i).location;
                    // print opening
            %>
            <div class="box-list">
                <div class="box-list-title" id="<%=previousLocation%>">
                    <h5><%=locations[j]%></h5>
                </div>
                <%
                    do {
                        Shop shop = shops.get(i);
                        // print card box
                %>
                <a href="order?shop_id=<%=shop.id%>" class="link-no-decor">
                    <div class="card box">
                        <div class="box-picture">
                            <img src="<%=shop.image_url%>" class="box-picture" alt="shop image">
                        </div>
                        <div class="box-content">
                            <div class="box-detail">
                                <div class="box-title"><%=shop.name%></div>
                                <div>
                       <span class="box-info">
                         <i class="far fa-clock"></i>
                         <%=Utils.printTime(shop.operation_start_time)%> - <%=Utils.printTime(shop.operation_end_time)%>
                       </span>
                                    <span class="box-info">
                         <i class="fas fa-hourglass-half"></i>
                         <%=Utils.printHourMinute(shop.delivery_time)%>
                       </span>
                                    <span class="box-info">
                         <span class="rating-star">
                             <%
                                 double rating = Double.parseDouble(Utils.toOneDecimalPlaces(shop.rating));
                                 int fullStar = (int) rating;
                                 boolean halfStarExist = (rating - fullStar) > 0;
                                 int emptyStar = 5 - fullStar;
                                 if (halfStarExist)
                                     emptyStar--;
                                 for (int k = 0; k < fullStar; k++) {
                             %>
                             <i class="fas fa-star"></i>
                             <%
                                 }
                                 if (halfStarExist) {
                             %>
                             <i class="fas fa-star-half-alt"></i>
                             <%
                                 }
                                 for (int k = 0; k < emptyStar; k++) {
                             %>
                             <i class="far fa-star"></i>
                             <%
                                 }
                             %>
<%--                           <i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star-half-alt"></i><i class="far fa-star"></i>--%>
                         </span>
                         <%=Utils.toOneDecimalPlaces(shop.rating)%>
                       </span>
                                </div>
                            </div>
                            <div class="box-description">
                                <%=shop.description%>
                            </div>
                        </div>
                    </div>
                </a>
                <%
                        i++;
                    } while (i < shops.size() && shops.get(i).location.equals(previousLocation));
                    if (i < shops.size() && !shops.get(i).location.equals(previousLocation)) {
                        i--;
                        j++;
                    }
                    // print closing
                %>
            </div>
            <%
                }
            %>
        </main>
    </main>
    <%@ include file="footer.jsp" %>
</div>
</body>
</html>
