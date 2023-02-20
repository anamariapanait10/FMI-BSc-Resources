// Program ce ilustreaza procesarea URL-urilor
var url = require ('url');

var adresa = url.parse (
  'http://TehniciWeb:8080/anulII/grupa232/?nume_student=Ionescu&nota_student=10', 
  true // genereaza un obiect 'query' ce include campurile din querystring
);
console.log (adresa);

if (adresa['query'].nota_student >= 5) {
  console.log ('Ai promovat examenul cu nota ' + adresa['query'].nota_student);
} else {
  console.log ('Nu ai promovat examenul');
}
