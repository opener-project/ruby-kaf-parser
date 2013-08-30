module Opener
  module KafParser
    module Presenter
      ##
      # The HTML presenter takes an AST and turns it into a block of HTML where
      # each word is wrapped in a tag and has various meta information (e.g.
      # the polarity) assigned to it.
      #
      # Basic usage:
      #
      #     parser    = Opener::KafParser::Parser.new
      #     ast       = parser.parse('...')
      #     presenter = Opener::KafParser::Presenter::HTML.new
      #
      #     puts presenter.present(ast)
      #
      # ## Output
      #
      # The output is a set of span tags for each set of characters, span tags
      # for whitespace and a set of span tags that group opinion expressions.
      # Each span tag has a class indicating the type ("text", "opinion", etc)
      # and a set of `data-*` attributes containing data such as the polarity.
      # For example, the ID of a text node would be stored in `data-id`, the
      # polarity in `data-polarity` and so forth.
      #
      class HTML < Text
        ##
        # @return [String]
        #
        SPACE = '&nbsp;'

        ##
        # @return [Array]
        #
        TYPES_WHITELIST = [String, Numeric]

        ##
        # Presents the AST as a collection of HTML tags.
        #
        # @param [Opener::KafParser::AST::Base] ast
        # @return [String]
        #
        def present(ast)
          offset  = 0
          builder = Builder::XmlMarkup.new

          render_ast(ast, offset, builder)

          return builder.target!
        end

        private

        ##
        # @param [Opener::KafParser::AST::Base] ast
        # @param [Numeric] offset
        # @param [Builder::XmlMarkup] builder
        #
        def render_ast(ast, offset, builder)
          ast.children.each do |node|
            if node.text?
              offset = render_node(node, offset, builder)
            else
              render_span(node, builder) do |sub_builder|
                render_ast(node, offset, builder)
              end
            end
          end
        end

        ##
        # @see #render_ast
        #
        def render_node(node, offset, builder)
          diff = node.offset - offset

          if diff > 0
            builder.span(:class => 'whitespace') do |sub_builder|
              sub_builder << SPACE * diff
            end
          end

          render_span(node, builder)

          return calculate_offset(node)
        end

        ##
        # @param [Opener::KafParser::AST::Base] node
        # @param [Builder::XmlMarkup] builder
        #
        def render_span(node, builder)
          attrs = {'class' => node.type}

          # Only store simple values in the HTML attributes.
          node.attributes.each do |key, value|
            if TYPES_WHITELIST.include?(value.class)
              attrs["data-#{key}"] = value
            end
          end

          if block_given?
            builder.span(node.value, attrs) { |sub_builder| yield sub_builder }
          else
            builder.span(node.value, attrs)
          end
        end
      end # HTML
    end # Presenter
  end # KafParser
end # Opener
