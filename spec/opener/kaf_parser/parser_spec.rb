require 'spec_helper'

describe Opener::KafParser::Parser do
  before :all do
    parser    = Opener::KafParser::Parser.new
    @document = parser.parse(fixture('input.kaf'))
  end

  context 'root document' do
    it 'should parse the language' do
      @document.language.should == 'en'
    end

    it 'should parse the version' do
      @document.version.should == 'v1.opener'
    end
  end

  context 'linguistic processors' do
    it 'should correctly set the length' do
      @document.header.linguistic_processors.length.should == 3
    end

    it 'should set the layer of each processor' do
      layers = @document.header.linguistic_processors.map(&:layer)

      layers.should == %w{text terms opinions}
    end

    it 'set the correct details of an <lp> node' do
      node = @document.header.linguistic_processors[0].processors[0]

      node.name.should    == 'opennlp-en-tok'
      node.version.should == '1.0'

      node.time.year.should  == 2013
      node.time.month.should == 6
      node.time.day.should   == 27
    end
  end

  context 'word forms' do
    it 'should set the word ID' do
      @document.word_forms[0].id.should == 'w1'
    end

    it 'should set the sentence attribute' do
      @document.word_forms[0].sentence.should == 1
    end

    it 'should set the paragraph attribute' do
      @document.word_forms[0].paragraph.should == 1
    end

    it 'should set the offset' do
      @document.word_forms[0].offset.should == 0
    end

    it 'should set the length' do
      @document.word_forms[0].length.should == 3
    end

    it 'should set the text' do
      @document.word_forms[0].text.should == 'You'
    end
  end
end
