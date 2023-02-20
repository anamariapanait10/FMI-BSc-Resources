const crypto  = require('crypto'); //includem modulul crypto

function encrypt(text){
  var cipher = crypto.createCipheriv('aes128', //creaza un obiect de tip algoritm de cifrare
    'passwordpassword', 'vectorvector1234')
  var crypted = cipher.update(text, 'utf8',"hex") //criptarea textului
  //crypted += cipher.update(text2, 'utf8',"hex")
  crypted += cipher.final("hex") //finalizarea criptarii
  return crypted;
}
function decrypt(text){
  var decipher = crypto.createDecipheriv('aes128',
    'passwordpassword', 'vectorvector1234')
  var dec = decipher.update(text, 'hex', 'utf8')
  dec += decipher.final('utf8')
  return dec;

}
console.log(encrypt("Hello World"));
console.log(decrypt("fbbfa235c74e22282237d7ed8f9f21c7"));
