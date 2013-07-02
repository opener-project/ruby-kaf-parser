module Opener
  module KafParser
    module Element
      ##
      # The WordForm class contains information about a single `<wf>` node.
      #
      # @!attribute [rw] id
      #  @return [String]
      #
      # @!attribute [rw] sentence
      #  @return [Numeric]
      #
      # @!attribute [rw] text
      #  @return [String]
      #
      # @!attribute [rw] length
      #  @return [Numeric]
      #
      # @!attribute [rw] offset
      #  @return [Numeric]
      #
      # @!attribute [rw] paragraph
      #  @return [Numeric]
      #
      class WordForm < Base
        attr_accessor :id, :sentence, :text, :length, :offset, :paragraph

        ##
        # Called after a new instance of the class is created.
        #
        def after_initialize
          unless @length
            @length ||= text ? text.length : 0
          end

          @offset ||= 0
        end
      end # WordForm
    end # Element
  end # KafParser
end # Opener
