module Opener
  module KafParser
    module Element
      ##
      # The Opinion class contains information about a single `<opinion>` node.
      #
      # @!attribute [rw] id
      #  @return [String]
      #
      # @!attribute [rw] expression
      #  @return [Opener::KafParser::Element::OpinionExpression]
      #
      # @!attribute [rw] holder
      #  @return [Array]
      #
      # @!attribute [rw] target
      #  @return [Array]
      #
      class Opinion < Base
        attr_accessor :id, :holder, :target, :expression
      end # Opinion
    end # Element
  end # KafParser
end # Opene
