package foodxpress;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.*;
import java.sql.Time;
import java.text.ParseException;
import java.text.SimpleDateFormat;

@WebServlet(name = "VendorUpdateProfileServlet")
@MultipartConfig
public class VendorUpdateProfileServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Vendor vendor= (Vendor) session.getAttribute("vendor");
        SQLProvider provider = new SQLProvider();
        Repository repository = new Repository(provider);
        Shop shop = repository.getShopInfo(vendor.shop_id);

        ShopLocation location = Utils.tryParseEnum(ShopLocation.class, request.getParameter("location"));
        Part image = request.getPart("image");
        String description = request.getParameter("description");
        System.out.println(request.getParameter("operation_start_time"));
        Time start = Utils.tryParseTime(request.getParameter("operation_start_time"));
        Time end = Utils.tryParseTime(request.getParameter("operation_end_time"));
        Integer deliveryTime = Integer.valueOf(request.getParameter("deliveryTime"));
        Double deliveryFee = Double.valueOf(request.getParameter("deliveryFee"));


        String imageUrl = null;
        if (image.getSize() > 0) {
            OutputStream os = null;
            try {
                InputStream is = image.getInputStream();
                byte[] data = new byte[10 * 1024 * 1024];               // 10MB file size limit
                int len = is.read(data);
                String contentType = image.getContentType();
                imageUrl = shop.name + "." + contentType.substring(contentType.indexOf('/')+1);
                String path = getServletContext().getRealPath("./images/shop-image") + "\\" + imageUrl;
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

        SQLProvider update_provider = new SQLProvider();
        Repository update_repository = new Repository(update_provider);

        if (image != null && location != null && description != null && start != null && end != null && deliveryFee != null
            && deliveryTime != null ) {
            boolean isSuccess;
            if (imageUrl != null) {
                isSuccess = update_repository.updateShopInfo(shop.name, location,imageUrl,description,start.toString(),end.toString(),deliveryTime,deliveryFee);
            } else {
                isSuccess = update_repository.updateShopInfo(shop.name, location,shop.image_url,description,start.toString(),end.toString(),deliveryTime,deliveryFee);
            }

            if (isSuccess) {
                shop.location=location;
                shop.image_url = imageUrl;
                shop.description = description;
                shop.operation_start_time = start;
                shop.operation_end_time = end;
                shop.delivery_time = deliveryTime;
                shop.delivery_fee = deliveryFee;

                response.sendRedirect("shop-profile");
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
