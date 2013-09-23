program   = require 'commander'
GitHubApi = require 'github'

pkg         = require './../package'
Config      = require './config'
Commands    = require './commands'
Initializer = require './initializer'

exports.run = ->
  program
    .version(pkg.version)
    .option('-c, --config [file]',     'specify .pending-pr file path')
    .option('-g, --global',            'read and write from ~/.pending-pr')
    .option('-a, --all',               'all pull requests')
    .option('-u, --unmergeble',        'include unmergeble pull requests')

  program.on "--help", ->
    console.log "  Commands:"
    console.log ""
    console.log "    init                 Create .pending-pr config file."
    console.log "    list                 Show mergeble pull requests. Short-cut: l"
    console.log "    count                Show mergeble pull requests size. Short-cut: c"
    console.log "    ping                 Ping to pull request to be merged. Short-cut: p"
    console.log "    open                 Browse pull request. Short-cut: o"
    console.log ""

  program.parse process.argv

  args = program.args
  program.help() unless args[0]?

  if args[0] is 'init'
    initializer = new Initializer global: program.global
    initializer.run()
  else
    config = new Config program.config

    client = new GitHubApi version: '3.0.0'
    client.authenticate type: 'oauth', token: config.token

    commands = new Commands
      program: program
      config: config
      client: client

    commands.execute(args...)
