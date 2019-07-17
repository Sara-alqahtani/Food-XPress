

window.addEventListener('load', function () {
    var foodButtons = document.getElementsByClassName('js-food-pop-up-btn');
    var foodPopUp = document.getElementById('js-food-pop-up');
    var closeButton = document.getElementById('js-food-pop-up-close-btn');

    var title = foodPopUp.getElementsByClassName('box-title')[0];
    var price = foodPopUp.getElementsByClassName('box-info')[0];
    var time = foodPopUp.getElementsByClassName('box-info')[1];
    var rating = foodPopUp.getElementsByClassName('box-info')[2];
    var description = foodPopUp.getElementsByClassName('review-text-area')[0];
    var shopId = foodPopUp.getAttribute('data-shop_id');

    var popup = function() {
        var menuItem = this.closest('.js-edit-menu-item');
        foodPopUp.setAttribute('data-food_id', this.getAttribute('data-food_id'));
        title.innerHTML = menuItem.getElementsByClassName('box-title')[0].innerHTML;
        price.innerHTML = menuItem.getElementsByClassName('box-info')[0].innerHTML;
        time.innerHTML = menuItem.getElementsByClassName('box-info')[1].innerHTML;
        rating.innerHTML = menuItem.getElementsByClassName('box-info')[2].innerHTML;
        description.value = menuItem.getElementsByClassName('box-description')[0].textContent;
        description.style = '';
        foodPopUp.style.display = 'flex';
    };

    // register onclick listeners for each food button
    var len = foodButtons.length;
    for (var i = 0; i < len; i++) {
        foodButtons[i].onclick = popup;
    }

    closeButton.onclick = function() {
        foodPopUp.style.display = 'none';
    };

    foodPopUp.onclick = function(event) {
        if (event.target === foodPopUp) {
            foodPopUp.style.display = 'none';
        }
    };
});