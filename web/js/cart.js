var cartTable;
var cartHeader;
var cartFooter;
var cartSubtotal;
var cartDeliveryFee;
var cartTotal;

function populateTable(cart) {
    var items = '';
    var subtotal = 0;
    Object.keys(cart.foods).forEach(function (key) {
        items += createOrderItem(key, cart.foods[key].name, cart.foods[key].quantity, cart.foods[key].price, cart.foods[key].remark);
        subtotal += cart.foods[key].quantity * cart.foods[key].price;
    });
    cartSubtotal.textContent = subtotal.toFixed(2);
    cartTotal.textContent = (subtotal + parseFloat(cartDeliveryFee.textContent)).toFixed(2);
    cartTable.innerHTML = cartHeader.outerHTML + items + cartFooter.outerHTML;

    var incrementItem = function() {
        var id = this.getAttribute('data-food_id');
        cart.foods[id].quantity++;
        sessionStorage.setItem('cart', JSON.stringify(cart));
        populateTable(cart);
    };

    var decrementItem = function() {
        var id = this.getAttribute('data-food_id');
        cart.foods[id].quantity--;
        if (cart.foods[id].quantity === 0) {
            delete cart.foods[id];
        }
        sessionStorage.setItem('cart', JSON.stringify(cart));
        populateTable(cart);
    };

    var removeItem = function() {
        var id = this.getAttribute('data-food_id');
        delete cart.foods[id];
        sessionStorage.setItem('cart', JSON.stringify(cart));
        populateTable(cart);
    };
    var buttons = cartTable.getElementsByClassName('btn-order-delete');
    var len = buttons.length;
    // register onclick listeners for each item remove button
    var i;
    for (i = 0; i < len; i++) {
        buttons[i].onclick = removeItem;
    }
    buttons = cartTable.getElementsByClassName('quantity-control');
    len = buttons.length;
    for (i = 0; i < len; i+=2) {
        buttons[i].onclick = decrementItem;
        buttons[i+1].onclick = incrementItem;
    }
}

function createOrderItem(id, name, quantity, unitPrice, remark) {
    var item  = '' +
        '<tbody class="cart-order">' +
        '<tr class="cart-order-item">' +
        '<td>' +
        name +
        '</td>' +
        '<td><button class="quantity-control" data-food_id="' +
        id +
        '"><i class="fas fa-minus-circle"></i></button>' +
        quantity +
        '<button class="quantity-control" data-food_id="' +
        id +
        '"><i class="fas fa-plus-circle"></i></button></td>' +
        '<td>' +
        (quantity * unitPrice).toFixed(2) +
        '</td>' +
        '<td><button type="button" class="btn-order-delete" data-food_id="' +
        id +
        '">' +
        '<i class="fas fa-trash-alt"></i>' +
        '</button></td>' +
        '</tr>' +
        '<tr class="cart-order-remark">' +
        '<td colspan="3">';
    if (remark.length > 0) {
        item +=
            '<i class="fas fa-angle-right"></i>' +
            '<span>' +
            remark +
            '</span>';
    }
    item +=
        '</td>' +
        '<td></td>' +
        '</tr>' +
        '</tbody>';
    return item;
}

