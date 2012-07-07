# PostgreSQL HTTP API Server

Attempt to implement proposal at http://wiki.postgresql.org/wiki/HTTP_API

**DISCLAIMER**: Experimental work at this time.

## Installing

NOTE: Requires node.js

    # sudo npm install postgresql-http-server -g

## Usage

    # postgresql-http-server --help
    PostgreSQL HTTP API Server
    
    Options:
      --port      HTTP Server port     [required]  [default: 3000]
      --dbhost    PostgreSQL host      [required]  [default: "localhost"]
      --dbport    PostgreSQL port      [required]  [default: 5432]
      --database  PostgreSQL database  [required]  [default: <user>]
      --user      PostgreSQL username  [required]  [default: <user>]
      --password  PostgreSQL password
      --help      Show this message  