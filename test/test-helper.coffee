global.sinon = require("sinon")
global.chai = require("chai")
global.expect = require("chai").expect
global.AssertionError = require("chai").AssertionError
global.swallow = (thrower) ->
  try
    thrower()

sinonChai = require("sinon-chai")
chai.use sinonChai
