

window.addEventListener('load', function () {
    var categoryButtons = document.getElementsByClassName('js-category-pop-up-btn');
    var categoryPopUp = document.getElementById('js-category-pop-up');
    var categoryCloseButton = document.getElementById('js-category-pop-up-close-btn');
    var foodButtons = document.getElementsByClassName('js-food-pop-up-btn');
    var foodPopUp = document.getElementById('js-food-pop-up');
    var closeButton = document.getElementById('js-food-pop-up-close-btn');

    var newCategoryButtons = document.getElementsByClassName('js-new-category-btn');
    var newItemButtons = document.getElementsByClassName('js-new-item-btn');

    var categoryName = document.getElementById('js-category-name');

    var image = document.getElementById('js-pop-up-picture');
    var imageInput = document.getElementById('js-upload-image');
    var category = document.getElementById('food-category');
    var title = document.getElementById('food-name');
    var price = document.getElementById('food-price');
    var time = document.getElementById('preparation-time');
    var description = foodPopUp.getElementsByClassName('review-text-area')[0];
    var shopId = foodPopUp.getAttribute('data-shop_id');

    var popupCategory = function () {
        var dataCategory = this.getAttribute('data-category');
        categoryPopUp.setAttribute('data-category', dataCategory);
        categoryName.value = dataCategory;
      categoryPopUp.style.display = 'flex';
    };

    var len = categoryButtons.length;
    var i = 0;
    for (i = 0; i < len; i++) {
        categoryButtons[i].onclick = popupCategory;
    }

    var popup = function() {
        var menuItem = this.closest('.js-edit-menu-item');
        foodPopUp.setAttribute('data-food_id', this.getAttribute('data-food_id'));
        imageInput.value = '';
        image.src = menuItem.getElementsByClassName('box-picture')[0].src;
        category.value = this.getAttribute('data-category');
        title.value = menuItem.getElementsByClassName('box-title')[0].textContent;
        price.value = menuItem.getElementsByClassName('box-info')[0].textContent.substr(3);
        var timeText = menuItem.getElementsByClassName('box-info')[1].textContent.trim();
        time.value = timeText.substr(0, timeText.length - 3);
        description.value = menuItem.getElementsByClassName('box-description')[0].textContent;
        description.style = '';
        foodPopUp.style.display = 'flex';
    };

    // register onclick listeners for each food button
    len = foodButtons.length;
    for (i = 0; i < len; i++) {
        foodButtons[i].onclick = popup;
    }

    var newCategory = function() {
        categoryPopUp.removeAttribute('data-category');
        categoryName.value = '';
        categoryPopUp.style.display = 'flex';
    };

    len = newCategoryButtons.length;
    for (i = 0; i < len; i++) {
        newCategoryButtons[i].onclick = newCategory;
    }

    var newItem = function() {
        foodPopUp.removeAttribute('data-food_id');
        image.src = 'images/default-food.svg';
        category.value = '';
        title.value = '';
        price.value = '';
        time.value = '';
        description.value = '';
        foodPopUp.style.display = 'flex';
    };

    len = newItemButtons.length;
    for (i = 0; i < len; i++) {
        newItemButtons[i].onclick = newItem;
    }

    categoryCloseButton.onclick = function() {
      categoryPopUp.style.display = 'none';
    };

    closeButton.onclick = function() {
        foodPopUp.style.display = 'none';
    };

    categoryPopUp.onclick = function(event) {
        if (event.target === categoryPopUp) {
            categoryPopUp.style.display = 'none';
        }
    };

    foodPopUp.onclick = function(event) {
        if (event.target === foodPopUp) {
            foodPopUp.style.display = 'none';
        }
    };

    imageInput.onchange = function(event) {
        var reader = new FileReader();
        reader.onload = function(){
            image.src = reader.result;
        };
        reader.readAsDataURL(event.target.files[0]);
    };
});