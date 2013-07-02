module Opener
  module KafParser
    ##
    # The Parser class acts as a slightly more user friendly interface around
    # the Nokogiri SAX based parser.
    #
    class Parser
      ##
      # Parses the input KAF/XML and returns an instance of
      # {Opener::KafParser::Element::Document}.
      #
      # @param [String] input The XML/KAF to parse.
      # @return [Opener::KafParser::Element::Document]
      #
      def parse(input)
        sax_parser      = SaxParser.new
        nokogiri_parser = Nokogiri::XML::SAX::Parser.new(sax_parser)

        nokogiri_parser.parse(input)

        return sax_parser.document
      end
    end # Parser
  end # KafParser
end # Opener
