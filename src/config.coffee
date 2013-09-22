fs     = require 'fs'
logger = require 'loggy'

module.exports = class Config
  fileName = '.pending-pr'

  constructor: (@configFile) ->
    {@token, @repos, @members} = JSON.parse fs.readFileSync(@_getConfigFilePath(), 'utf8')

  _getConfigFilePath: ->
    path = if @configFile? and fs.existsSync("#{process.cwd()}/#{@configFile}")
      "#{process.cwd()}/#{@configFile}"
    else if fs.existsSync "#{process.cwd()}/#{fileName}"
      "#{process.cwd()}/#{fileName}"
    else if fs.existsSync "#{process.env['HOME']}/#{fileName}"
      "#{process.env['HOME']}/#{fileName}"
    else
      logger.error "There's no config file. Try `pending-pr init`."
      process.exit 1

    path
