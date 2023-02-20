const { Console } = require('console');
const express=require('express');
const app=express();

app.use('/post',express.urlencoded({extended:true}));


app.get('/', (req, res) => {
    res.sendFile(__dirname + "/p4.html")
})

app.post("/post",function(req,res){
	var inp = req.body.inp;
	try{
		var nr = inp.split("/");
	}catch(e){
		res.send("date invalide");
	}
	if(req.body.sel == "suma"){
		var sum = 0;
		for(var n of nr){
			n = parseInt(n);
			if(n)
				res.send("date invalide");
			sum += n;
		}
		res.send(""+sum);

	} else if(req.body.sel  == "medie"){
		var sum = 0;
		for(var n of nr){
			n = parseInt(n);
			if(n)
				res.send("date invalide");
			sum += n;
		}
		var med = sum / nr.length;
		res.send(""+med);
	} else{
		let max = parseInt(nr[0]);
		for(let n of nr){
			n = parseInt(n);
			if(n)
				res.send("date invalide");
			if(n > max){
				max = n;
			}
		}
		res.send(""+max);
	}
});

app.listen(7000, function(){console.log("Serverul a pornit");});