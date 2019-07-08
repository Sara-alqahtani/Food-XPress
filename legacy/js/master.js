function checkOffset() {
  var header = document.getElementsByClassName('header')[0];
  var homeSidebar = document.getElementById('js-home-sidebar');
  var sidebar = document.getElementById('js-sidebar');
  var cartContent = document.getElementById('js-cart-content');
  var footer = document.getElementsByClassName('footer')[0];

  if (homeSidebar) {
    if (window.innerWidth >= 548) {
      if (homeSidebar.offsetTop
        + homeSidebar.offsetHeight
        + window.pageYOffset
        + header.offsetHeight
        >= footer.offsetTop) {
          homeSidebar.style.maxHeight = (footer.offsetTop - window.pageYOffset - homeSidebar.offsetTop) + 'px';
      } else {
          homeSidebar.style.maxHeight = (window.innerHeight - homeSidebar.offsetTop) + 'px';
      }
    } else {
      homeSidebar.style.maxHeight = window.innerHeight - header.offsetHeight + 'px';
    }
  }

  if (sidebar) {
    if (window.innerWidth >= 820) {
      if (sidebar.offsetTop
        + sidebar.offsetHeight
        + window.pageYOffset
        + header.offsetHeight
        >= footer.offsetTop) {
          sidebar.style.maxHeight = (footer.offsetTop - window.pageYOffset - sidebar.offsetTop) + 'px';
      } else {
          sidebar.style.maxHeight = (window.innerHeight - sidebar.offsetTop) + 'px';
      }
    } else {
      sidebar.style.maxHeight = window.innerHeight - header.offsetHeight + 'px';
    }
  }

  if (cartContent) {
    var cartBtn = document.getElementsByClassName('cart-btn')[0];
    if (window.innerWidth >= 644) {
      if (cartContent.offsetTop
        + cartContent.offsetHeight
        + cartBtn.offsetHeight
        + window.pageYOffset
        + header.offsetHeight
        >= footer.offsetTop) {
          cartContent.style.maxHeight = (footer.offsetTop - window.pageYOffset - cartContent.offsetTop) + 'px';
      } else {
          cartContent.style.maxHeight = (window.innerHeight - cartContent.offsetTop) + 'px';
      }
    } else {
      cartContent.style.maxHeight = window.innerHeight - header.offsetHeight - cartBtn.offsetHeight + 'px';
    }
  }
}

window.addEventListener("load",
  function() {
    checkOffset();
    var foodButtons = document.getElementsByClassName("js-food-pop-up-btn");
  	var foodPopUp = document.getElementById("js-food-pop-up");
  	var closeButton = document.getElementById("js-food-pop-up-close-btn");
    var title = foodPopUp.getElementsByClassName("box-title")[0];
    var price = foodPopUp.getElementsByClassName("box-info")[0];
    var time = foodPopUp.getElementsByClassName("box-info")[1];
    var rating = foodPopUp.getElementsByClassName("box-info")[2];
    var description = foodPopUp.getElementsByClassName("box-description")[0];
    var remark = foodPopUp.getElementsByClassName("review-text-area")[0];

    if (foodButtons) {
      for (var i = 0; i < foodButtons.length; i++) {
        foodButtons[i].onclick = function() {
          title.innerHTML = this.getElementsByClassName("box-title")[0].innerHTML;
          price.innerHTML = this.getElementsByClassName("box-info")[0].innerHTML;
          time.innerHTML = this.getElementsByClassName("box-info")[1].innerHTML;
          rating.innerHTML = this.getElementsByClassName("box-info")[2].innerHTML;
          description.innerHTML = this.getElementsByClassName("box-description")[0].innerHTML;
          remark.value = "";
          foodPopUp.style.display = "flex";
        }
      }
    }

  	if (closeButton) {
  		closeButton.onclick = function() {
  		  foodPopUp.style.display = "none";
  		}
  	}
  	
  	if (foodPopUp) {
  		foodPopUp.onclick = function() {
  			if (event.target == foodPopUp) {
  		    	foodPopUp.style.display = "none";
  		  	}
  		}
  	}
  },
  true
);
window.addEventListener("scroll",
  function() {
    checkOffset();
  },
  true
);
window.addEventListener("resize",
  function() {
    checkOffset();
  },
  true
);

