#!/usr/bin/env coffee
routes = require "./routes"
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

  logged_in = (req, res, next)->
    if req.session.user
      next()
    else
      res.redirect "/sign-in"

  app.get "/", logged_in, routes.index

  app.get '/sign-in', (req, res, next)->
    username = req.query.username
    password = req.query.password

    KiiUser.authenticate username, password,
      success: (u)->
        req.session.user = name:username
        res.redirect "/"

      failure: (_, error)->
        console.log error
        res.render "sign-in", error:error

  app.get '/sign-out', (req, res, next)->
    req.session.user = null
    res.redirect "/sign-in"

