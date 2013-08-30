module Opener
  module KafParser
    module AST
      ##
      # The Opinion node class contains information about a opinion, the
      # expression, polarity and more. The nodes that make up the expression of
      # the opinion are stored in the `children` method.
      #
      # @!attribute [rw] id
      #  @return [String]
      #
      # @!attribute [rw] holder The nodes that make up the opinion holder.
      #  @return [Array]
      #
      # @!attribute [rw] target The nodes that make up the opinion target.
      #  @return [Array]
      #
      # @!attribute [rw] polarity
      #  @return [String]
      #
      # @!attribute [rw] strength
      #  @return [Numeric]
      #
      class Opinion < Base
        attr_accessor :id, :holder, :target, :polarity, :strength

        ##
        # Called after a new instance of this class is created.
        #
        def after_initialize
          @type = :opinion

          @holder ||= []
          @target ||= []
        end
      end # Opinion
    end # AST
  end # KafParser
end # Opener
