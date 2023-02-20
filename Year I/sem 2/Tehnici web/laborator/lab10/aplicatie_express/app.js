var express = require("express");
var formidable = require("formidable");
var fs = require("fs");
var app = express();

app.use(express.static("html"));
/*
app.get("/", function (req, res) {
    res.send("Hello world :)");
});
app.get("/get1", function (req, res) {
    var nume = req.query.nume;
    var nota1 = parseInt(req.query.nota1);
    var nota2 = parseInt(req.query.nota2);
    var string = "Studentul " + nume + " are media " + (nota1 + nota2) / 2.0;
    res.send(string);

});
*/

app.use(express.urlencoded({ extended: true }));
app.post("/post1", function (req, res) {
    var nume = req.body.nume;
    var nota1 = parseInt(req.body.nota1);
    var nota2 = parseInt(req.body.nota2);
    var string = "Studentul " + nume + " are media " + (nota1 + nota2) / 2.0;
    res.send(string);
});

app.post("/post2", function (req, res) {
    dictionar = [{ cuvant: "carte", engleza: "book", franceza: "livre" }, { cuvant: "floare", engleza: "flower", franceza: "fleur" }, { cuvant: "tablou", engleza: "picture", franceza: "photo" }, { cuvant: "film", engleza: "movie", franceza: "film" }]
    var cuv = req.body.cuvant;
    var n = dictionar.length;
    var gasit = 0;
    for (var i = 0; i < n; i++) {
        console.log(dictionar[i])
        if (dictionar[i]["cuvant"] == cuv) {
            gasit = 1;
            if (req.body.limba == "engleza")
                res.send(dictionar[i]["engleza"]);
            else
                res.send(dictionar[i]["franceza"]);
        }
    }
    if (gasit == 0) {
        res.send("Cuvantul nu este in dictionar :(");
    }
});

app.post("/salveaza", function (req, res) {
    var form = new formidable.IncomingForm();
    form.uploadDir = "poze";
    form.keepExtensions = true;
    var date = fs.readFileSync("produse.json");
    var produse = JSON.parse(date);

    form.parse(req, function (err, fields, files) {
        console.log(fields, files);
        var ob = { nume: fields.nume, pret: fields.pret, cantitate: fields.cantitate, poza: files.poza.newFilename };
        produse.push(ob);
        fs.writeFileSync("produse.json", JSON.stringify(produse));
    });
    res.send("salvat");
});


app.listen(7000, function () {
    console.log("A pornit serverul");
});