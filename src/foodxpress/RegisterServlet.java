package foodxpress;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet(name = "RegisterServlet")
public class RegisterServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username").replace("\'", "");
        String password = request.getParameter("password").replace("\'", "");
        String confirmPassword = request.getParameter("confirm-password").replace("\'", "");
        String mobile = request.getParameter("mobile").replace("\'", "");
        PickUpLocation location = Utils.tryParseEnum(PickUpLocation.class, request.getParameter("location"));

        if (!password.equals(confirmPassword)) {
            PrintWriter out = response.getWriter();
            out.println("<script type=\"text/javascript\">");
            out.println("window.location.replace('register');");
            out.println("alert('The password is different from the confirmed password. Please confirm your password.');");
            out.println("</script>");
            return;
        }

        SQLProvider provider = new SQLProvider();
        Repository repository = new Repository(provider);
        boolean isSuccess = repository.register(username, password, mobile, location);
        if (isSuccess) {
            request.getSession().setAttribute("new_user_username", username);
            response.sendRedirect("login");
        } else {
            PrintWriter out = response.getWriter();
            out.println("<script type=\"text/javascript\">");
            out.println("window.location.replace('register');");
            out.println("alert('Username is taken. Please try another username.');");
            out.println("</script>");
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }
}
