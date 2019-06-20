function checkOffset() {
  var header = document.getElementsByClassName('header')[0];
  var homeSidebar = document.getElementById('js-home-sidebar');
  var sidebar = document.getElementById('js-sidebar');
  var cartContent = document.getElementById('js-cart-content');
  var footer = document.getElementsByClassName('footer')[0];

  // home sidebar
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


  // sidebar
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

  // cartContent
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

// window.onload = function() {
//   checkOffset();
// };
// window.onscroll = function() {
//   checkOffset();
// };
// window.onresize = function() {
//   checkOffset();
// };
window.addEventListener("load",
  function() {
    checkOffset();
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

function scrollToTargetAdjusted(){
    var element = document.getElementById('B1#GF');
    var headerOffset = document.getElementsByClassName('header').offsetHeight;
    var elementPosition = element.offsetTop;
    var offsetPosition = elementPosition - headerOffset;

    window.scrollTo({
         top: offsetPosition,
         behavior: "smooth"
    });
}

var foodButton = document.getElementById("foodPop");
var modal = document.getElementById("js-foodPopUp");
var span = document.getElementById("js-close");

window.addEventListener("click",
  function() {
    // scrollToTargetAdjusted();
    // console.log("hello");
    // console.log(event);
    // document.getElementById('D6#GF')
    //   .scrollIntoView({
    //   behavior: 'smooth'
    // });
    if (event.target == modal) {
    modal.style.display = "none";
  }

  },
  true
);


foodButton.onclick = function() {
  modal.style.display = "flex";
  console.log("Checkcheck");
}

span.onclick = function() {
  var modal = document.getElementById("js-foodPopUp");
  modal.style.display = "none";
  console.log("POP success");
}

