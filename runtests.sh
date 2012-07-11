#!/bin/sh
# This script is intended to run the tests locally
psql -f ./test/sql/init.sql -d test
npm test
