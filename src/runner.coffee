program  = require 'commander'
pkg      = require './../package'
Config   = require './config'
Commands = require './commands'

exports.run = ->
  program
    .version(pkg.version)
    .option('-t, --token [token]', 'GitHub API Token')
    .option('-c, --config [file]', 'Specify .pending-pr file path')
    .option('-a, --all',           'All Pull Requests')
    .parse(process.argv)

  args = program.args

  if args[1] is 'init'
    Commands.init()
  else
    config = new Config program.config
    commands = new Commands
      program: program
      config: config

    commands.execute(args...)
