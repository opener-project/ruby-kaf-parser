module Opener
  module KafParser
    module Element
      ##
      # The Sentiment class contains information about a single `<sentiment>`
      # node.
      #
      # @!attribute [rw] polarity
      #  @return [String]
      #
      # @!attribute [rw] resource
      #  @return [String]
      #
      # @!attribute [rw] modifier
      #  @return [String]
      #
      class Sentiment < Base
        attr_accessor :polarity, :resource, :modifier
      end # Sentiment
    end # Element
  end # KafParser
end # Opener
