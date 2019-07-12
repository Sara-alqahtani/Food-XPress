package foodxpress;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet(name = "foodxpress.ChangePasswordServlet")
public class ChangePasswordServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        String username = user.username;
        String oldPassword = request.getParameter("currentPassword").replace("\'", "");
        String newPassword = request.getParameter("NewPassword").replace("\'", "");
        String ConfirmNewPassword = request.getParameter("ConfirmNewPassword").replace("\'", "");


        if (!newPassword.equals(ConfirmNewPassword)){
            PrintWriter out = response.getWriter();
            out.println("The new password is different from the confirmed password. Please confirm your password.");
            return;
        }

        SQLProvider provider = new SQLProvider();
        Repository repository = new Repository(provider);
        boolean isSuccess = repository.changePassword(username,oldPassword,newPassword);

        if (isSuccess){
            response.sendRedirect("home");
        }else {
            PrintWriter out = response.getWriter();
            out.println("Unable to change password");
        }

    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}
