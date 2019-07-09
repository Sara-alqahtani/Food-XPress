package foodxpress;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement(name="cart_item")
public class CartItem {
    @XmlElement
    public int id;
    @XmlElement
    public int quantity;
    @XmlElement
    public String remark;
}
