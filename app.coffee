#!/usr/bin/env coffee
fs = require "fs"

pkg = JSON.parse fs.readFileSync("package.json")
global.ctx =
  version: pkg.version

require("./init.coffee") (app)->
  ##
  kii = require 'node-KiiSDK'
  app_id   = process.env["KII_APP_ID"]
  app_key  = process.env['KII_APP_KEY']
  endpoint = process.env['KII_ENDPOINT_URL']
  throw "either is missing for KII_APP_ID, KII_APP_KEY or KII_ENDPOINT_URL" if !app_id or !app_key or !endpoint
  Kii.initializeWithSite app_id, app_key, endpoint

  app.get "/api", (req, res)->
    KiiUser.authenticate "tachikoma", "abc123",
      success: (u)->
        res.send "Success: #{JSON.stringify(u)}"
      failure: ->
        res.send "Failed to authenticate: #{JSON.stringify(arguments)}"

  logged_in = (req, res, next)->
    next()

  routes = require "./routes"
  app.get "/", logged_in, routes.index
  app.get '/login', routes.login

