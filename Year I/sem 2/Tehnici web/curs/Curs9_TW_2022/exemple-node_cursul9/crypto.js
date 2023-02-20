var crypto = require('crypto');   //includem modulul crypto
var password ='tehniciweb2019';
var cipher = crypto.createCipher('aes128', 'a password'); //creaza un obiect de tip 														algoritm de cifrare 
var encrypted = cipher.update(password, 'utf8', 'hex'); //criptarea parolei
encrypted += cipher.final('hex'); //finalizarea criptarii
console.log(encrypted);    //9152f4b48a037fce5c269fbd56376fc4

var encrypt_password = '9152f4b48a037fce5c269fbd56376fc4';
var decipher = crypto.createDecipher('aes128','a password');
var decrypted = decipher.update(encrypt_password,'hex', 'utf8');
decrypted += decipher.final('utf8');
console.log(decrypted);  //tehniciweb2019
