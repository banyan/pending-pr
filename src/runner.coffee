program   = require 'commander'
GitHubApi = require 'github'

pkg         = require './../package'
Config      = require './config'
Commands    = require './commands'
Initializer = require './initializer'

exports.run = ->
  program
    .version(pkg.version)
    .option('-t, --token [token]', 'GitHub API Token')
    .option('-c, --config [file]', 'Specify .pending-pr file path')
    .option('-g, --global',        'Read and write from ~/.pending-pr')
    .option('-a, --all',           'All Pull Requests')
    .parse(process.argv)

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
