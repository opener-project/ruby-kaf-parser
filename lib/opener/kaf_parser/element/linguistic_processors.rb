module Opener
  module KafParser
    module Element
      ##
      # The LinguisticProcessors class contains information about a
      # `<linguistic-processors>` node.
      #
      # @!attribute [rw] layer
      #  @return [String]
      #
      # @!attribute [rw] processors
      #  @return [Array]
      #
      class LinguisticProcessors < Base
        attr_accessor :layer, :processors

        ##
        # Called after a new instance of the class is created.
        #
        def after_initialize
          @processors ||= []
        end
      end # LinguisticProcessors
    end # Element
  end # KafParser
end # Opener
