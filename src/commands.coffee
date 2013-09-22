_         = require 'underscore'
fs        = require 'fs'
open      = require 'open'
async     = require 'async'
logger    = require 'loggy'
promptly  = require 'promptly'
GitHubApi = require 'github'

module.exports = class Commands
  GITHUB_API_VERSION: '3.0.0'

  constructor: ({@program, @config}) ->

    @client = new GitHubApi
      version: @GITHUB_API_VERSION

    @client.authenticate
      type: 'oauth'
      token: @config.token

  execute: (method, options...) ->
    @[method](options...)

  list: =>
    @_list (pullRequests) ->
      _.each pullRequests, (pr, i) =>
        console.log "#{i + 1}: [#{pr.head.repo.name} @#{pr.user.login}]\t#{pr.title}"

  size: =>
    @_list (pullRequests) ->
      console.log pullRequests.length

  show: =>


  ping: =>
    @_list (pullRequests) ->
      _.each pullRequests, (pr, i) =>
        console.log "#{i + 1}: [#{pr.head.repo.name} @#{pr.user.login}]\t#{pr.title}"

      console.log ""

      # promptly.choose "ping to which? ", [0, 1, 2], (err, value) ->
        # console.log "Answer:", value

  open: (number) =>
    @_list (pullRequests) =>
      if @all
        for pr in pullRequests
          open pr.html_url
      else
        open pullRequests[number].html_url

  _list: (fn) =>
    async.map @config.repos, (repo, callback) =>
      [user, repo] = repo.split('/')
      @client.pullRequests.getAll {
        user: user
        repo: repo
      }, callback
    , (err, results) ->
      a = _.flatten _.map results, (rows) ->
        _.filter rows, (row) -> row.url

      do (a) -> fn a
