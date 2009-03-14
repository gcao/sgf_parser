require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module SGF
  describe StateMachine do
        
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
    
    it "event should trigger state transition if current state is any of transition's start states and input match the pattern" do
      stm = StateMachine.new :start
      stm.transition [:start, :another], /.*/, :end
      stm.event 'a'
      stm.state.should == :end
      stm.instance_variable_set(:'@state', :another)
      stm.event 'a'
      stm.state.should == :end
    end
    
    it "event should not trigger state transition and return false if it does not match the pattern" do
      stm = StateMachine.new :start
      stm.transition :start, /a/, :end
      stm.event('b').should be_false
      stm.state.should == :start
    end
    
    it "transition should invoke the lambda if triggered by an event" do
      dummy = nil
      stm = StateMachine.new :start
      stm.transition :start, /a/, :end, lambda{|stm| dummy = 1 }
      stm.event 'a'
      dummy.should == 1
    end
    
  end
end