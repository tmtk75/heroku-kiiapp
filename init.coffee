#!/usr/bin/env coffee
express = require "express"
jade    = require "jade"
assets  = require "connect-assets"
stylus  = require "stylus"
nib     = require "nib"
fs      = require "fs"

views_dir  = "#{__dirname}/views"
static_dir = "#{views_dir}/static"

app = express()
app.set 'port', (process.env.PORT || 3000)
app.set "views", views_dir
app.set "view engine", "jade"

app.use express.bodyParser()
app.use express.methodOverride()
app.use express.cookieParser (secret = 'adf19dfe1a4bbdd949326870e3997d799b758b9b')
app.use express.session secret:secret
app.use express.logger 'dev'
app.use (req, res, next)->
  if req.is 'text/*'
    req.text = ''
    req.setEncoding 'utf8'
    req.on 'data', (chunk)-> req.text += chunk
    req.on 'end', next
  else
    next()

app.use stylus.middleware
  src: views_dir
  dest: static_dir
  compile: (str, path, fn)->
             stylus(str)
               .set('filename', path)
               .set('compress', true)
               .use(nib()).import('nib')

app.use assets src:"lib"

app.use '/public', express.static "#{__dirname}/public"
app.use '/',       express.static static_dir
app.use app.router
app.use express.favicon()
app.use (req, res, next)->
  res.status 404
  res.render '404', req._parsedUrl

pkg = JSON.parse fs.readFileSync("package.json")
ctx =
  version: pkg.version
  paths:
    images: "public/images"
routes = require("./routes") ctx
app.get "/",               routes.html "index"
app.get "/index.html",     routes.html "index"

module.exports = (callback)->
  callback app
  require('http').createServer(app).listen app.get('port'), ->
    console.log "Express server listening on port #{app.get('port')}"

