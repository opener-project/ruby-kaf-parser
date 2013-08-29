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
          exp        = opinion.expression
          expression = []
          holder     = []
          target     = []

          map_words(exp.targets, expression, term_mapping, word_mapping)
          map_words(opinion.holder, holder, term_mapping, word_mapping)
          map_words(opinion.target, target, term_mapping, word_mapping)

          opinions << create_opinion_node(opinion, expression, holder, target)
        end

        return opinions
      end

      private

      ##
      # @param [Array] source
      # @param [Array] destination
      # @param [Hash] term_mapping
      # @param [Hash] word_mapping
      #
      def map_words(source, destination, term_mapping, word_mapping)
        source.each do |id|
          destination << find_word(id, term_mapping, word_mapping)
        end
      end

      ##
      # @param [String] id
      # @param [Hash] term_mapping
      # @param [Hash] word_mapping
      # @return [Opener::KafParser::Node::Text]
      #
      def find_word(id, term_mapping, word_mapping)
        return word_mapping[term_mapping[id]]
      end

      ##
      # @param [Opener::KafParser::Element::OpinionExpression] opinion
      # @param [Array<Opener::KafParser::Node::Text>] expression
      # @param [Array<Opener::KafParser::Node::Text>] holder
      # @param [Array<Opener::KafParser::Node::Text>] target
      # @return [Opener::KafParser::Node::Opinion]
      #
      def create_opinion_node(opinion, expression, holder, target)
        return Node::Opinion.new(
          :id         => opinion.id,
          :expression => expression,
          :polarity   => opinion.expression.polarity,
          :strength   => opinion.expression.strength,
          :holder     => holder,
          :target     => target
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
