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
            refreshSavedImagesList();
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

var tasks;

function refreshSavedImagesList() {
    var request = new XMLHttpRequest();
    request.open("GET", "/tasks");
    request.onreadystatechange = function () {
        if (this.readyState != 4) {
            return
        }
        if (this.status == 200) {
            tasks = JSON.parse(request.response);
            var list = document.getElementById("task_list");
            while(list.lastChild) {
                list.removeChild(list.lastChild);
            }
            for (var i = 0; i < tasks.length; i++) {
                var task = tasks[i];
                var id = task["id"];
                var title = task["title"] || "Image without title";
                var url = task["image"] ;

                var rowElement = document.createElement("li");
                rowElement.id = "task_" + id;
                var showButton = document.createElement("input");
                showButton.setAttribute("src", "eye.png");
                showButton.setAttribute("type", "image");
                showButton.className = "show_image_button";
                showButton.classList.add("button");
                showButton.onclick = function (url) {
                    return function () {
                        window.open(url)
                    }
                }(url);
                rowElement.appendChild(showButton);

                var label = document.createElement("span");
                label.className = "saved_task_label";
                label.innerHTML = title;
                rowElement.appendChild(label);

                var deleteButton = document.createElement("input");
                deleteButton.setAttribute("src", "delete.png");
                deleteButton.setAttribute("type", "image");
                deleteButton.className = "delete_image_button";
                deleteButton.classList.add("button");
                deleteButton.onclick = function (id) {
                    return function () {
                        deleteTaskWithId(id)
                    };
                }(id);
                rowElement.appendChild(deleteButton);

                var editButton = document.createElement("input");
                editButton.setAttribute("src", "edit.png");
                editButton.setAttribute("type", "image");
                editButton.className = "edit_image_button";
                editButton.classList.add("button");
                editButton.onclick = function (id) {
                    return function () {
                        editImageWithId(id)
                    };
                }(id);
                rowElement.appendChild(editButton);

                list.appendChild(rowElement);

            }
        }
    };
    request.send();
}

function deleteTaskWithId(id) {
    var element = document.getElementById("task_" + id);
    element.disabled = true;

    var request = new XMLHttpRequest();
    var params = "id=" + id;
    request.open("DELETE", "/tasks?" + params);
    request.onreadystatechange = function () {
        if (this.readyState != 4) {
            return
        }
        element.disabled = false;
        if (this.status == 204) {
            element.parentNode.removeChild(element);
        }
    };
    request.send();
}

function editImageWithId(id) {
    var element = document.getElementById("task_" + id);
    element.disabled = true;

    var request = new XMLHttpRequest();
    request.open("POST", "/tasks/process/" + id);
    request.onreadystatechange = function () {
        if (this.readyState != 4) {
            return
        }
        element.disabled = false;
        if (this.status == 200) {
            window.alert("Added to queue!");
        }
    };
    request.send();
}