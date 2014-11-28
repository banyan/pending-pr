_         = require 'underscore'
fs        = require 'fs'
open      = require 'open'
async     = require 'async'
logger    = require 'loggy'
promptly  = require 'promptly'

module.exports = class Commands
  constructor: ({@program, @config, @client}) ->

  execute: (method, args...) ->
    @[method](args...)

  list: =>
    @_list (pullRequests) ->
      for pr, i in pullRequests
        console.log "#{i + 1}: [#{pr.head.repo.name} @#{pr.user.login}]\t#{pr.title}"

  count: =>
    @_list (pullRequests) ->
      console.log pullRequests.length

  show: =>
    throw "NotImplementedError"

  ping: (index) =>
    @_list (pullRequests) =>
      if @program.all
        for pr, i in pullRequests
          @_postComment pr
      else if index?
        @_postComment pullRequests[index - 1]
      else
        for pr, i in pullRequests
          console.log "#{i + 1}: [#{pr.head.repo.name} @#{pr.user.login}]\t#{pr.title}"

        console.log ""
        promptly.choose "ping to which? ", [1..pullRequests.length], (err, value) =>
          @_postComment pullRequests[value - 1]

  open: (index) =>
    @_list (pullRequests) =>
      if @program.all
        for pr in pullRequests
          open pr.html_url
      else if index?
        open pullRequests[index - 1].html_url
      else
        for pr, i in pullRequests
          console.log "#{i + 1}: [#{pr.head.repo.name} @#{pr.user.login}]\t#{pr.title}"

        console.log ""
        promptly.choose "open which? ", [1..pullRequests.length], (err, value) =>
          open pullRequests[value - 1].html_url

  # Aliases
  l: @::list
  c: @::count
  p: @::ping
  o: @::open

  _list: (fn) =>
    async.map @config.repos, (repo, callback) =>
      [u, r] = repo.split('/')
      @client.pullRequests.getAll {
        user: u
        repo: r
      }, callback
    , (err, results) =>
      rows = _.chain(results)
        .flatten()
        .reject(@_exclude)
        .value()

      do (rows) -> fn rows

  _postComment: (pr) =>
    unless pr.base?
      console.error "cant get pr" if pr.base?
      return

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

  _exclude: (result) =>
    title = result?.title
    (/wip/i.test(title) or /DO\s?N'?O?T\s?MERGE/i.test(title)) and !@program.unmergeble
