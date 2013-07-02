module Opener
  module KafParser
    module Element
      ##
      # The LinguisticProcessor class (not to be confused with
      # {Opener::KafParser::Element::LinguisticProcessors}) contains
      # information about a single `<lp>` node.
      #
      # @!attribute [rw] time
      #  @return [Time]
      #
      # @!attribute [rw] version
      #  @return [String]
      #
      # @!attribute [rw] name
      #  @return [String]
      #
      class LinguisticProcessor < Base
        attr_accessor :time, :version, :name
      end # LinguisticProcessor
    end # Element
  end # KafParser
end # Opener
