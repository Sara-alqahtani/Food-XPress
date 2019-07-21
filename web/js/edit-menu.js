var sidebar;
var list;

var categoryPopUp;
var categoryConfirmBtn;
var categoryName;
var categorySelect;

var foodPopUp;
var foodConfirmBtn;

var image;
var imageInput;
var title;
var price;
var time;
var description;

function ajaxCallFormData(formData, callback) {
    var xhttp = new XMLHttpRequest();
    xhttp.open('POST', 'edit-menu-servlet', true);
    // xhttp.setRequestHeader('Content-type', 'multipart/form-data');
    xhttp.onreadystatechange = function() {
        if (this.readyState === 4 && this.status === 200) {
            if (this.responseText) {
                callback(this.responseText);
            }
        } else if (this.readyState === 4 && this.status === 400) {
            if (this.responseText) {
                alert(this.responseText);
            }
        }
    };
    xhttp.send(formData);
}

function ajaxCall(parameter, callback) {
    var xhttp = new XMLHttpRequest();
    xhttp.open('POST', 'edit-menu-servlet', true);
    xhttp.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
    xhttp.onreadystatechange = function() {
        if (this.readyState === 4 && this.status === 200) {
            if (this.responseText) {
                callback(this.responseText);
            }
        } else if (this.readyState === 4 && this.status === 400) {
            if (this.responseText) {
                alert(this.responseText);
            }
        }
    };
    xhttp.send(parameter);
}

function insertCategoryInSidebar(cat, index) {
    var res = '<li><a href="#category-' + cat + '">' + cat + '</a></li>';
    if (index === 0) {
        sidebar.insertAdjacentHTML('afterbegin', res);
    } else {
        sidebar.children[index - 1].insertAdjacentHTML('afterend', res);
    }
}

function insertCategoryInMenuList(cat, index) {
    var res = '<div class="box-list">' +
        '<div class="box-list-title hover-hidden-parent l-stack" id="category-' + cat + '">' +
        '<h5>' + cat + '</h5>' +
        '<span class="l-row-group-sm hover-hidden-child edit-menu-category-bar">' +
        '<i class="fas fa-edit js-category-pop-up-btn" data-category="' + cat + '"></i>' +
        '<i class="fas fa-trash-alt js-category-delete-btn" data-category="' + cat + '"></i>' +
        '</span>' +
        '</div>' +
        '</div>';
    console.log(res);
    list.children[index].insertAdjacentHTML('afterend', res);
}

function insertCategoryInSelect(cat, index) {
    var res ='<option value="' + cat + '">' + cat + '</option>';
    if (index === 0) {
        categorySelect.insertAdjacentHTML('afterbegin', res);
    } else {
        categorySelect.children[index - 1].insertAdjacentHTML('afterend', res);
    }
}

function replaceCategoryInSidebar(cat, index, prevIndex) {
    var res = '<li><a href="#category-' + cat + '">' + cat + '</a></li>';
    sidebar.removeChild(sidebar.children[prevIndex]);
    if (index === 0) {
        sidebar.insertAdjacentHTML('afterbegin', res);
    } else {
        sidebar.children[index - 1].insertAdjacentHTML('afterend', res);
    }
}

function replaceCategoryInMenuList(cat, index, prevIndex) {
    var res = '<div class="box-list-title hover-hidden-parent l-stack" id="category-' + cat + '">' +
        '<h5>' + cat + '</h5>' +
        '<span class="l-row-group-sm hover-hidden-child edit-menu-category-bar">' +
        '<i class="fas fa-edit js-category-pop-up-btn" data-category="' + cat + '"></i>' +
        '<i class="fas fa-trash-alt js-category-delete-btn" data-category="' + cat + '"></i>' +
        '</span>' +
        '</div>';
    // console.log(list.children[prevIndex+1].children[0].outerHTML);
    var children = list.children;
    children[prevIndex+1].children[0].outerHTML = res;
    var btns = children[prevIndex+1].getElementsByClassName('js-food-pop-up-btn');
    var len = btns.length;
    for (var i = 0; i < len; i++) {
        btns[i].setAttribute('data-category', cat);
    }
    // console.log(list.children[prevIndex+1].children[0].outerHTML);
    if (prevIndex > index) {
        list.insertBefore(children[prevIndex+1], children[index].nextSibling);            // insert after
    } else {
        list.insertBefore(children[prevIndex+1], children[index+1].nextSibling);            // insert after
    }
}

function replaceCategoryInSelect(cat, index, prevIndex) {
    var res ='<option value="' + cat + '">' + cat + '</option>';
    categorySelect.removeChild(categorySelect.children[prevIndex]);
    if (index === 0) {
        categorySelect.insertAdjacentHTML('afterbegin', res);
    } else {
        categorySelect.children[index - 1].insertAdjacentHTML('afterend', res);
    }
}

