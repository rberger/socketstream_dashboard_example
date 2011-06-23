mongodb = require "mongodb"
global.client = new mongodb.Db 'dashboard', new mongodb.Server("127.0.0.1", 27017), {native_parser:true}

option '-o', '--output [DIR]', 'directory for compiled code'

task 'seed', 'clear the database out, then load seed data into the database', (options) ->
  seedData = require 'config/seed.coffee'
  console.log 'loading seed data'
  client.open (err, client) ->
    for seedCollection in seedData.collections
      for name, data of seedCollection
        client.createCollection name, (err, collection) ->
          collection.insert data, (err, docs) ->
            console.log 'doing a batch insert'
            client.close()        
    
task 'clear', 'clear the database out', (options) ->
  console.log 'dropping the database'
  client.open (err, client) ->
    client.dropDatabase (err, done) ->
      client.close()