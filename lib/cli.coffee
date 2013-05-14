# CLI main entry point

optimist = require 'optimist'
optimist.usage 'PostgreSQL HTTP API Server'
optimist.options 'port',
    describe : 'HTTP Server port'
    default : process.env.PG_PORT || 3000
optimist.options 'dbhost',
    describe : 'PostgreSQL host'
    default : process.env.PG_HOST || 'localhost'
optimist.options 'dbport',
    describe : 'PostgreSQL port'
    default : process.env.PG_PORT || 5432
optimist.options 'database',
    describe : 'PostgreSQL database'
    default : process.env.PG_USER || process.env.USER
optimist.options 'user',
    describe : 'PostgreSQL username'
    default : process.env.PG_DB || process.env.USER
optimist.options 'password',
    describe : 'PostgreSQL password'
    default : process.env.PG_PASSWORD || null
optimist.options 'raw',
    describe : 'Enable raw SQL usage'
optimist.options 'cors',
    describe : 'Enable CORS support'
optimist.options 'secure',
    describe : 'Enable Basic Auth'    
optimist.options 'help',
    describe : 'Show this message'
argv = optimist.boolean('raw').boolean('cors').boolean('secure')
    .demand(['port', 'dbhost', 'dbport', 'database', 'user'])
    .argv

if argv.help
    console.log optimist.help()
else
    Server = require('./server')
    server = new Server()
    server.start(argv)
