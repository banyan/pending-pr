_         = require 'underscore'
fs        = require 'fs'
open      = require 'open'
async     = require 'async'
logger    = require 'loggy'
promptly  = require 'promptly'

module.exports = class Commands
  constructor: ({@program, @config, @client}) ->

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
    throw "NotImplementedError"

  ping: (index) =>
    @_list (pullRequests) =>
      if @program.all
        _.each pullRequests, (pr) =>
          @_postComment pr
      else if index?
        @_postComment pullRequests[index - 1]
      else
        _.each pullRequests, (pr, i) =>
          console.log "#{i + 1}: [#{pr.head.repo.name} @#{pr.user.login}]\t#{pr.title}"

        promptly.choose "ping to which? ", [1..pullRequests.length], (err, value) =>
          @_postComment pullRequests[value - 1]

  open: (number) =>
    @_list (pullRequests) =>
      if @all
        for pr in pullRequests
          open pr.html_url
      else
        open pullRequests[number].html_url

  _list: (fn) =>
    async.map @config.repos, (repo, callback) =>
      [u, r] = repo.split('/')
      @client.pullRequests.getAll {
        user: u
        repo: r
      }, callback
    , (err, results) ->
      a = _.flatten _.map results, (rows) ->
        _.filter rows, (row) -> row.url

      do (a) -> fn a

  _postComment: (pr) =>
    [user, repo] = pr.base.repo.full_name.split('/')
    members = @_getMembers pr.user.login

    @client.issues.createComment
      user: user
      repo: repo
      number: pr.number
      body: """
        #{members}\n\n
        Hi. It's mergeble. Please check and review.
      """

    console.log "Pinged to #{pr.base.repo.full_name}##{pr.number}"

  _getMembers: (pullRequester) =>
    _.chain(@config.members)
      .without(pullRequester)
      .map((member) -> "@#{member}")
      .value()
      .join ' '
