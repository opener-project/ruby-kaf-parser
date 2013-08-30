module Opener
  module KafParser
    module Presenter
      ##
      # The Text presenter class takes an AST and builds a plain Ruby string
      # containing the correct whitespace between various nodes.
      #
      class Text
        ##
        # @param [Opener::KafParser::AST::Base] ast
        # @return [String]
        #
        def present(ast)
          offset = 0
          buffer = ''

          render_ast(ast, offset, buffer)

          return buffer
        end

        private

        ##
        # @param [Opener::KafParser::AST::Base] ast
        # @param [Numeric] offset
        # @param [String] buffer
        #
        def render_ast(ast, offset, buffer)
          ast.children.each do |node|
            if node.text?
              offset = render_node(node, offset, buffer)
            else
              render_ast(node, offset, buffer)
            end
          end
        end

        ##
        # @param [Opener::KafParser::AST::Text] node
        # @param [Numeric] offset
        # @param [String] buffer
        # @return [Numeric]
        #
        def render_node(node, offset, buffer)
          diff = node.offset - offset

          if diff > 0
            buffer << ' ' * diff
          end

          buffer << node.value

          return calculate_offset(node)
        end

        ##
        # @param [Opener::KafParser::AST::Text] node
        # @return [Numeric]
        #
        def calculate_offset(node)
          return node.offset + node.length
        end
      end # Text
    end # Presenter
  end # KafParser
end # Opener
