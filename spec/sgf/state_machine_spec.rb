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
    
    it "state should return current state" do
      stm = StateMachine.new :start
      stm.state.should == :start
    end
    
    it "event should trigger state transition if match the pattern" do
      stm = StateMachine.new :start
      stm.transition :start, /.*/, :end
      stm.event 'a'
      stm.state.should == :end
    end
    
    it "event should not trigger state transition if it does not match the pattern" do
      stm = StateMachine.new :start
      stm.transition :start, /a/, :end
      stm.event 'b'
      stm.state.should == :start
    end
    
  end
end