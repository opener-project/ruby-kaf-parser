module Opener
  module KafParser
    module Element
      ##
      # The Header class contains information about the `<header>` node of a
      # KAF document.
      #
      # @!attribute [r] linguistic_processors
      #  @return [Array]
      #
      class Header < Base
        attr_accessor :linguistic_processors

        ##
        # Called after a new instance of the class is created.
        #
        def after_initialize
          @linguistic_processors ||= []
        end
      end # Header
    end # Element
  end # KafParser
end # Opener
