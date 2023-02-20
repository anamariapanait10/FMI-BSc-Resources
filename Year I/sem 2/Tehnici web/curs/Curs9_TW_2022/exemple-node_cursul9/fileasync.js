var fs = require('fs');
try{
fs.readFile('date.txt','utf8',function (err, data) {

	if (err) throw err;
        console.log(data);


});
}
catch{console.log("A aparut o eroare;");}
console.log("Citire asincrona");
