chai      = require 'chai'
expect    = chai.expect
sinon     = require 'sinon'
sinonChai = require 'sinon-chai'

chai.use(sinonChai)

Config = require('../src/config.coffee')

describe '#constructor', ->
  context 'when configFilePath is passed to argument', ->
    context 'configFile not exists', ->
      it "should be thrown an error", ->
        expect(=> (new Config 'non-exist-file')).to.throw

    context 'configFile exists', ->
      beforeEach ->
        @config = new Config 'test/.pending-pr'

      it "should have expected property", ->
        expect(@config.token).to.eq 'foo'
        expect(@config.repos).to.eql ['foo/bar']
        expect(@config.members).to.eql ['@banyan', '@shikakun']
