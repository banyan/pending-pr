chai      = require 'chai'
expect    = chai.expect
sinon     = require 'sinon'
sinonChai = require 'sinon-chai'

chai.use(sinonChai)

Runner = require('../src/runner.coffee')

# describe "test", ->
  # beforeEach ->
    # @runner = new Runner

  # it "should be done successfull", ->
    # expect(@runner.run()).to.equal "foo"
