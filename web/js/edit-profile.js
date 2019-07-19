window.addEventListener("load", function() {
    var removeBtn = document.getElementById('js-remove-profile-picture-btn');
    removeBtn.onclick = function() {
        var output = document.getElementById('js-edit-profile-picture');
        output.src = "images/user-profile/default.png";
    };
    var imageInput = document.getElementById('js-upload-image');
    imageInput.onchange = function(event) {
        var removeImage = document.getElementById('js-remove-image');
        removeImage.checked = false;
        var reader = new FileReader();
        reader.onload = function(){
            var output = document.getElementById('js-edit-profile-picture');
            output.src = reader.result;
        };
        reader.readAsDataURL(event.target.files[0]);
    };
});