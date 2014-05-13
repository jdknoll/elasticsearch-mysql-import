#!/usr/bin/ruby
require 'rubygems'
require 'mysql2'
require 'elasticsearch'

sqlclient = Mysql2::Client.new(
  host:"localhost", 
  username:"root",
  database:"boxlogger",
  encoding: "utf8",
  init_command: "sql"
  )

result = sqlclient.query("select * from log;")
p log = result.first
puts
p log["date"]
puts
p log["log"]
puts
p log["username"]
puts
p log["log_group"]

elasticclient = Elasticsearch::Client.new log: true
idnum = 1
result.each do |row|
  p row["date"]
  elasticclient.index index: 'boxlogger', type: 'log', id: idnum, body: {
    date: row["date"], 
    log: row["log"], 
    username: row["username"], 
    log_group: row["log_group"]
  }
  idnum += 1
end

elasticclient.indices.refresh index: 'boxlogger'