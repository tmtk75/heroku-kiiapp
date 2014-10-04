#!/usr/bin/env coffee
express = require "express"
jade    = require "jade"
stylus  = require "stylus"
assets  = require "connect-assets"
nib     = require "nib"

handler_text = (req, res, next)->
  if req.is 'text/*'
    req.text = ''
    req.setEncoding 'utf8'
    req.on 'data', (chunk)-> req.text += chunk
    req.on 'end', next
  else
    next()

##
app = express()
app.set 'port', (process.env.PORT || 3000)
app.set "views", "#{__dirname}/views"
app.set "view engine", "jade"

app.use express.cookieParser (secret = 'adf19dfe1a4bbdd949326870e3997d799b758b9b')
app.use express.session secret:secret
app.use express.logger 'dev'
app.use handler_text
app.use assets
  paths: ['assets/js', 'assets/css', 'components'].map (e)-> "#{__dirname}/#{e}"
  buildDir: 'public/assets'
app.use '/public', express.static "#{__dirname}/public"
app.use (req, res, next)->
  res.locals.session = req.session
  next()
app.use express.methodOverride()
app.use app.router
app.use express.favicon()
app.use (req, res, next)->
  res.status 404
  res.render '404', req._parsedUrl

module.exports = (callback)->
  callback app
  require('http').createServer(app).listen app.get('port'), ->
    console.log "Express server listening on port #{app.get('port')}"

