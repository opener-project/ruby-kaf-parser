module Opener
  module KafParser
    module Node
      ##
      # Base class for the various Node classes, provides some common
      # boilerplate code.
      #
      class Base
        ##
        # @param [Hash] attributes
        #
        def initialize(attributes = {})
          attributes.each do |key, value|
            instance_variable_set("@#{key}", value) if respond_to?(key)
          end

          after_initialize if respond_to?(:after_initialize)
        end
      end # Base
    end # Node
  end # KafParser
end # Opener