function generateRatingStars(rating) {
    var res = '';
    rating = Math.round( rating * 10) / 10;
    var fullStar = Math.round(rating);
    var halfStarExist = (rating - fullStar) > 0;
    var emptyStar = 5 - fullStar;
    if (halfStarExist) {
        emptyStar--;
    }
    var i;
    for (i = 0; i < fullStar; i++) {
        res += ' <i class="fas fa-star"></i> ';
    }
    if (halfStarExist) {
        res += ' <i class="fas fa-star-half-alt"></i> ';
    }
    for (i = 0; i < emptyStar; i++) {
        res += ' <i class="far fa-star"></i> ';
    }
    console.log(res);
    return res;
}

function insertFoodInMenuList(food, category_index, index_in_category) {
    var res = '<div class="card box js-edit-menu-item hover-hidden-parent l-stack">' +
        '<span class="l-row-group-sm hover-hidden-child edit-menu-food-bar">' +
        '<i class="fas fa-edit js-food-pop-up-btn" data-food_id="'+ food.id + '" data-category="' + food.category + '"></i>' +
        '<i class="fas fa-trash-alt js-food-delete-btn" data-food_id="' + food.id + '"></i>' +
        '</span>' +
        '<img src="images/foods/' + food.shop_id + '/' + food.image_url + '" class="box-picture" alt="food image">' +
        '<div class="box-content">' +
        '<div class="box-detail">' +
        '<div class="box-title">' + food.name + '</div>' +
        '<div>' +
        '<span class="box-info">RM ' + food.price.toFixed(2) + '</span>' +
        ' <span class="box-info">' +
        ' <i class="fas fa-hourglass-half"></i> ' +
        food.prepare_time + 'min' +
        '</span> ' +
        '<span class="box-info">' +
        '<span class="rating-star">' +
        generateRatingStars(food.rating) +        // rating stars
        '</span>' +
        food.rating.toFixed(1) +
        '</span>' +
        '</div>' +
        '</div>' +
        '<p class="box-description">';
        if (food.description && food.description.trim().length > 0) {
            res += food.description.trim()
        }
        res += '</p>' +
        '</div>' +
        '</div>';
    console.log(res);
    list.children[category_index + 1].children[index_in_category].insertAdjacentHTML('afterend', res);

    var yourElement = list.children[category_index + 1].children[index_in_category+1];
    var yCoordinate = yourElement.getBoundingClientRect().top + window.pageYOffset;
    var yOffset = yourElement.getBoundingClientRect().height;

    window.scrollTo({
        top: yCoordinate - yOffset, // minus to scroll up
        behavior: 'smooth'
    });
}

function replaceFoodInMenuList(food, prev_index, category_index, index_in_category) {
    var foodList = document.getElementsByClassName('js-edit-menu-item');
    foodList[prev_index].remove();

    var res = '<div class="card box js-edit-menu-item hover-hidden-parent l-stack">' +
        '<span class="l-row-group-sm hover-hidden-child edit-menu-food-bar">' +
        '<i class="fas fa-edit js-food-pop-up-btn" data-food_id="'+ food.id + '" data-category="' + food.category + '"></i>' +
        '<i class="fas fa-trash-alt js-food-delete-btn" data-food_id="' + food.id + '"></i>' +
        '</span>' +
        '<img src="images/foods/' + food.shop_id + '/' + food.image_url + '?' + (new Date).getTime() + '" class="box-picture" alt="food image">' +
        '<div class="box-content">' +
        '<div class="box-detail">' +
        '<div class="box-title">' + food.name + '</div>' +
        '<div>' +
        '<span class="box-info">RM ' + food.price.toFixed(2) + '</span>' +
        ' <span class="box-info">' +
        ' <i class="fas fa-hourglass-half"></i> ' +
        food.prepare_time + 'min' +
        '</span> ' +
        '<span class="box-info">' +
        '<span class="rating-star">' +
        generateRatingStars(food.rating) +        // rating stars
        '</span>' +
        food.rating.toFixed(1) +
        '</span>' +
        '</div>' +
        '</div>' +
        '<p class="box-description">' + food.description + '</p>' +
        '</div>' +
        '</div>';
    console.log(res);
    list.children[category_index + 1].children[index_in_category].insertAdjacentHTML('afterend', res);

    var yourElement = list.children[category_index + 1].children[index_in_category+1];
    var yCoordinate = yourElement.getBoundingClientRect().top + window.pageYOffset;
    var yOffset = yourElement.getBoundingClientRect().height;

    window.scrollTo({
        top: yCoordinate - yOffset, // minus to scroll up
        behavior: 'smooth'
    });
}

