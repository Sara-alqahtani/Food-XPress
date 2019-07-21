package foodxpress;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.*;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Enumeration;

@WebServlet(name = "EditMenuServlet")
@MultipartConfig
@SuppressWarnings("unchecked")          // suppress the unchecked cast warning when casting ArrayList<String>
public class EditMenuServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("WORLDDD");
        HttpSession session = request.getSession();
        GsonBuilder builder = new GsonBuilder();
        Gson gson = builder.serializeNulls().create();

        ArrayList<String> categories = null;
        ArrayList<Food> foods = null;
        try {
            categories = (ArrayList<String>) session.getAttribute("categories");
            foods = (ArrayList<Food>) session.getAttribute("foods");
        } catch (ClassCastException ex){
            ex.printStackTrace();
            return;
        }

        PrintWriter out = response.getWriter();

        if (categories == null) {
            out.println("Something went wrong. Please try again.");
            return;
        }

        request.getParameterMap().forEach((key, value) -> {
            System.out.println(key + ": " + value[0]);
        });

        Enumeration<String> temp = request.getParameterNames();
        System.out.println("ENUM: " + temp);
        while (temp.hasMoreElements()) {
            String paramName = temp.nextElement();
            System.out.println(paramName);
            System.out.println(request.getParameter(paramName));
        }

        String action = request.getParameter("action");
        System.out.println("Action: " + action);
        if (action.equals("add-category")) {
            String newCategory = request.getParameter("new_category");
            if (newCategory != null && !newCategory.isEmpty()
                    && !categories.contains(newCategory)) {         // check for duplicate category
                categories.add(newCategory);
                Collections.sort(categories);
                out.println("{" +
                        "\"index\":" + categories.indexOf(newCategory) + "," +
                        "\"category\": \"" + newCategory + "\"" +
                        "}");
                session.setAttribute("categories", categories);
                return;
            }
        } else if (action.equals("rename-category")) {
            String category = request.getParameter("category");
            String newCategory = request.getParameter("new_category");
            if (category != null && !category.isEmpty()
                    && categories.contains(category)                // check category exists
                    && newCategory != null && !newCategory.isEmpty()
                    && !categories.contains(newCategory)) {         // check for duplicate category
                int prevIndex = categories.indexOf(category);
                categories.set(prevIndex, newCategory);      // replace old with new category
                Collections.sort(categories);                       // sort the category
                foods.forEach((food) -> {
                    if (food.category.equals(category)) {
                        food.category = newCategory;
                    }
                });
                Collections.sort(foods,(o1, o2) -> o1.category.compareTo(o2.category));
                out.println("{" +
                        "\"index\":" + categories.indexOf(newCategory) + "," +
                        "\"category\": \"" + newCategory + "\"," +
                        "\"prevIndex\": " + prevIndex +
                        "}");
                session.setAttribute("categories", categories);
                session.setAttribute("foods", foods);
                return;
            }
        } else if (action.equals("delete-category")) {
            String category = request.getParameter("category");
            if (category != null && !category.isEmpty()
                    && categories.contains(category)) {                // check category exists
                int prevIndex = categories.indexOf(category);
                categories.remove(category);
                foods.removeIf(food -> food.category.equals(category));
                out.println("{" +
                        "\"prevIndex\": " + prevIndex +
                        "}");
                session.setAttribute("categories", categories);
                session.setAttribute("foods", foods);
                return;
            }
        } else if (action.equals("add-food")) {
            System.out.println("HELLLLLLLLO");

            int nextFoodId = (Integer) session.getAttribute("next_food_id");
            int shopId = ((Vendor) session.getAttribute("vendor")).shop_id;

            String category = request.getParameter("category");
            String name = request.getParameter("name");
            Double price = Utils.tryParseDouble(request.getParameter("price"), 2);
            Integer time = Utils.tryParseInt(request.getParameter("time"));
            String description = request.getParameter("description");
            System.out.println("Description: "+ description);

            Part image = request.getPart("image");
            System.out.println("Image: " + image);
            String imageUrl = null;
            if (image.getSize() > 0) {
                System.out.println("Image file has size!!!");
                OutputStream os = null;
                try {
                    InputStream is = image.getInputStream();
                    byte[] data = new byte[10 * 1024 * 1024];               // 10MB file size limit
                    int len = is.read(data);
                    String contentType = image.getContentType();
                    imageUrl = nextFoodId + "." + contentType.substring(contentType.indexOf('/') + 1);
                    String path = getServletContext().getRealPath("./images/foods") + "\\" + shopId;
                    System.out.println(path);
                    if (Files.notExists(Paths.get(path))) {
                        new File(path).mkdirs();
                    }
                    path += "\\" + imageUrl;
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
            System.out.println("Reached HERRREERERERER");
            if (category != null && name != null
                    && price != null && time != null
                    && imageUrl != null) {
                System.out.println("NO NULL PARAMETER");
                Food food = new Food(nextFoodId, name, category, shopId,
                        price, time, imageUrl, description, 5.0);
                foods.add(food);
                System.out.println("Created food object");
                Collections.sort(foods,(o1, o2) -> o1.category.compareTo(o2.category));
                int index_in_category = 0;
                for (Food f : foods) {
                    if (f.category.equals(food.category)) {
                        if (f.equals(food)) break;
                        index_in_category++;
                    }
                }
                System.out.println("sorted");
                out.println("{" +
                        "\"category_index\": " + categories.indexOf(food.category) + "," +
                        "\"index_in_category\": " + index_in_category + "," +
                        "\"food\": " + gson.toJson(food) +
                        "}");
                System.out.println("returned response");
                session.setAttribute("foods", foods);
                session.setAttribute("next_food_id", ++nextFoodId);
                System.out.println("attribute set");
                return;
            }
        } else if (action.equals("modify-food")) {

            int shopId = ((Vendor) session.getAttribute("vendor")).shop_id;
            Integer foodId = Utils.tryParseInt(request.getParameter("food_id"));
            String category = request.getParameter("category");
            String name = request.getParameter("name");
            Double price = Utils.tryParseDouble(request.getParameter("price"), 2);
            Integer time = Utils.tryParseInt(request.getParameter("time"));
            String description = request.getParameter("description");

            Part image = request.getPart("image");
            System.out.println("Image: " + image);
            String imageUrl = null;
            String contentType = image.getContentType();
            if (image.getSize() > 0 && contentType != null) {
                System.out.println("Image file has size!!!");
                OutputStream os = null;
                try {
                    InputStream is = image.getInputStream();
                    byte[] data = new byte[10 * 1024 * 1024];               // 10MB file size limit
                    int len = is.read(data);
                    imageUrl = foodId + "." + contentType.substring(contentType.indexOf('/') + 1);
                    String path = getServletContext().getRealPath("./images/foods") + "\\" + shopId;
                    System.out.println(path);
                    if (Files.notExists(Paths.get(path))) {
                        new File(path).mkdirs();
                    }
                    path += "\\" + imageUrl;
                    System.out.println(path);
                    os = new FileOutputStream(path);
                    os.write(data, 0, len);
                } catch (IOException | NullPointerException e) {
                    e.printStackTrace();
                    imageUrl = null;
                } finally {
                    if (os != null) {
                        os.close();
                    }
                }
            }
            System.out.println("Reached HERRREERERERER");
            if (foodId != null && category != null && name != null
                    && price != null && time != null
                    && description != null) {
                System.out.println("NO NULL PARAMETER");
                Food modifiedFood = null;
                int prevIndex = -1;
                for (int i = 0; i < foods.size(); i++) {
                    Food f = foods.get(i);
                    if (f.id == foodId) {
                        prevIndex = i;
                        f.name = name;
                        f.category = category;
                        f.price = price;
                        f.prepare_time = time;
                        if (imageUrl != null) {
                            f.image_url = imageUrl;
                        }
                        f.description = description;
                        modifiedFood = f;
                        break;
                    }
                }
                if (modifiedFood == null) {
                    response.setStatus(400);
                    out.println("Invalid food id");
                    return;
                }
                Collections.sort(foods,(o1, o2) -> o1.category.compareTo(o2.category));
                int index_in_category = 0;
                for (Food f : foods) {
                    if (f.category.equals(modifiedFood.category)) {
                        if (f.equals(modifiedFood)) break;
                        index_in_category++;
                    }
                }
                System.out.println("sorted");
                out.println("{" +
                        "\"prev_index\": " + prevIndex + "," +
                        "\"category_index\": " + categories.indexOf(modifiedFood.category) + "," +
                        "\"index_in_category\": " + index_in_category + "," +
                        "\"food\": " + gson.toJson(modifiedFood) +
                        "}");
                System.out.println("returned response");
                session.setAttribute("foods", foods);
                System.out.println("attribute set");
                return;
            }
        } else if (action.equals("delete-food")) {
            Integer food_id = Utils.tryParseInt(request.getParameter("food_id"));
            if (food_id != null) {
                int prevIndex = -1;
                for (int i = 0; i < foods.size(); i++) {
                    if (foods.get(i).id == food_id) {
                        prevIndex = i;
                        break;
                    }
                }
                foods.remove(prevIndex);
                out.println("{" +
                        "\"prev_index\": " + prevIndex +
                        "}");
                session.setAttribute("foods", foods);
                return;
            }
        } else if (action.equals("discard")) {
            //TODO delete food image
            session.removeAttribute("categories");
            session.removeAttribute("foods");
            session.removeAttribute("next_food_id");
            out.println("view-menu");
            return;
        } else if (action.equals("confirm")) {
            int nextFoodId = (Integer) session.getAttribute("next_food_id");
            int shopId = ((Vendor) session.getAttribute("vendor")).shop_id;
            SQLProvider provider = new SQLProvider();
            Repository repository = new Repository(provider);
            boolean isSuccess = repository.updateMenu(shopId, categories, foods, nextFoodId);
            if (isSuccess) {
                session.removeAttribute("categories");
                session.removeAttribute("foods");
                session.removeAttribute("next_food_id");
                out.println("view-menu");
                return;
            }
        }
        response.setStatus(400);                    // return 400 Bad Request to client
        out.println("Invalid action.");
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }
}
