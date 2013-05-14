express = require('express')

exports.secureAPI = express.basicAuth (user, pass) -> 
    password = process.env.PG_BASIC_PASS
    user = process.env.PG_BASIC_USER || 'pguser'
    if (password == null || password == undefined) 
      console.log("PG_BASIC_PASS env variable is missing....")
      return false;
    return user == user && pass == password

