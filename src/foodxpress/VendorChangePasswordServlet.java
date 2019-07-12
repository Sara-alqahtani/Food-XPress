package foodxpress;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet(name = "foodxpress.VendorChangePasswordServlet")
public class VendorChangePasswordServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Vendor vendor = (Vendor) session.getAttribute("vendor");

        String vendorId = vendor.id;
        String oldPassword = request.getParameter("current-password").replace("\'", "");
        String newPassword = request.getParameter("new-password").replace("\'", "");
        String confirmPassword = request.getParameter("confirm-password").replace("\'", "");

        if (!newPassword.equals(confirmPassword)){
            PrintWriter out = response.getWriter();
            out.println("The new password is different from the confirmed password. Please confirm your password.");
            return;
        }

        SQLProvider provider = new SQLProvider();
        Repository repository = new Repository(provider);
        boolean isSuccess = repository.vendorChangePassword(vendorId, oldPassword, newPassword);

        if (isSuccess){
            response.sendRedirect("vendor-home");
        }else {
            PrintWriter out = response.getWriter();
            out.println("Error in changing password.");
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }
}
