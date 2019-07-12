package foodxpress;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement(name="cart")
public class Cart {
    @XmlElement
    public int shop_id;
    @XmlElement(name="cart_item_list")
    public CartItemList itemList;
}
