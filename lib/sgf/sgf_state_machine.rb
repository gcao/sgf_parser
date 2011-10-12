module SGF

  class StateMachineError < StandardError
  end

  class SGFStateMachine < StateMachine

    module Callbacks
      def start_game
        return if context.nil?
        context.start_game
      end

      def end_game
        return if context.nil?
        context.end_game
      end

      def start_node
        return if context.nil?
        context.start_node
      end

      def end_node
        return if context.nil?
        context.end_node
      end

      def start_variation
        return if context.nil?
        context.start_variation
      end

      def store_input_in_buffer
        return if context.nil?
        self.buffer = input
      end

      def append_input_to_buffer
        return if context.nil?
        self.buffer += input
      end

      def set_property_name
        return if context.nil?
        context.property_name = buffer
        clear_buffer
      end

      def set_property_value
        return if context.nil?
        context.property_value = buffer
        clear_buffer
      end

      def end_variation
        return if context.nil?
        context.end_variation
      end

      def report_error
        raise StateMachineError.new('SGF Error near "' + input + '"')
      end
    end

    include Callbacks

    STATE_BEGIN           = :begin
    STATE_GAME_BEGIN      = :game_begin
    STATE_GAME_END        = :game_end
    STATE_NODE_BEGIN      = :node_begin
    STATE_VAR_BEGIN       = :var_begin
    STATE_VAR_END         = :var_end
    STATE_PROP_NAME_BEGIN = :prop_name_begin
    STATE_PROP_NAME       = :prop_name
    STATE_VALUE_BEGIN     = :value_begin
    STATE_VALUE           = :value
    STATE_VALUE_ESCAPE    = :value_escape
    STATE_VALUE_END       = :value_end
    STATE_INVALID         = :invalid

    def initialize
      super(STATE_BEGIN)

      transition STATE_BEGIN,
                 /\(/,
                 STATE_GAME_BEGIN,
                 :start_game

      transition [STATE_GAME_BEGIN, STATE_VAR_BEGIN, STATE_VAR_END],
                 /;/,
                 STATE_NODE_BEGIN,
                 :start_node

      transition STATE_VALUE_END,
                 /;/,
                 STATE_NODE_BEGIN,
                 lambda {|stm| stm.end_node; stm.start_node }

      transition STATE_NODE_BEGIN,
                 /;/,
                 nil

      transition [STATE_NODE_BEGIN, STATE_VALUE_END],
                 /\(/,
                 STATE_VAR_BEGIN,
                 lambda {|stm| stm.end_node; stm.start_variation }

      transition STATE_VAR_END,
                 /\(/,
                 STATE_VAR_BEGIN,
                 :start_variation

      transition [STATE_NODE_BEGIN, STATE_VALUE_END],
                 /[a-zA-Z]/,
                 STATE_PROP_NAME_BEGIN,
                 :store_input_in_buffer

      transition [STATE_PROP_NAME_BEGIN, STATE_PROP_NAME],
                 /[a-zA-Z]/,
                 STATE_PROP_NAME,
                 :append_input_to_buffer

      transition [STATE_PROP_NAME_BEGIN, STATE_PROP_NAME],
                 /\[/,
                 STATE_VALUE_BEGIN,
                 :set_property_name

      transition STATE_VALUE_END,
                 /\[/,
                 STATE_VALUE_BEGIN

      transition STATE_VALUE_BEGIN,
                 /[^\]]/,
                 STATE_VALUE,
                 :store_input_in_buffer

      transition [STATE_VALUE_BEGIN, STATE_VALUE],
                 /\\/,
                 STATE_VALUE_ESCAPE

      transition STATE_VALUE_ESCAPE,
                 /./,
                 STATE_VALUE,
                 :append_input_to_buffer

      transition STATE_VALUE,
                 /[^\]]/,
                 nil,
                 :append_input_to_buffer

      transition [STATE_VALUE_BEGIN, STATE_VALUE],
                 /\]/,
                 STATE_VALUE_END,
                 :set_property_value

      transition STATE_VAR_END,
                 nil,
                 STATE_GAME_END,
                 :end_game

      transition [STATE_NODE_BEGIN, STATE_VALUE_END],
                 /\)/,
                 STATE_VAR_END,
                 lambda {|stm| stm.end_node; stm.end_variation }

      transition STATE_VAR_END,
                 /\)/,
                 STATE_VAR_END,
                 :end_variation

      transition [STATE_BEGIN, STATE_GAME_BEGIN, STATE_NODE_BEGIN, STATE_VAR_BEGIN, STATE_VAR_END, STATE_PROP_NAME_BEGIN, STATE_PROP_NAME, STATE_VALUE_END],
                 /[^\s]/,
                 STATE_INVALID,
                 :report_error

    end

  end
end