window.addEventListener('click', function(ev) {
    // pop up on click for category bar
    if (ev.target.className.includes('js-category-pop-up-btn')) {
        var dataCategory = ev.target.getAttribute('data-category');
        categoryConfirmBtn.setAttribute('data-category', dataCategory);
        categoryName.value = dataCategory;
        categoryPopUp.style.display = 'flex';
        categoryName.focus();
    }
    // delete on click for category bar
    if (ev.target.className.includes('js-category-delete-btn')) {
        if (!confirm("Confirm delete category? All foods in the category will also be deleted.")) {
            return;
        }
        var dataCategory = ev.target.getAttribute('data-category');
        ajaxCall('action=delete-category&category=' + dataCategory,
            function (response) {
                var data = JSON.parse(response);
                var prevIndex = data.prevIndex;
                sidebar.removeChild(sidebar.children[prevIndex]);
                list.removeChild(list.children[prevIndex+1]);
                categorySelect.removeChild(categorySelect.children[prevIndex]);
                window.scrollTo(window.scrollX, window.scrollY - 1);
                window.scrollTo(window.scrollX, window.scrollY + 1);
            });
    }

    // pop up on click for food item
    if (ev.target.className.includes('js-food-pop-up-btn')) {
        var menuItem = ev.target.closest('.js-edit-menu-item');
        // foodPopUp.setAttribute('data-food_id', this.getAttribute('data-food_id'));
        foodConfirmBtn.setAttribute('data-food_id', ev.target.getAttribute('data-food_id'));
        imageInput.value = '';
        image.src = menuItem.getElementsByClassName('box-picture')[0].src;
        categorySelect.value = ev.target.getAttribute('data-category');
        title.value = menuItem.getElementsByClassName('box-title')[0].textContent;
        price.value = menuItem.getElementsByClassName('box-info')[0].textContent.substr(3);
        var timeText = menuItem.getElementsByClassName('box-info')[1].textContent.trim();
        time.value = timeText.substr(0, timeText.length - 3);
        description.value = menuItem.getElementsByClassName('box-description')[0].textContent;
        description.style = '';
        foodPopUp.style.display = 'flex';
    }

    // delete on click for food item
    if (ev.target.className.includes('js-food-delete-btn')) {
        if (!confirm("Confirm delete food?")) {
            return;
        }
        var foodId = ev.target.getAttribute('data-food_id');
        ajaxCall('action=delete-food&food_id=' + foodId,
            function (response) {
                var data = JSON.parse(response);
                var prevIndex = data.prev_index;
                var foodList = document.getElementsByClassName('js-edit-menu-item');
                foodList[prevIndex].remove();
                window.scrollTo(window.scrollX, window.scrollY - 1);
                window.scrollTo(window.scrollX, window.scrollY + 1);
            });

    }
});

