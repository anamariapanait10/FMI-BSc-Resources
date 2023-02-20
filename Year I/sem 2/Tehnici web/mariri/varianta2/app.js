const { reverse } = require('dns');
const express=require('express');
const app=express();

app.use('/post',express.urlencoded({extended:true}));


app.get('/', (req, res) => {
    res.sendFile(__dirname + "/p4.html")
})

app.post("/post",function(req,res){
	var inp = req.body.nr;
	try{
		var numere = inp.split(",");
	} catch(e){
		res.send("date invalide");
	}

	for(var i = 0; i < numere.length; i++){
		numere[i] = parseInt(numere[i]);
		if(!numere[i]){
			res.send("date invalide");
		}
	}

	if(req.body.grup == "crescator"){
		numere = numere.sort((a,b) => a-b);
	} else{
		numere = numere.sort((a,b) => a-b).reverse();
	}
	res.send(numere.toString());
});

app.listen(7000, function(){console.log("Serverul a pornit");});