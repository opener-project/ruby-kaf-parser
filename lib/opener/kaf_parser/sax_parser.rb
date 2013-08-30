module Opener
  module KafParser
    ##
    # The SaxParser class is a Nokogiri and stack based parser for parsing KAF
    # documents.
    #
    # @!attribute [r] document
    #  @return [Opener::KafParser::Element::Document]
    #
    class SaxParser < Nokogiri::XML::SAX::Document
      attr_reader :document

      ##
      # @see Nokogiri::XML::SAX::Document#initialize
      #
      def initialize(*args)
        super

        @stack             = []
        @attributes        = []
        @document          = nil
        @characters        = ''
        @targets           = []
        @buffer_characters = false
        @buffer_targets    = false
        @word_mapping      = {}
        @term_mapping    = {}
      end

      ##
      # Called at the start of an XML element. This method delegates the work
      # to individual method calls based on the node name.
      #
      # @param [String] name The name of the element.
      # @param [Array] attributes
      #
      def start_element(name, attributes)
        callback   = 'on_' + callback_name(name)
        attributes = associate_attributes(attributes)

        execute_callback(callback, attributes)
      end

      ##
      # @param [String] name The name of the element.
      #
      def end_element(name)
        callback = 'after_' + callback_name(name)

        execute_callback(callback)
      end

      ##
      # Processes the characters of an XML node.
      #
      # @param [String] text
      #
      def characters(text)
        @characters << text if @buffer_characters
      end

      ##
      # Processes a `<KAF>` node.
      #
      # @param [Hash] attr
      #
      def on_kaf(attr)
        @stack << AST::Document.new(
          :language => attr.fetch('xml:lang', 'en'),
          :version  => attr['version']
        )
      end

      ##
      # @see #on_kaf
      #
      def after_kaf
        @document = @stack.pop
      end
      ##
      # Processes a `<wf>` node.
      #
      # @param [Hash] attr
      #
      def on_wf(attr)
        @stack << AST::Text.new(
          :id        => attr['wid'],
          :sentence  => attr['sent'].to_i,
          :offset    => attr['offset'].to_i,
          :length    => attr['length'].to_i,
          :paragraph => attr['para'].to_i
        )

        @buffer_characters = true
      end

      ##
      # @see #on_wf
      #
      def after_wf
        wf       = @stack.pop
        wf.value = @characters

        current_object.children << wf

        @word_mapping[wf.id] = wf

        reset_character_buffer
      end

      ##
      # Processes a `<term>` node.
      #
      # @param [Hash] attr
      #
      def on_term(attr)
        @attributes << attr

        @buffer_targets = true
      end

      ##
      # @see #on_term
      #
      def after_term
        attrs, sentiment = @attributes

        @targets.each do |target|
          word = @word_mapping[target]

          word.morphofeat = attrs['morphofeat']
          word.word_type  = attrs['type']
          word.pos        = attrs['pos']

          if sentiment
            word.sentiment_modifier = sentiment['sentiment_modifier']
            word.polarity           = sentiment['polarity']
          end

          # Map the term IDs to the word form node.
          @term_mapping[attrs['tid']] = word
        end

        reset_target_buffer
        reset_attributes_buffer
      end

      ##
      # Processes a `<target>` node.
      #
      # @param [Hash] attr
      #
      def on_target(attr)
        @targets << attr['id'] if @buffer_targets
      end

      ##
      # Processes a `<sentiment>` node.
      #
      # @param [Hash] attr
      #
      def on_sentiment(attr)
        @attributes << attr
      end

      ##
      # Processes a `<opinion>` node.
      #
      # @param [Hash] attr
      #
      def on_opinion(attr)
        @stack << AST::Opinion.new(:id => attr['oid'])
      end

      ##
      # @see #on_opinion
      #
      def after_opinion
        opinion = @stack.pop
        remove  = opinion.children.each_with_object({}) do |node, hash|
          hash[node.id] = true
        end

        # Insert the opinion node before the first node of the expression.
        first_index = current_object.children.index(opinion.children[0])

        current_object.children.insert(first_index, opinion)

        # Remove the word nodes from the current object since they have been
        # moved into the opinion node.
        current_object.children.each do |node|
          if node.is_a?(AST::Text) and remove.key?(node.id)
            current_object.children.delete(node)
          end
        end
      end

      ##
      # @param [Hash] attr
      #
      def on_opinion_holder(attr)
        @buffer_targets = true
      end

      ##
      # @see #on_opinion_holder
      #
      def after_opinion_holder
        @targets.each do |target|
          current_object.holder << @term_mapping[target]
        end

        reset_target_buffer
      end

      ##
      # @param [Hash] attr
      #
      def on_opinion_target(attr)
        @buffer_targets = true
      end

      ##
      # @see #on_opinion_target
      #
      def after_opinion_target
        @targets.each do |target|
          current_object.target << @term_mapping[target]
        end

        reset_target_buffer
      end

      ##
      # Processes an `<opinion-expression>` node.
      #
      # @param [Hash] attr
      #
      def on_opinion_expression(attr)
        current_object.polarity = attr['polarity']
        current_object.strength = attr['strength'].to_i

        @buffer_targets = true
      end

      ##
      # @see #on_opinion_expression
      #
      def after_opinion_expression
        @targets.each do |target|
          current_object.children << @term_mapping[target]
        end

        reset_target_buffer
      end

      ##
      # Processes a `<property>` node.
      #
      # @param [Hash] attr
      #
      def on_property(attr)
        @attributes << attr

        @buffer_targets = true
      end

      ##
      # @see #on_property
      #
      def after_property
        attrs = @attributes.pop

        @targets.each do |target|
          @term_mapping[target].property = attrs['lemma']
        end

        reset_attributes_buffer
        reset_target_buffer
      end

      private

      ##
      # Returns a callback name for the given XML node name.
      #
      # @param [String] name
      # @return [String]
      #
      def callback_name(name)
        return name.gsub(/([^A-Z]+)([A-Z]+)/, '\\1_\\2').downcase
      end

      ##
      # @param [String] name
      # @param [Array] args
      #
      def execute_callback(name, *args)
        send(name, *args) if respond_to?(name)
      end

      ##
      # Converts an Array of attributes into a Hash.
      #
      # @param [Array] attributes
      # @return [Hash]
      #
      def associate_attributes(attributes)
        return attributes.each_with_object({}) do |pair, hash|
          hash[pair[0]] = pair[1]
        end
      end

      ##
      # @return [Mixed]
      #
      def current_object
        return @stack.last
      end

      ##
      # Resets the character buffer and disables buffering.
      #
      def reset_character_buffer
        @buffer_characters = false
        @characters        = ''
      end

      ##
      # Resets the target buffer and disables buffering.
      #
      def reset_target_buffer
        @buffer_targets = false
        @targets        = []
      end

      ##
      # Resets the attributes buffer.
      #
      def reset_attributes_buffer
        @attributes = []
      end
    end # SaxParser
  end # KafParser
end # Opener
