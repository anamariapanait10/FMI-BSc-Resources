const express=require('express');
const app=express();

app.use('/post',express.urlencoded({extended:true}));

carti=[
	{
		titlu:"c1",
		gen:"aventura",
		pagini:"200",
	},
	{
		titlu:"c4",
		gen:"politist",
		pagini:"240",
	},
	{
		titlu:"c5",
		gen:"fantastic",
		pagini:"300",
	},
	{
		titlu:"c2",
		gen:"fantastic",
		pagini:"450",
	},
	{
		titlu:"c3",
		gen:"aventura",
		pagini:"600",
	},
]

app.get('/', (req, res) => {
    res.sendFile(__dirname + "/p4.html")
})

app.post("/post",function(req,res){
	var exista = false;
	var titluri = "Titluri: ";
	console.log(req.body.tip);
	for(let carte of carti){
		if(req.body.tip == carte.gen && parseInt(carte.pagini) > 250){
			if(titluri == "Titluri: "){
				titluri += carte.titlu;
			} else {
				titluri += ", " + carte.titlu;
			}
			exista = true;
		}
	}
	if(!exista)
		res.send("Nu exista carti");
	res.send(titluri);
});

app.listen(7000, function(){console.log("Serverul a pornit");});