window.onload = function () {
    if (localStorage.getItem("culoare"))
        document.body.style.backgroundColor = localStorage.getItem("culoare");
    setTimeout(changeColor, 2000);
}
function changeColor() {
    var indice = -1;
    var t = setInterval(function () {
        indice++;
        if (indice == 5)
            indice = 0;
        document.querySelectorAll("input")[indice].checked = true;
        document.body.style.backgroundColor = document.querySelectorAll("input")[indice].value;
    }, 3000);
    window.onclick = function () {
        clearInterval(t);
        localStorage.setItem("culoare", document.body.style.backgroundColor);
    }

}

