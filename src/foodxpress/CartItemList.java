package foodxpress;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;
import java.util.ArrayList;
import java.util.List;

@XmlRootElement(name="cart_item_list")
public class CartItemList {
    @XmlElement(name="cart_item")
    public List<CartItem> cartItems = new ArrayList<>();
}
