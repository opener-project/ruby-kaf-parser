module Opener
  module KafParser
    module AST
      ##
      # Node class that contains information about a set of characters such as
      # the polarity and POS.
      #
      # @!attribute [rw] id
      #  @return [Numeric]
      #
      # @!attribute [rw] sentence
      #  @return [Numeric]
      #
      # @!attribute [rw] paragraph
      #  @return [Numeric]
      #
      # @!attribute [rw] offset
      #  @return [Numeric]
      #
      # @!attribute [rw] length
      #  @return [Numeric]
      #
      # @!attribute [r] word_type
      #  @return [String]
      #
      # @!attribute [r] pos
      #  @return [String]
      #
      # @!attribute [rw] morphofeat
      #  @return [String]
      #
      # @!attribute [rw] sentiment_modifier
      #  @return [String]
      #
      # @!attribute [rw] polarity
      #  @return [String]
      #
      # @!attribute [rw] property
      #  @return [String]
      #
      class Text < Base
        attr_accessor :id, :sentence, :paragraph, :offset, :length, :word_type,
          :pos, :morphofeat, :sentiment_modifier, :polarity, :property

        ##
        # Called after a new instance of this class is created.
        #
        def after_initialize
          @type = :text

          @length ||= value.length
        end

        ##
        # @return [Hash]
        #
        def attributes
          return {
            :id                 => id,
            :sentence           => sentence,
            :paragraph          => paragraph,
            :offset             => offset,
            :length             => length,
            :word_type          => word_type,
            :pos                => pos,
            :morphofeat         => morphofeat,
            :sentiment_modifier => sentiment_modifier,
            :polarity           => polarity,
            :property           => property
          }
        end
      end # Generic
    end # AST
  end # KafParser
end # Opener
