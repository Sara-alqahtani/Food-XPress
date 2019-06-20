package foodxpress;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet(name = "RegisterServlet")
public class RegisterServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username").replace("\'", "");
        String password = request.getParameter("password").replace("\'", "");
        String confirmPassword = request.getParameter("confirm-password").replace("\'", "");
        String mobile = request.getParameter("mobile").replace("\'", "");
        String location = request.getParameter("location").replace("\'", "");

        if (!password.equals(confirmPassword)) {
            PrintWriter out = response.getWriter();
            out.println("The password is different from the confirmed password. Please confirm your password.");
            return;
        }

        SQLProvider provider = new SQLProvider();
        Repository repository = new Repository(provider);
        boolean isSuccess = repository.register(username, password, mobile, location);
        if (isSuccess) {
            response.sendRedirect("login");
        } else {
            PrintWriter out = response.getWriter();
            out.println("Username is taken. Please try another username.");
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }
}
