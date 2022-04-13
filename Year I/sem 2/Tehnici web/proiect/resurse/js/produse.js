window.addEventListener("DOMContentLoaded", function(){


    var btn=document.getElementById("filtrare");
    btn.onclick=function(){
        var articole=document.getElementsByClassName("produs");
        for(let art of articole){

            art.style.display="none";

            var nume=art.getElementsByClassName("val-nume")[0];//<span class="val-nume">aa</span>
            var conditie1=nume.innerHTML.startsWith(document.getElementById("inp-nume").value)

            var pret=art.getElementsByClassName("val-pret")[0]
            var conditie2=parseInt(pret.innerHTML) > parseInt(document.getElementById("inp-pret").value);

            var radbtns=document.getElementsByName("gr_rad");
            for (let rad of radbtns){
                if (rad.checked){
                    var valBlat=rad.value;//poate fi 1, 2 sau 3
                    break;
                }
            }

            var blat= art.getElementsByClassName("val-blat")[0].innerHTML;
            var conditie3=false;
            switch (valBlat){
                case "1": conditie3= (blat=='Clasic'); break;
                case "2": conditie3= (blat=='Pufos'); break;
                case "3": conditie3= (blat=='Crocant'); break;
                default: conditie3=true;
            }            
            
            var selCateg=document.getElementById("inp-categorie");
            var conditie4= (art.getElementsByClassName("val-categorie")[0].innerHTML == selCateg.value || selCateg.value=="toate");
            console.log(nume.innerHTML + ' ' + conditie1 + ' ' + conditie2 + ' ' + conditie3 + ' ' + conditie4);

            if(conditie1 && conditie2 && conditie3 && conditie4)
                art.style.display="block";
            
        }
    }
    var rng=document.getElementById("inp-pret");
    rng.onchange=function(){
        var info = document.getElementById("infoRange");//returneaza null daca nu gaseste elementul
        if(!info){
            info=document.createElement("span");
            info.id="infoRange"
            this.parentNode.appendChild(info);
        }
        
        info.innerHTML="("+this.value+")";
    }



    function sorteaza(semn){
        var articole=document.getElementsByClassName("produs");
        var v_articole=Array.from(articole);
        v_articole.sort(function(a,b){
            var nume_a=a.getElementsByClassName("val-nume")[0].innerHTML;
            var nume_b=b.getElementsByClassName("val-nume")[0].innerHTML;
            if(nume_a!=nume_b){
                return semn*nume_a.localeCompare(nume_b);
            }
            else{
                
                var pret_a=parseInt(a.getElementsByClassName("val-pret")[0].innerHTML);
                var pret_b=parseInt(b.getElementsByClassName("val-pret")[0].innerHTML);
                return semn*(pret_a-pret_b);
            }
        });
        for(let art of v_articole){
            art.parentNode.appendChild(art);
        }
    }

    var btn2=document.getElementById("sortCrescNume");
    btn2.onclick=function(){
        
        sorteaza(1)
    }

    var btn3=document.getElementById("sortDescrescNume");
    btn3.onclick=function(){
        sorteaza(-1)
    }


    document.getElementById("resetare").onclick=function(){
        //resetare inputuri
        document.getElementById("i_rad4").checked=true;
        document.getElementById("inp-pret").value=document.getElementById("inp-pret").min;
        document.getElementById("infoRange").innerHTML="("+document.getElementById("inp-pret").min+")";

        //de completat...


        //resetare articole
        var articole=document.getElementsByClassName("produs");
        for(let art of articole){

            art.style.display="block";
        }
    }
    
    // -------------------- selectare produse cos virtual----------------------------------
    /*
        indicatie pentru cand avem cantitati
        fara cantitati: "1,2,3,4" //1,2,3,4 sunt id-uri
        cu cantitati:"1:5,2:3,3:1,4:1" // 5 produse de tipul 1, 3 produse de tipul 2, 1 produs de tipul 3...
        putem memora: [[1,5],[2,3],[3,1],[4,1]]// un element: [id, cantitate]

    */
    ids_produse_init=localStorage.getItem("produse_selectate");
    if(ids_produse_init)
        ids_produse_init=ids_produse_init.split(",");//obtin vectorul de id-uri ale produselor selectate  (din cosul virtual)
    else
        ids_produse_init=[]

    var checkboxuri_cos = document.getElementsByClassName("select-cos");
    for (let ch of checkboxuri_cos){
        if (ids_produse_init.indexOf(ch.value)!=-1)
            ch.checked=true;
        ch.onchange=function(){
            ids_produse=localStorage.getItem("produse_selectate")
            if(ids_produse)
                ids_produse=ids_produse.split(",");
            else
                ids_produse=[]
            console.log("Selectie veche:", ids_produse);
            //ids_produse.map(function(elem){return parseInt(elem)});
            //console.log(ids_produse);
            if(ch.checked){
                ids_produse.push(ch.value);//adaug elementele noi, selectate (bifate)
            }
            else{
                ids_produse.splice(ids_produse.indexOf(ch.value), 1) //sterg elemente debifate
            }
            console.log("Selectie noua:",ids_produse);
            localStorage.setItem("produse_selectate",ids_produse.join(","))
        }
    }
 });


 window.onkeydown=function(e){
    if(e.key=="c" && e.altKey==true){
        var suma=0;
        var articole=document.getElementsByClassName("produs");
        for(let art of articole){
            if(art.style.display!="none")
                suma+=parseFloat(art.getElementsByClassName("val-pret")[0].innerHTML);
        }

        var spanSuma;
        spanSuma=document.getElementById("numar-suma");
        if(!spanSuma){
            spanSuma=document.createElement("span");
            spanSuma.innerHTML=" Suma:"+suma;//<span> Suma:...
            spanSuma.id="numar-suma";//<span id="..."
            document.getElementById("p-suma").appendChild(spanSuma);
            setTimeout(function(){document.getElementById("numar-suma").remove()}, 1500);
        }
    }


 }