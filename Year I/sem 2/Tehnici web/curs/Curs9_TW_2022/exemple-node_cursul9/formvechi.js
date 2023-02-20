var http = require('http');
var url = require('url');
var fs= require('fs');

var server = http.createServer(function (req, res)
{
   console.log("O cerere;");
  // console.log(req.url);
   //var url_parts=new URL('http://localhost:8080'+ req.url);
   var url_parts=url.parse(req.url,true);
   console.log(url_parts);
   if(url_parts.pathname =='/cale'){
    var query=url_parts.query;
  //  var query=url_parts.searchParams;
     fs.appendFileSync('date.txt', query.name + ',' + query.age + ',' + query.city+ '\n');
     res.writeHead(200, {'Content-Type': 'text/plain'});
     res.end(query.name + ' din ' + query.city + ' are ' + query.age + ' ani ');
   }

  }).listen(8080);
console.log ('Serverul creat asteapta cereri la http://localhost:8080/');
