module Opener
  module KafParser
    ##
    # The TextConstructor class takes a list of {Opener::KafParser::AST::Text}
    # instances and builds a String out of it containing the correct whitespace
    # between the different words.
    #
    # @!attribute [r] nodes
    #  @return [Array<Opener::KafParser::AST::Text>]
    #
    class TextConstructor
      attr_reader :nodes

      ##
      # @param [Array<Opener::KafParser::AST::Text>] nodes
      #
      def initialize(nodes)
        @nodes = nodes
      end

      ##
      # @return [String]
      #
      def construct
        offset = 0
        string = ''

        nodes.each do |node|
          diff = node.offset - offset

          if diff > 0
            string << ' ' * diff
          end

          string << node.value

          offset = calculate_offset(node)
        end

        return string
      end

      ##
      # @param [Opener::KafParser::AST::Text] node
      # @return [Numeric]
      #
      def calculate_offset(node)
        return node.offset + node.length
      end
    end # TextConstructor
  end # KafParser
end # Opener
