#!/usr/bin/env coffee
app = require("./init.coffee")

##
kii = require 'node-KiiSDK'
app_id = process.env["KII_APP_ID"]
app_key = process.env['KII_APP_KEY']
endpoint = process.env['KII_ENDPOINT_URL']
throw "either is missing for APP_ID, APP_KEY or ENDPOINT_URL" if !app_id or !app_key or !endpoint
Kii.initializeWithSite app_id, app_key, endpoint
app.get "/api", (req, res)->
  KiiUser.authenticate "tachikoma", "abc123",
    success: (u)->
      res.send "Success: #{JSON.stringify(u)}"
    failure: ->
      res.send "Failed to authenticate: #{JSON.stringify(arguments)}"

require('http').createServer(app).listen app.get('port'), ->
  console.log "Express server listening on port #{app.get('port')}"

