package foodxpress;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.*;

@WebServlet(name = "UpdateProfileServlet")
@MultipartConfig
public class UpdateProfileServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        String mobile = request.getParameter("mobile").replace("\'", "");
        PickUpLocation location = Utils.tryParseEnum(PickUpLocation.class, request.getParameter("location"));
        Part image = request.getPart("image");
        Boolean removeImage = Boolean.parseBoolean(request.getParameter("remove-image"));

        String imageUrl = null;
        if (image.getSize() > 0) {
            OutputStream os = null;
            try {
                InputStream is = image.getInputStream();
                byte[] data = new byte[10 * 1024 * 1024];               // 10MB file size limit
                int len = is.read(data);
                String contentType = image.getContentType();
                imageUrl = user.username + "." + contentType.substring(contentType.indexOf('/')+1);
                String path = getServletContext().getRealPath("./images/user-profile") + "\\" + imageUrl;
                System.out.println(path);
                os = new FileOutputStream(path);
                os.write(data, 0, len);
            } catch (IOException e) {
                e.printStackTrace();
                imageUrl = null;
            } finally {
                if (os != null) {
                    os.close();
                }
            }
        }

        SQLProvider provider = new SQLProvider();
        Repository repository = new Repository(provider);

        String defaultImageUrl = "default.png";

        if (mobile != null && !mobile.isEmpty() && location != null) {
            boolean isSuccess;
            if (removeImage) {
                isSuccess = repository.updateUserInfo(user.username, mobile, location, defaultImageUrl);
            } else if (imageUrl != null) {
                isSuccess = repository.updateUserInfo(user.username, mobile, location, imageUrl);
            } else {
                isSuccess = repository.updateUserInfo(user.username, mobile, location, user.image_url);
            }

            if (isSuccess) {
                user.mobile = mobile;
                user.location = location;
                if (removeImage) {
                    user.image_url = defaultImageUrl;
                } else if (imageUrl != null) {
                    user.image_url = imageUrl;
                }
                response.sendRedirect("view-profile");
                return;
            }
        }
        PrintWriter out = response.getWriter();
        out.println("Error in updating profile.");
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }
}
