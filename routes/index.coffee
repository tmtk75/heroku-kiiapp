module.exports = 

  index: (req, res, next)->
    res.render "index", global.ctx

  login: (req, res, next)->
    res.render "login", global.ctx
