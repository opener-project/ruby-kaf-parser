require 'spec_helper'

describe Opener::KafParser::Element::Base do
  let(:constant) { Opener::KafParser::Element::Base }

  it 'should set options via the constructor' do
    klass = Class.new(constant) do
      attr_reader :numbers
    end

    klass.new(:numbers => [10]).numbers.should == [10]
  end

  it 'should call #after_initialize if it exists' do
    klass = Class.new(constant) do
      attr_reader :number

      def after_initialize
        @number = 10
      end
    end

    klass.new.number.should == 10
  end
end
