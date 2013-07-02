module Opener
  module KafParser
    module Element
      ##
      # Base element class providing convenience methods re-used in the various
      # element classes.
      #
      class Base
        ##
        # @param [Hash] options
        #
        def initialize(options = {})
          options.each do |key, value|
            instance_variable_set("@#{key}", value)
          end

          after_initialize if respond_to?(:after_initialize)
        end
      end # Base
    end # Element
  end # KafParser
end # Opener
