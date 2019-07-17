var header;
var homeSidebar;
var sidebar;
var cartContent;
var cartBtn;
var editMenuAside;
var footer;

function checkOffset() {
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
            // homeSidebar.style.maxHeight = window.innerHeight - header.offsetHeight + 'px';
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
            // sidebar.style.maxHeight = window.innerHeight - header.offsetHeight + 'px';
        }
    }

    if (cartContent) {
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
            // cartContent.style.maxHeight = window.innerHeight - header.offsetHeight - cartBtn.offsetHeight + 'px';
        }
    }

    if (editMenuAside) {
        if (window.innerWidth >= 1024) {
            if (editMenuAside.offsetTop
                + editMenuAside.offsetHeight
                + window.pageYOffset
                + header.offsetHeight
                >= footer.offsetTop) {
                // if exceeds footer
                editMenuAside.style.maxHeight = (footer.offsetTop - window.pageYOffset - editMenuAside.offsetTop) + 'px';
            } else {
                editMenuAside.style.maxHeight = (window.innerHeight - editMenuAside.offsetTop) + 'px';
            }
        } else {
            // editMenuAside.style.maxHeight = window.innerHeight - header.offsetHeight + 'px';
        }
    }
}

window.addEventListener("load",
    function() {
        header = document.getElementsByClassName('header')[0];
        homeSidebar = document.getElementById('js-home-sidebar');
        sidebar = document.getElementById('js-sidebar');
        cartContent = document.getElementById('js-cart-content');
        cartBtn = document.getElementsByClassName('cart-btn')[0];
        editMenuAside = document.getElementById('js-edit-menu-aside');
        footer = document.getElementsByClassName('footer')[0];

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