window.addEventListener('load', function() {
    cartTable = document.getElementsByClassName('cart-order-table')[0];
    cartHeader = document.getElementById('js-cart-order-table-header');
    cartFooter = document.getElementById('js-cart-order-table-footer');
    cartSubtotal = document.getElementById('js-cart-subtotal');
    cartDeliveryFee = document.getElementById('js-cart-delivery_fee');
    cartTotal = document.getElementById('js-cart-total');

    var foodButtons = document.getElementsByClassName('js-food-pop-up-btn');
    var foodPopUp = document.getElementById('js-food-pop-up');
    var closeButton = document.getElementById('js-food-pop-up-close-btn');
    var addButton = document.getElementById('js-add-order-item-btn');
    var incrementBtn = document.getElementById('js-add-qty-btn');
    var decrementBtn = document.getElementById('js-minus-qty-btn');
    var quantityInput = document.getElementById('js-quantity-input');
    var checkoutBtn = document.getElementById('js-checkout-btn');

    var title = foodPopUp.getElementsByClassName('box-title')[0];
    var price = foodPopUp.getElementsByClassName('box-info')[0];
    var time = foodPopUp.getElementsByClassName('box-info')[1];
    var rating = foodPopUp.getElementsByClassName('box-info')[2];
    var description = foodPopUp.getElementsByClassName('box-description')[0];
    var remark = foodPopUp.getElementsByClassName('review-text-area')[0];
    var shopId = foodPopUp.getAttribute('data-shop_id');

    // get cart from session
    var cart = JSON.parse(sessionStorage.getItem('cart'));
    console.log('previous: ' + JSON.stringify(cart));
    // create new cart if cart does not exists or different shop
    cart = (cart && cart.shop_id === shopId) ? cart : {
        shop_id: shopId,
        foods: {}
    };
    console.log('current: ' + JSON.stringify(cart));

    populateTable(cart);

    var popup = function() {
        foodPopUp.setAttribute('data-food_id', this.getAttribute('data-food_id'));
        title.innerHTML = this.getElementsByClassName('box-title')[0].innerHTML;
        price.innerHTML = this.getElementsByClassName('box-info')[0].innerHTML;
        time.innerHTML = this.getElementsByClassName('box-info')[1].innerHTML;
        rating.innerHTML = this.getElementsByClassName('box-info')[2].innerHTML;
        var foodDescription = this.getElementsByClassName('box-description')[0];
        var descriptionText;
        if (foodDescription) {
            descriptionText = foodDescription.textContent;
        }
        if (foodDescription && descriptionText.length > 0) {
            description.style.display = 'block';
            description.textContent = descriptionText;
        } else {
            description.style.display = 'none';
        }
        remark.style = '';
        remark.value = '';
        foodPopUp.style.display = 'flex';
        quantityInput.value = 1;
    };

    // register onclick listeners for each food button
    var len = foodButtons.length;
    for (var i = 0; i < len; i++) {
        foodButtons[i].onclick = popup;
    }

    incrementBtn.onclick = function() {
        var num = parseInt(quantityInput.value);
        if (isNaN(num) || num <= 0) {
            quantityInput.value = 1;
        } else {
            quantityInput.value = num + 1;
        }
    };

    decrementBtn.onclick = function() {
        var num = parseInt(quantityInput.value);
        if (isNaN(num) || num <= 1) {
            quantityInput.value = 1;
        } else {
            quantityInput.value = num - 1;
        }
    };

    addButton.onclick = function() {
        var num = parseInt(quantityInput.value);
        if (isNaN(num) || num < 1) {
            alert('Quantity must be at least 1.');
            return;
        }
        var id = foodPopUp.getAttribute('data-food_id');
        if (!cart.foods[id]) {
            cart.foods[id] = {
                name: title.textContent,
                quantity: num,
                price: parseFloat(price.textContent.substr(2)),
                remark: remark.value
            };
        } else {
            cart.foods[id].quantity += num;
            cart.foods[id].remark = remark.value;
        }
        sessionStorage.setItem('cart', JSON.stringify(cart));
        populateTable(cart);
        foodPopUp.style.display = 'none';
    };

    closeButton.onclick = function() {
        foodPopUp.style.display = 'none';
    };

    foodPopUp.onclick = function(event) {
        if (event.target === foodPopUp) {
            foodPopUp.style.display = 'none';
        }
    };

    checkoutBtn.onclick = function () {
        var xhttp = new XMLHttpRequest();
        xhttp.open('POST', 'cart-servlet', true);
        xhttp.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
        xhttp.onreadystatechange = function() {
            if (this.readyState === 4 && this.status === 200) {
                if (this.responseText) {
                    window.location.href = this.responseText;
                }
            } else if (this.readyState === 4 && this.status === 400) {
                if (this.responseText) {
                    alert(this.responseText);
                }
            }
        };

        var xml = '<cart>';
        xml += '<shop_id>' + cart.shop_id + '</shop_id>';
        xml += '<cart_item_list>';
        Object.keys(cart.foods).forEach(function (key) {
            xml += '<cart_item>';
            xml += '<id>' + key + '</id>';
            xml += '<quantity>' + cart.foods[key].quantity + '</quantity>';
            xml += '<remark>' + cart.foods[key].remark + '</remark>';
            xml += '</cart_item>';
        });
        xml += '</cart_item_list>';
        xml += '</cart>';
        xhttp.send('cart=' + xml);
    };
});