package foodxpress;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.awt.*;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet(name = "UpdateProfileServlet")
public class UpdateProfileServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        String username = user.username;
        String mobile = request.getParameter("mobile").replace("\'", "");
        String location = request.getParameter("location").replace("\'", "");

        SQLProvider provider = new SQLProvider();
        Repository repository = new Repository(provider);
        boolean isSuccess = repository.updateUserInfo(username, mobile,location);

        if (isSuccess){
            user.mobile = mobile;
            user.location = PickUpLocation.valueOf(location);
            response.sendRedirect("view-profile");
        } else {
            PrintWriter out = response.getWriter();
            out.println("Unable to update");
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }
}
