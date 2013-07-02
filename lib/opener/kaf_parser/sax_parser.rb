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
        @document          = nil
        @characters        = ''
        @targets           = []
        @buffer_characters = false
        @buffer_targets    = false
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
        @stack << Element::Document.new(
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
      # Processes the header element of the KAF document.
      #
      # @param [Hash] attr
      #
      def on_kaf_header(attr)
        @stack << Element::Header.new
      end

      ##
      # @see #on_kaf_header
      #
      def after_kaf_header
        header                = @stack.pop
        current_object.header = header
      end

      ##
      # Processes a linguistic processor node.
      #
      # @param [Hash] attr
      #
      def on_linguistic_processor(attr)
        @stack << Element::LinguisticProcessors.new(:layer => attr['layer'])
      end

      alias on_linguistic_processors on_linguistic_processor

      ##
      # @see on_linguistic_processor
      #
      def after_linguistic_processor
        processors = @stack.pop

        current_object.linguistic_processors << processors
      end

      alias after_linguistic_processors after_linguistic_processor

      ##
      # Processes an `<lp>` node.
      #
      # @param [Hash] attr
      #
      def on_lp(attr)
        @stack << Element::LinguisticProcessor.new(
          :time    => (Time.parse(attr['timestamp']) rescue nil),
          :version => attr['version'],
          :name    => attr['name']
        )
      end

      ##
      # @see #on_lp
      #
      def after_lp
        lp = @stack.pop

        current_object.processors << lp
      end

      ##
      # Processes a `<wf>` node.
      #
      # @param [Hash] attr
      #
      def on_wf(attr)
        @stack << Element::WordForm.new(
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
        wf      = @stack.pop
        wf.text = @characters

        current_object.word_forms << wf

        reset_character_buffer
      end

      ##
      # Processes a `<term>` node.
      #
      # @param [Hash] attr
      #
      def on_term(attr)
        @stack << Element::Term.new(
          :id         => attr['tid'],
          :lemma      => attr['lemma'],
          :morphofeat => attr['morphofeat'],
          :type       => attr['type'],
          :pos        => attr['pos']
        )

        @buffer_targets = true
      end

      ##
      # @see #on_term
      #
      def after_term
        term         = @stack.pop
        term.targets = @targets

        current_object.terms << term

        reset_target_buffer
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
        if current_object.respond_to?(:sentiment=)
          current_object.sentiment = Element::Sentiment.new(
            :polarity => attr['polarity'],
            :resource => attr['resource'],
            :modifier => attr['sentiment_modifier']
          )
        end
      end

      ##
      # Processes a `<property>` node.
      #
      # @param [Hash] attr
      #
      def on_property(attr)
        @stack << Element::Property.new(
          :type => attr['type'],
          :id   => attr['pid']
        )

        @buffer_targets = true
      end

      ##
      # @see #on_attr
      #
      def after_property
        prop            = @stack.pop
        prop.references = @targets

        current_object.properties << prop

        reset_target_buffer
      end

      ##
      # Processes a `<opinion>` node.
      #
      # @param [Hash] attr
      #
      def on_opinion(attr)
        @stack << Element::Opinion.new(:id => attr['oid'])
      end

      ##
      # @see #on_opinion
      #
      def after_opinion
        expression    = @stack.pop
        op            = @stack.pop
        op.expression = expression

        current_object.opinions << op
      end

      ##
      # Processes an `<opinion-expression>` node.
      #
      # @param [Hash] attr
      #
      def on_opinion_expression(attr)
        @stack << Element::OpinionExpression.new(
          :polarity => attr['polarity'],
          :strength => attr['strength']
        )

        @buffer_targets = true
      end

      ##
      # @see #on_opinion_expression
      #
      def after_opinion_expression
        @stack.last.targets = @targets

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
    end # SaxParser
  end # KafParser
end # Opener
