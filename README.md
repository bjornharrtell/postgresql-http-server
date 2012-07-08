# PostgreSQL HTTP API Server

Attempt to implement something like the proposal at http://wiki.postgresql.org/wiki/HTTP_API

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

## API Usage

The API is discoverable which means you can access the root resource at /
and follow links to subresources from there. But lets say you have a database
named testdb with a table named testtable in the public schema. You can then 
do the following operations:

    GET row data at:
    /db/testdb/schemas/public/tables/testtable/rows
    
    GET row data with where filter like:
    /db/testdb/schemas/public/tables/testtable/rows?where=id%3D3
    
    GET paginated row data with limit and offset params:
    /db/testdb/schemas/public/tables/testtable/rows?limit=10&offset=10
    
    GET a single row at:
    /db/testdb/schemas/public/tables/testtable/rows/id
    
    POST a new row at:
    /db/testdb/schemas/public/tables/testtable/rows

The default and currently the only dataformat is JSON.