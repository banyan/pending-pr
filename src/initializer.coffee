_        = require 'underscore'
fs       = require 'fs'
async    = require 'async'
logger   = require 'loggy'
sysPath  = require 'path'
promptly = require 'promptly'

module.exports = class Initializer
  fileName     = '.pending-pr'
  templatePath = sysPath.join __dirname, '..', 'templates', 'pending-pr.tpl'

  constructor: ({@global, @filePath}) ->
    @filePath or= if @global
      "#{process.env['HOME']}/#{fileName}"
    else
      "#{process.cwd()}/#{fileName}"

  run: ->
    if fs.existsSync @filePath
      logger.info "skipping #{@filePath} (already exists)"
      process.exit 0

    async.series [(callback) ->
      promptly.prompt "Token: ", (err, value) ->
        callback(null, token: value)

    , (callback) ->
      promptly.prompt "Repos: ", (err, value) ->
        callback(null, repos: value.split(' '))

    , (callback) ->
      promptly.prompt "Members: ", default: '', (err, value) ->
        callback(null, members: value.split(' '))

    ], (err, results) =>
      throw err if err

      templateFile = fs.readFileSync(templatePath).toString()
      fs.writeFileSync @filePath, _.template(templateFile, _.extend(results...))

      logger.info "create #{@filePath}"
