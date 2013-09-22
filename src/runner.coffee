pkg         = require './../package'
program     = require 'commander'
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
    initializer = new Initializer
      global: program.global
    initializer.run()
  else
    config = new Config program.config
    commands = new Commands
      program: program
      config: config

    commands.execute(args...)
