window.onload = function()
{
  window.onkeydown = function(event) {
      window.onkeydown = null;
      var scor = 0;
      for(let i = 1; i<=20; i++)
      {
        let obiect = document.createElement("img");
        obiect.src = "sad.png";
        var parent = document.getElementById("container");
        parent.appendChild(obiect);
        obiect.onclick = function(){
          obiect.src = "happy.png";
          obiect.onclick = null;
          scor = scor + 1;
          var score = document.getElementById("scor");
          score.innerHTML = scor;
        }
      }
      var joc = document.querySelector("#game>p");
      joc.style.visibility = "visible";
      setTimeout(function(){var title = document.querySelector("h1");
                            title.innerHTML = "Jocul s-a terminat!";
                            let ob = document.querySelector("img")
                            document.querySelector("div").removeChild(ob);}, 5000);
  }
}
