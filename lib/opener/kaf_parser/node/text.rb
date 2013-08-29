module Opener
  module KafParser
    module Node
      ##
      # The Text class contains information about a set of non whitespace
      # characters/words such as the polarity and Part Of Speech.
      #
      #
      # @!attribute [r] value
      #  @return [String]
      #
      # @!attribute [r] id
      #  @return [String]
      #
      # @!attribute [r] sentence
      #  @return [Numeric]
      #
      # @!attribute [r] polarity
      #  @return [String]
      #
      # @!attribute [r] strength
      #  @return [String]
      #
      # @!attribute [r] modifier
      #  @return [String]
      #
      # @!attribute [r] entity
      #  @return [String]
      #
      # @!attribute [r] opinion_expression_id
      #  @return [String]
      #
      # @!attribute [r] pos
      #  @return [String]
      #
      # @!attribute [r] offset
      #  @return [Numeric]
      #
      # @!attribute [r] length
      #  @return [Numeric]
      #
      class Text < Base
        attr_reader :value, :id, :sentence, :polarity, :strength,
          :modifier, :entity, :opinion_expression_id, :pos, :offset, :length

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
      end # Text
    end # Node
  end # KafParser
end # Opener
