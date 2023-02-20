const express=require('express');
const app=express();

app.use('/post',express.urlencoded({extended:true}));

orase=[
	{
		nume:"Aa",
		populatie:14000,
		capitala:true
	},
]

app.get('/', (req, res) => {
    res.sendFile(__dirname + "/p4.html")
})

app.post("/post",function(req,res){

	res.send();
});

app.listen(7000, function(){console.log("Serverul a pornit");});