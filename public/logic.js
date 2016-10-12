/**
 * Created by rumata on 10/11/16.
 */

function addNewImage() {
    hideResponses();

    var form = document.forms["addImage"];
    setFormStateDisabled(form, true);
    var id = form["field_image_id"].value;
    var title = form["field_image_title"].value;
    var url = form["field_image_url"].value;

    var request = new XMLHttpRequest();
    var params = "id=" + id + "&title=" + title + "&image=" + url;
    request.open("POST", "/tasks?" + params);
    request.onreadystatechange = function () {
        setFormStateDisabled(form, false);
        if (this.readyState != 4) {
            return
        }
        if (this.status == 200) {
            document.getElementById("image_upload_success").className = "visible";
        } else {
            document.getElementById("image_upload_failure").className = "visible";
        }
    };
    request.send();

    return false
}

function hideResponses() {
    document.getElementById("image_upload_failure").className = "hidden";
    document.getElementById("image_upload_success").className = "hidden";
}

function setFormStateDisabled(form, state) {
    var loader = document.getElementsByClassName("loader")[0];
    loader.classList.toggle("hidden", !state);
    var list = form.elements;
    for (var i = 0; i < list.length; i++) {
        var element = list[i];
        element.disabled = state;
    }
}