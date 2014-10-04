module.exports = 

  index: (req, res, next)->
    res.render "index", global.ctx

