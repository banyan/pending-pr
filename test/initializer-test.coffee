_         = require 'underscore'
logger    = require 'loggy'
fs        = require 'fs'
chai      = require 'chai'
expect    = chai.expect
sinon     = require 'sinon'
sinonChai = require 'sinon-chai'
path      = require 'path'

chai.use(sinonChai)

Initializer = require('../src/initializer.coffee')

describe '#constructor', ->
  context 'when global option is passed', ->
    beforeEach ->
      @initializer = new Initializer
        global: true

    it "should have filePath to be a '~/.pending-pr'", ->
      expect(@initializer.filePath).to.eq "#{process.env['HOME']}/.pending-pr"

  context 'when global option is not passed', ->
    beforeEach ->
      @initializer = new Initializer
        global: undefined

    it "should have filePath to be a '~/.pending-pr'", ->
      expect(@initializer.filePath).to.eq "#{process.cwd()}/.pending-pr"

describe '#run', ->
  beforeEach ->
    @initializer = new Initializer
      filePath: '/tmp/.pending-pr'

  it "should write file", ->
    templatePath = './templates/pending-pr.tpl'
    templateFile = fs.readFileSync(templatePath).toString()
    mock = sinon.mock(fs).expects('writeFileSync').withArgs(
      '/tmp/.pending-pr',
      _.template templateFile,
        token: "foo"
        repos: ['rails/rails']
        members: ['banyan', 'shikakun']
    )

    @initializer.run()

    process.stdin.emit "data", "foo\n"
    process.stdin.emit "data", "rails/rails\n"
    process.stdin.emit "data", "banyan shikakun\n"

    mock.verify()
