const express = require('express');
const app = express();

app.use('/post', express.urlencoded({ extended: true }));

persoane = [
	{ nume: "Ion", sex: "m", varsta: 3 },
	{ nume: "Oana", sex: "f", varsta: 23 },
	{ nume: "Daria", sex: "f", varsta: 10 },
	{ nume: "Mihai", sex: "m", varsta: 19 },
	{ nume: "Gabriel", sex: "m", varsta: 22 },
	{ nume: "Simona", sex: "f", varsta: 11 },
	{ nume: "Bogdan", sex: "m", varsta: 28 },
];

app.get('/', (req, res) => {
    res.sendFile(__dirname + "/p4.html")
})

app.post("/post", function (req, res) {

	var inp = req.body.pers;
	var text = "";
	for (let pers of persoane) {
		if (req.body.pers == pers.nume) {
			if (pers.sex == "m")
				text += "baiat, ";
			else
				text += "fata, ";
			if (pers.varsta < 18)
				text += "este minor";
			else
				text += "nu este minor";
		}
	}
	if (text == "")
		text = "Nu exista numele cautat";
	inp.value = text;
	res.send(text);
});

app.listen(7000, function () { console.log("Serverul a pornit"); });