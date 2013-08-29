module Opener
  module KafParser
    module Node
      ##
      # The Opinion class contains information about a single expression as
      # generated by {Opener::KafParser::OpinionList}.
      #
      # @!attribute [r] id
      #  @return [String]
      #
      # @!attribute [r] holder
      #  @return [Array<Opener::KafParser::Node::Text>]
      #
      # @!attribute [r] target
      #  @return [Array<Opener::KafParser::Node::Text>]
      #
      # @!attribute [r] expression
      #  @return [Array<Opener::KafParser::Node::Text>]
      #
      # @!attribute [r] polarity
      #  @return [String]
      #
      # @!attribute [r] strength
      #  @return [Numeric]
      #
      class Opinion < Base
        attr_reader :id, :holder, :target, :expression, :polarity, :strength

        ##
        # @return [TrueClass|FalseClass]
        #
        def positive?
          return polarity == 'positive'
        end

        ##
        # @return [TrueClass|FalseClass]
        #
        def negative?
          return polarity == 'negative'
        end
      end # Opinion
    end # Node
  end # KafParser
end # Opener
