require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

require File.expand_path(File.dirname(__FILE__) + '/../../lib/sgf/state_machine')
require File.expand_path(File.dirname(__FILE__) + '/../../lib/sgf/sgf_state_machine')

module SGF
  describe "SGFStateMachine.state_machine" do
    include SGFStateMachine

    before :each do
      @stm = state_machine
    end

    it "should return state machine for sgf" do
      @stm.class.should == SGF::StateMachine
    end

    it "should have start_state of #{SGFStateMachine::STATE_BEGIN}" do
      @stm.start_state.should == SGFStateMachine::STATE_BEGIN
    end
    
    it "should have transition for #{SGFStateMachine::STATE_BEGIN} ( #{SGFStateMachine::STATE_GAME_BEGIN}" do
      @stm.instance_variable_set(:'@state', SGFStateMachine::STATE_BEGIN)
      @stm.event('(')
      @stm.state.should == SGFStateMachine::STATE_GAME_BEGIN
    end
  end
end


# STATE_BEGIN        = :begin
# STATE_GAME_BEGIN   = :game_begin       # (
# STATE_NODE         = :node             # ;
# STATE_VAR_BEGIN    = :var_begin        # (
# STATE_GAME_VAR_END = :game_var_end     # )
# STATE_PROP_NAME    = :prop_name        # A-Z
# STATE_VALUE_BEGIN  = :value_begin      # [
# STATE_VALUE        = :value            # ^]
# STATE_VALUE_END    = :value_end        # ]
# 
# SGF_STATE_MACHINE = StateMachine.new STATE_BEGIN
# SGF_STATE_MACHINE.transition STATE_BEGIN, /\(/, STATE_GAME_BEGIN
# SGF_STATE_MACHINE.transition STATE_GAME_BEGIN, /;/, STATE_NODE
# SGF_STATE_MACHINE.transition STATE_NODE, /\(/, STATE_VAR_BEGIN
# SGF_STATE_MACHINE.transition STATE_VAR_BEGIN, /[a-zA-Z]/, STATE_PROP_NAME
# SGF_STATE_MACHINE.transition STATE_PROP_NAME, /\[/, STATE_VALUE_BEGIN
# SGF_STATE_MACHINE.transition STATE_VALUE_BEGIN, /[^\]]/, STATE_VALUE
# SGF_STATE_MACHINE.transition STATE_VALUE, /\]/, STATE_VALUE_END
# SGF_STATE_MACHINE.transition STATE_VALUE_END, /\)/, STATE_GAME_VAR_END