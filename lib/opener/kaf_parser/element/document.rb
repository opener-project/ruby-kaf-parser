module Opener
  module KafParser
    module Element
      ##
      # The Document class represents the root node of a KAF document and
      # contains the various sub nodes.
      #
      # @!attribute [rw] header
      #  @return [Opener::KafParser::Element::Header]
      #
      # @!attribute [rw] language
      #  @return [String]
      #
      # @!attribute [rw] opinions
      #  @return [Array]
      #
      # @!attribute [rw] properties
      #  @return [Array]
      #
      # @!attribute [rw] terms
      #  @return [Array]
      #
      # @!attribute [rw] version
      #  @return [String]
      #
      # @!attribute [rw] word_forms
      #  @return [Array]
      #
      class Document < Base
        attr_accessor :header,
          :language,
          :opinions,
          :properties,
          :terms,
          :version,
          :word_forms

        ##
        # Called after a new instance of the class is created.
        #
        def after_initialize
          @opinions   ||= []
          @properties ||= []
          @terms      ||= []
          @word_forms ||= []
        end
      end # Document
    end # Element
  end # KafParser
end # Opener
