
window.onload = function () {
    var culori = [];
    for (let i = 0; i < 10; i++) {
        let element = document.createElement("button");
        element.classList.add("copil", "cifra" + i);
        element.innerHTML = i;
        document.body.appendChild(element);
        culori.push(getComputedStyle(element).backgroundColor);
    }

    window.onkeydown = function (e) {
        if (e.key >= '0' && e.key <= '9') {
            document.querySelector(".cifra" + e.key).style.backgroundColor = "black";
        }
    }

    window.onkeyup = function (e) {
        if (e.key >= '0' && e.key <= '9') {
            document.querySelector(".cifra" + e.key).style.backgroundColor = culori[e.key];
        }
    }
}
