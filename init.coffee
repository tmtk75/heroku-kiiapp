#!/usr/bin/env coffee
express = require "express"
jade    = require "jade"
assets  = require "connect-assets"
nib     = require "nib"
fs      = require "fs"
path    = require "path"

app = express()
app.set 'port', (process.env.PORT || 3000)
app.set "views", "#{__dirname}/views"
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

app.use assets
  paths: ['assets/js', 'assets/css', 'components'].map (e)->
           path.join(__dirname, e)
  buildDir: 'public/assets'

app.use '/public', express.static "#{__dirname}/public"
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

