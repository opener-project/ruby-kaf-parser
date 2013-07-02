module Opener
  module KafParser
    module Element
      ##
      # The Property class contains information about a single `<property>`
      # node.
      #
      class Property < Base
        attr_accessor :id, :type, :references

        ##
        # Called after a new instance of the class is created.
        #
        def after_initialize
          @references ||= []
        end
      end # Property
    end # ELement
  end # KafParser
end # Opener
