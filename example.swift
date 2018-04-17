//: Playground - noun: a place where people can play

import UIKit

protocol EngineType {
  var currentGear: Int {get}
  func shiftUp()
  func shiftDown()
}

class Engine: EngineType {
  var currentGear: Int = 1

  func shiftUp() {
    currentGear += 1
    //do other things, like move the chain, etc..
  }

  func shiftDown() {
    currentGear -= 1
    //do other things, like move the chain, etc..
  }
}

class DummyEngine: EngineType {
  //this is a "get" accessor, so when a test depends on an engine, we can supply a mock
  //object with a static value for this variable, and then unit test that our
  //subject behaved correctly based on that mock value
  var currentGear: Int = 300

  //when testing that a function was called, our mock implementation can just maintain a
  //variable to make sure the function was called.  if the function had parameters, we would
  //store the parameters instead of just a flag, and then unit test to make sure that the mock
  //object was called with the expected parameter.
  var didShiftUp = false
  func shiftUp() {
    didShiftUp = true
  }

  var didShiftDown = false
  func shiftDown() {
    didShiftDown = true
  }
}

struct Motorcycle {
  var dashboard: String {
    return "Current gear \(engine.currentGear)"
  }

  private let engine: EngineType

  //notice how the engine is passed in as a dependency, so that tests can provide their own
  //mocked out implementation
  init(engine: EngineType) {
    self.engine = engine
  }

  func didPressShiftUpButton() {
    self.engine.shiftUp()
  }

  func didPressShiftDown() {
    self.engine.shiftDown()
  }
}

// class inherits from quick spec
class MotorcycleTest: QuickSpec {
  //override the spec function to have your tests run
  override func spec() {
    //the subject of your tests is the thing you are testing (its a convention to call it subject)
    var subject: Motorcycle!

    // notice the mocked object is declared specifically of the type of the mock, not the type of the protocol
    var engine: DummyEngine!

    describe("Motorcycle tests") {
      beforeEach {
        //notice how we make a new instance of the mock and the subject before every test
        //unit tests should not depend on each other, each test should set itself up and not depend on any previous tests
        engine = DummyEngine()
        subject = Motorcycle(engine: engine)
      }

      it("has a working dashboard") {
        expect(subject.dashboard).to(equal("Current gear 300"))
      }

      it("Handle an up shift") {
        subject.didPressShiftUpButton()
        expect(engine.didShiftUp).to(beTrue())
      }

      it("Handle a down shift") {
        subject.didPressShiftDownButton()
        expect(engine.didShiftDown).to(beTrue())
      }
    }
  }
}
