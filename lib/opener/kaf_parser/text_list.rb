module Opener
  module KafParser
    ##
    # The TextList class takes a parsed KAF document and returns a list of
    # text nodes containing some basic information such as the polarity, Part
    # Of Speech, etc.
    #
    # @!attribute [r] document
    #  @return [Opener::KafParser::Element::Document]
    #
    class TextList
      attr_reader :document

      ##
      # @param [Opener::KafParser::Element::Document] document
      #
      def initialize(document)
        @document = document
      end

      ##
      # Constructs the list of words and returns it as an Array of
      # {Opener::KafParser::Node::Text} instances.
      #
      # @return [Array<Opener::KafParser::Node::Text>]
      #
      def construct
        attributes = []
        wf_indexes = {}

        construct_word_forms(attributes, wf_indexes)
        construct_terms(attributes, wf_indexes)

        return create_nodes(attributes)
      end

      private

      ##
      # @param [Array<Hash>] attributes
      # @param [Hash] indexes
      #
      def construct_word_forms(attributes, indexes)
        document.word_forms.each do |wf|
          attributes << text_attributes(wf)

          indexes[wf.id] = calculate_index(attributes)
        end
      end

      ##
      # @param [Array<Hash>] attributes
      # @param [Hash] indexes
      #
      def construct_terms(attributes, indexes)
        document.terms.each do |term|
          term.targets.each do |target|
            index = indexes[target]

            attributes[index][:pos] = term.pos

            if term.sentiment
              attributes[index][:polarity] = term.sentiment.polarity
              attributes[index][:modifier] = term.sentiment.modifier
            end
          end
        end
      end

      ##
      # @param [Array] attributes
      # @return [Fixnum]
      #
      def calculate_index(attributes)
        return attributes.length > 0 ? attributes.length - 1 : 0
      end

      ##
      # @param [Array<Hash>] attributes
      # @return [Array<Opener::KafParser::Node::Text>]
      #
      def create_nodes(attributes)
        return attributes.map { |attr| Node::Text.new(attr) }
      end

      ##
      # @param [Opener::KafParser::Element::WordForm] word
      # @return [Hash]
      #
      def text_attributes(word)
        return {
          :value    => word.text,
          :sentence => word.sentence,
          :id       => word.id,
          :length   => word.length,
          :offset   => word.offset
        }
      end
    end # TextList
  end # KafParser
end # Opener
