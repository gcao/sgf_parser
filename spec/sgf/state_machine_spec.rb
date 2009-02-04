require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

require File.expand_path(File.dirname(__FILE__) + '/../../lib/sgf/state_machine')

module SGF
  describe StateMachine do
    
    it "initializer should take start state" do
      StateMachine.new :start
    end
    
    it "transition should take 3 arguments" do
      stm = StateMachine.new :start
      stm.transition :start, /.*/, :end
    end
    
    it "transition should be able to take a list of start states" do
      stm = StateMachine.new :start
      stm.transition [:start, :another], /.*/, :end
    end
    
    it "state should return current state" do
      stm = StateMachine.new :start
      stm.state.should == :start
    end
    
    it "event should trigger state transition and return true if match the pattern" do
      stm = StateMachine.new :start
      stm.transition :start, /.*/, :end
      stm.event('a').should be_true
      stm.state.should == :end
    end
    
    it "event should return false if no transition is defined for state" do
      stm = StateMachine.new :start
      stm.event('a').should be_false
    end
    
    it "event should trigger state transition if current state is one of transition's start states and input match the pattern" do
      stm = StateMachine.new :start
      stm.transition [:start, :another], /.*/, :end
      stm.event 'a'
      stm.state.should == :end
    end
    
    it "event should not trigger state transition and return false if it does not match the pattern" do
      stm = StateMachine.new :start
      stm.transition :start, /a/, :end
      stm.event('b').should be_false
      stm.state.should == :start
    end
    
  end
end