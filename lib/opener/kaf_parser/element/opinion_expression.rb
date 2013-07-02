module Opener
  module KafParser
    module Element
      ##
      # The OpinionExpression class contains information about a single
      # `<opinion_expression>` node.
      #
      # @!attribute [rw] polarity
      #  @return [String]
      #
      # @!attribute [rw] strength
      #  @return [Numeric]
      #
      # @!attribute [rw] targets
      #  @return [Array]
      #
      class OpinionExpression < Base
        attr_accessor :polarity, :strength, :targets

        ##
        # Called after a new instance of the class is created.
        #
        def after_initialize
          @targets ||= []
        end
      end # OpinionExpression
    end # Element
  end # KafParser
end # Opener
