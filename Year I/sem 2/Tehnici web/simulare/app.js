const express = require('express');
const app = express();

app.use('/post', express.urlencoded({ extended: true }));

app.get("/p4.html", function (req, res) {
    res.sendFile(__dirname + "/p4.html");
});

app.post("/post", function (req, res) {
    for (var i = 0; i < req.body.numere.length; i++) {
        if (!"/01234567890-".includes(req.body.numere[i])) {
            res.send("Date invalide");
        }
    }
    var arr = req.body.numere.split('/');
    var sum = 0;
    var maxim = parseInt(arr[0]);
    for (var i = 0; i < arr.length; i++) {
        arr[i] = parseInt(arr[i]);
        if (req.body.tip == 'suma' || req.body.tip == 'medie') {
            sum += arr[i];
        } else {
            if (arr[i] > maxim) {
                maxim = arr[i];
            }
        }
    }
    if (req.body.tip == 'medie') {
        res.send((sum / arr.length).toString());
    } else if (req.body.tip == 'suma') {
        res.send(sum.toString());
    }

    res.send(maxim.toString());
});

app.listen(7000, function () { console.log("Serverul a pornit"); });

