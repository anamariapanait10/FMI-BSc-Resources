window.onclick = function (event) {

    let div = document.createElement("div");
    div.innerHTML = "Hello";
    nr = Math.floor(Math.random() * 2) + 1;
    div.classList.add("animat");
    div.style.position = "absolute";
    div.style.top = event.clientY - 25 + "px";
    div.style.left = event.clientX - 25 + "px";
    document.body.appendChild(div);
    div.style.animationName = "miscare" + nr;

    div.onclick = function (ev) {
        ev.stopPropagation();
    }


}
