module Opener
  module KafParser
    module AST
      ##
      # The Document node class contains information about a `<KAF>` tag and
      # all the child nodes.
      #
      # @!attribute [rw] language
      #  @return [String]
      #
      # @!attribute [rw] version
      #  @return [String]
      #
      class Document < Base
        attr_accessor :language, :version

        ##
        # Called after a new instance of this class is created.
        #
        def after_initialize
          @type = :document
        end

        ##
        # @return [Hash]
        #
        def attributes
          return {:language => language, :version => version}
        end
      end # Document
    end # AST
  end # KafParser
end # Opener
