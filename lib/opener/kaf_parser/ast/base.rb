module Opener
  module KafParser
    module AST
      ##
      # Base node class that provides some common boilerplate for the various
      # other node classes.
      #
      # @!attribute [rw] type
      #  @return [Symbol]
      #
      # @!attribute [rw] value
      #  @return [String]
      #
      # @!attribute [rw] children
      #  @return [Array<Opener::KafParser::AST::Base>]
      #
      class Base
        attr_accessor :type, :value, :children

        ##
        # @param [Hash] attributes
        #
        def initialize(attributes = {})
          attributes.each do |key, value|
            instance_variable_set("@#{key}", value) if respond_to?(key)
          end

          @children ||= []
          @type     ||= :generic

          after_initialize if respond_to?(:after_initialize)
        end

        ##
        # @return [String]
        #
        def inspect(indent = 0)
          spaces       = ' ' * indent
          child_values = children.map { |c| c.inspect(indent + 2) }
          segments     = ["#{spaces}(#{type}"]

          if value
            segments << "#{value.inspect}"
          end

          unless child_values.empty?
            segments << "\n#{child_values.join("\n")}"
          end

          return segments.join(' ') + ')'
        end

        ##
        # @return [Hash]
        #
        def attributes
          return {}
        end

        ##
        # @return [TrueClass|FalseClass]
        #
        def text?
          return type == :text
        end

        ##
        # @return [TrueClass|FalseClass]
        #
        def opinion?
          return type == :opinion
        end
      end # Base
    end # AST
  end # KafParser
end # Opener
