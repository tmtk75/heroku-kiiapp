#!/usr/bin/env coffee
express = require "express"
jade    = require "jade"
stylus  = require "stylus"
assets  = require "connect-assets"
nib     = require "nib"
fs      = require "fs"

handler_text = (req, res, next)->
  if req.is 'text/*'
    req.text = ''
    req.setEncoding 'utf8'
    req.on 'data', (chunk)-> req.text += chunk
    req.on 'end', next
  else
    next()

handler_404 = (req, res, next)->
  res.status 404
  res.render '404', req._parsedUrl

app = express()
app.set 'port', (process.env.PORT || 3000)
app.set "views", "#{__dirname}/views"
app.set "view engine", "jade"

app.use express.bodyParser()
app.use express.methodOverride()
app.use express.cookieParser (secret = 'adf19dfe1a4bbdd949326870e3997d799b758b9b')
app.use express.session secret:secret
app.use express.logger 'dev'
app.use handler_text
app.use assets
  paths: ['assets/js', 'assets/css', 'components'].map (e)-> "#{__dirname}/#{e}"
  buildDir: 'public/assets'
app.use '/public', express.static "#{__dirname}/public"
app.use app.router
app.use express.favicon()
app.use handler_404

pkg = JSON.parse fs.readFileSync("package.json")
ctx =
  version: pkg.version
routes = require("./routes") ctx
app.get "/",               routes.html "index"
app.get "/index.html",     routes.html "index"

module.exports = (callback)->
  callback app
  require('http').createServer(app).listen app.get('port'), ->
    console.log "Express server listening on port #{app.get('port')}"

