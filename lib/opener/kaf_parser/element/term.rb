module Opener
  module KafParser
    module Element
      ##
      # The Term class contains information about a single `<term>` node.
      #
      # @!attribute [rw] id
      #  @return [String]
      #
      # @!attribute [rw] lemma
      #  @return [String]
      #
      # @!attribute [rw] morphofeat
      #  @return [String]
      #
      # @!attribute [rw] type
      #  @return [String]
      #
      # @!attribute [rw] pos
      #  @return [String]
      #
      # @!attribute [rw] targets
      #  @return [Array]
      #
      # @!attribute [rw] sentiment
      #  @return [Opener::KafParser::Element::Sentiment]
      #
      class Term < Base
        attr_accessor :id,
          :lemma,
          :morphofeat,
          :pos,
          :sentiment,
          :targets,
          :type
      end # Term
    end # Element
  end # KafParser
end # Opener
