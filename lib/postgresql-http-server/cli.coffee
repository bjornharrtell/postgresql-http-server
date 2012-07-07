optimist = require 'optimist'
optimist.usage 'PostgreSQL HTTP API Server'
optimist.options 'port',
    describe : 'HTTP Server port'
    default : 3000
optimist.options 'dbhost',
    describe : 'PostgreSQL host'
    default : 'localhost'
optimist.options 'dbport',
    describe : 'PostgreSQL port'
    default : 5432
optimist.options 'database',
    describe : 'PostgreSQL database'
    default : process.env.USER
optimist.options 'user',
    describe : 'PostgreSQL username'
    default : process.env.USER
optimist.options 'password',
    describe : 'PostgreSQL password'
optimist.options 'help',
    describe : 'Show this message'
argv = optimist.demand(['port', 'dbhost', 'dbport', 'database', 'user']).argv

if argv.help
    console.log optimist.help()
else
    server = require './server'
    server.start(argv)
