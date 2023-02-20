const express = require('express');
const app = express();

app.use('/post', express.urlencoded({ extended: true }));

persoane = ["Ana", "Adriana", "Mihai", "Corina", "Emilia", "Maria", "Ionut", "Marius"];

app.get("/p4.html", function (req, res) {
    res.sendFile(__dirname + "/p4.html");
});


app.post("/post", function (req, res) {
    var nr_lit = 0, nr_virgule = 0;
    for (var i = 0; i < req.body.pers.length; i++) {
        if (!",QWERTYUIOPASDFGHJKLZXCVBNM".includes(req.body.pers[i])) {
            res.send("Date invalide");
        } else if ("QWERTYUIOPASDFGHJKLZXCVBNM".includes(req.body.pers[i])) {
            nr_lit++;
        } else {
            nr_virgule++;
        }
    }
    if (nr_lit != nr_virgule + 1)
        res.send("Date invalide");

    var arr = req.body.pers.split(',');
    console.log(arr);
    var arr_res = [], arr_res_index = 0;
    for (var i = 0; i < arr.length; i++) {
        for (var p of persoane) {
            if (arr[i] == p[0]) {
                arr_res[arr_res_index++] = p;
            }
        }
    }
    if (arr_res.length == 0) {
        res.send("Nu exista persoane");
    }
    var text = "", len = arr_res.length;
    for (var i = 0; i < len; i++) {
        if (i != len - 1) {
            text = text + arr_res[i] + ", ";
        } else
            text = text + arr_res[i];
    }
    res.send(text);


});

app.listen(7000, function () { console.log("Serverul a pornit"); });