window.addEventListener('load', function () {
    sidebar = document.getElementsByClassName('sidebar-content')[0];
    list = document.getElementsByClassName('rest-box')[0];

    categoryPopUp = document.getElementById('js-category-pop-up');
    categoryConfirmBtn = document.getElementById('js-category-confirm-btn');
    var categoryCloseButton = document.getElementById('js-category-pop-up-close-btn');

    var foodButtons = document.getElementsByClassName('js-food-pop-up-btn');
    foodPopUp = document.getElementById('js-food-pop-up');
    foodConfirmBtn = document.getElementById('js-food-confirm-btn');
    var closeButton = document.getElementById('js-food-pop-up-close-btn');

    var newCategoryButtons = document.getElementsByClassName('js-new-category-btn');
    var newItemButtons = document.getElementsByClassName('js-new-item-btn');
    var discardButtons = document.getElementsByClassName('js-discard-btn');
    var confirmButtons = document.getElementsByClassName('js-confirm-btn');

    categoryName = document.getElementById('js-category-name');

    image = document.getElementById('js-pop-up-picture');
    imageInput = document.getElementById('js-upload-image');
    categorySelect = document.getElementById('food-category');
    title = document.getElementById('food-name');
    price = document.getElementById('food-price');
    time = document.getElementById('preparation-time');
    description = foodPopUp.getElementsByClassName('review-text-area')[0];
    // var shopId = foodPopUp.getAttribute('data-shop_id');

    function addCategory() {
        ajaxCall('action=add-category&new_category=' + categoryName.value.trim(),
            function(response) {
                categoryCloseButton.click();
                console.log(response);
                var data = JSON.parse(response);
                console.log(data);
                var cat = data.category;
                var index = data.index;
                insertCategoryInSidebar(cat, index);
                insertCategoryInMenuList(cat, index);
                insertCategoryInSelect(cat, index);
                window.location.hash = '#category-' + cat;
            });
    }

    function renameCategory(category) {
        if (category === categoryName.value.trim()) {
            categoryCloseButton.click();
        } else {
            ajaxCall('action=rename-category&category=' + category + '&new_category=' + categoryName.value.trim(),
                function(response) {
                    categoryCloseButton.click();
                    console.log(response);
                    var data = JSON.parse(response);
                    console.log(data);
                    var cat = data.category;
                    var index = data.index;
                    var prevIndex = data.prevIndex;
                    replaceCategoryInSidebar(cat, index, prevIndex);
                    replaceCategoryInMenuList(cat, index, prevIndex);
                    replaceCategoryInSelect(cat, index, prevIndex);
                    window.location.hash = '#category-' + cat;
                });
        }
    }

    function addFood() {
        if (imageInput.files.length === 0) {
            alert('Food image is required!');
            return;
        }
        var file = imageInput.files[0];
        var formData = new FormData();
        formData.append('action', 'add-food');
        formData.append('category', categorySelect.value);
        formData.append('name', title.value);
        formData.append('price', price.value);
        formData.append('time', time.value);
        console.log('Description: ' + description);
        console.log('Description value: ' + description.value);
        if (description.value.trim().length > 0) {
            console.log('NANI!');
            console.log(description.value);
            formData.append('description', description.value.trim());
        }


        formData.append('image', file, file.name);
        console.log(formData);
        ajaxCallFormData(formData
            , function (response) {
                closeButton.click();
                console.log(response);
                var data = JSON.parse(response);
                console.log(data);
                var food = data.food;
                var category_index = data.category_index;
                var index_in_category = data.index_in_category;
                insertFoodInMenuList(food, category_index, index_in_category);
            })
    }

    function modifyFood(foodId) {
        // if (imageInput.files.length === 0) {
        //     alert('Food image is required!');
        //     return;
        // }
        var file = imageInput.files[0];
        var formData = new FormData();
        formData.append('action', 'modify-food');
        formData.append('food_id', foodId);
        formData.append('category', categorySelect.value);
        formData.append('name', title.value);
        formData.append('price', price.value);
        formData.append('time', time.value);
        formData.append('description', description.value);

        formData.append('image', file);
        console.log(formData);
        ajaxCallFormData(formData
            , function (response) {
                closeButton.click();
                console.log(response);
                var data = JSON.parse(response);
                console.log(data);
                var food = data.food;
                var prev_index = data.prev_index;
                var category_index = data.category_index;
                var index_in_category = data.index_in_category;
                replaceFoodInMenuList(food, prev_index, category_index, index_in_category);
            })
    }

    function discardChanges() {
        if (confirm("Confirm discard unsaved changes?")) {
            ajaxCall('action=discard', function(response) {
                window.location.href = response;
            })
        }
    }

    function confirmChanges() {
        if (confirm("Confirm saving changes?")) {
            ajaxCall('action=confirm', function(response) {
                window.location.href = response;
            })
        }
    }

    var i = 0;
    var len = 0;

    len = discardButtons.length;
    for (i = 0; i < len; i++) {
        discardButtons[i].onclick = discardChanges;
    }

    len = confirmButtons.length;
    for (i = 0; i < len; i++) {
        confirmButtons[i].onclick = confirmChanges;
    }

    categoryConfirmBtn.onclick = function() {
        var category = this.getAttribute('data-category');
        if (category) {
            console.log(category);
            renameCategory(category);
        } else {
            addCategory();
        }
    };

    foodConfirmBtn.onclick = function() {
        var foodId = this.getAttribute('data-food_id');
        if (foodId) {
            console.log(foodId);
            modifyFood(foodId);
        } else {
            addFood();
        }
    };

    function newCategory() {
        categoryConfirmBtn.removeAttribute('data-category');
        categoryName.value = '';
        categoryPopUp.style.display = 'flex';
        categoryName.focus();
    }

    len = newCategoryButtons.length;
    for (i = 0; i < len; i++) {
        newCategoryButtons[i].onclick = newCategory;
    }

    function newItem() {
        // foodPopUp.removeAttribute('data-food_id');
        foodConfirmBtn.removeAttribute('data-food_id');
        image.src = 'images/default-food.svg';
        imageInput.value = '';
        categorySelect.value = '';
        title.value = '';
        price.value = '';
        time.value = '';
        description.value = '';
        foodPopUp.style.display = 'flex';
    }

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