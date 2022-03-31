
function schema_functie() {
    var imagini = document.querySelectorAll("#galerie img");
    for (let i = 0; i < imagini.length; i++) {
        imagini[i].src = "https://cdn4.libris.ro/img/pozeprod/59/1002/D5/25875927.jpg";
        imagini[i].alt = "carte interesanta";
        imagini[i].style.border = "solid";
    }
}

function schimba_descrierea() {
    var figuri = document.querySelectorAll("#galerie figcaption");
    for (let i = 0; i < figuri.length; i++) {
        figuri[i].innerHTML = "Figura " + i;
    }
}

function adauga(info) {
    var articole = document.querySelectorAll("article");
    for (var articol of articole) {
        var pnou = document.createElement("p");
        pnou.innerHTML = info;
        articol.appendChild(pnou);
        pnou.className = "stil";
    }
}

function paragrafe() {
    var paragrafe = document.querySelectorAll("p");
    for (let i = 0; i < paragrafe.length; i++)
        paragrafe[i].innerHTML = paragrafe[i].innerHTML.toUpperCase();
}

window.onload = function () {
    // alert("Hello");
    /*var nume = prompt("Introduceti numele")
    document.getElementById("welcome_msg").innerHTML = "Bine ati venit " + nume.toUpperCase() + "!";
    document.getElementById("welcome_msg").style.color = "blue";
    const citate = ["Idealul meu in viata e femeia cu mustata", "Ai n-ai minge dai la poarta", "Lasa pe maine ce poti face azi ca poate maine nu mai trebuie facut", "Noapta golanii fac nani nani", "Nu-i caruta ca mertanu"]
    document.querySelector("p").innerHTML = citate[Math.floor(Math.random() * citate.length)];

    var numar = parseInt(prompt("Introduceti un numar"))
    carti = [{ titlu: "Matilda", pagini: 256 }, { titlu: "Little Women", pagini: 569 }, { titlu: "Hobbit", pagini: 300 }, { titlu: "Mandrie si prejudecata", pagini: 450 }, { titlu: "Muntele vrajit", pagini: 150 }]
    rez = []
    for (let i = 0; i < carti.length; i++) {
        if (carti[i].pagini >= numar)
            rez.push(carti[i].titlu);
    }
    alert("Numarul de carti este " + rez.length + "\nSi sunt: " + rez);
    */
    schema_functie();
    schimba_descrierea();
    adauga("hello");
    paragrafe();
}

