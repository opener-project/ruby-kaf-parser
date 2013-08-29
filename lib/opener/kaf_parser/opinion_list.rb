module Opener
  module KafParser
    ##
    # The OpinionList class can be used to create a list of opinions and their
    # expressions expressions from a parsed KAF document.
    #
    # @!attribute [r] document
    #  @return [Opener::KafParser::Element::Document]
    #
    class OpinionList
      attr_reader :document

      ##
      # @param [Opener::KafParser::Element::Document] document
      #
      def initialize(document)
        @document = document
      end

      ##
      # @return [Array]
      #
      def construct
        opinions     = []
        text_nodes   = TextList.new(document).construct
        word_mapping = create_word_mapping(text_nodes)
        term_mapping = create_term_mapping

        document.opinions.each do |opinion|
          expression = []

          opinion.expression.targets.each do |target|
            word_id = term_mapping[target]

            expression << word_mapping[word_id]
          end

          opinions << create_opinion_node(opinion, expression)
        end

        return opinions
      end

      private

      ##
      # @param [Opener::KafParser::Element::OpinionExpression] opinion
      # @param [Array<Opener::KafParser::Node::Text>] expression
      # @return [Opener::KafParser::Node::Opinion]
      #
      def create_opinion_node(opinion, expression)
        return Node::Opinion.new(
          :id         => opinion.id,
          :expression => expression,
          :polarity   => opinion.expression.polarity,
          :strength   => opinion.expression.strength
        )
      end

      ##
      # @param [Array<Opener::KafParser::Node::Text>] nodes
      # @return [Hash]
      #
      def create_word_mapping(nodes)
        return nodes.each_with_object({}) do |node, hash|
          hash[node.id] = node
        end
      end

      ##
      # @return [Hash]
      #
      def create_term_mapping
        return document.terms.each_with_object({}) do |term, hash|
          hash[term.id] = term.targets[0]
        end
      end
    end # OpinionList
  end # KafParser
end # Opener
