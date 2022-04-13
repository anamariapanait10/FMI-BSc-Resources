
function sortare() {
    var radbtns = document.getElementsByName("gr_rad");
    for (let rad of radbtns){
        if (rad.checked){
            var valSort=rad.value;//poate fi 1 sau -1
            console.log("valsort",valSort)
            break;
        }
    }
    sorteaza(valSort);
}

function sorteaza(semn) {
    var articole=document.getElementsByClassName("revista");
    var v_articole=Array.from(articole);
    v_articole.sort(function(a,b){
        var nume_a=a.getElementsByClassName("val-pagini")[0].innerHTML;
        var nume_b=b.getElementsByClassName("val-pagini")[0].innerHTML;
        if(nume_a!=nume_b){
            return semn*nume_a.localeCompare(nume_b);
        }
        else{
            var pag_a=parseInt(a.getElementsByClassName("val-pagini")[0].innerHTML);
            var pret_a=parseInt(a.getElementsByClassName("val-pret")[0].innerHTML);
            var pag_b = parseInt(b.getElementsByClassName("val-pagini")[0].innerHTML);
            var pret_b=parseInt(b.getElementsByClassName("val-pret")[0].innerHTML);
            return semn*((pag_a/pret_a)-(pag_b/pret_b));
        }
    });
    for(let art of v_articole){
        art.parentNode.appendChild(art);
    }
}