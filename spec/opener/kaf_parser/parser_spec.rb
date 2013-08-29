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
    let(:word_form) { @document.word_forms[0] }

    it 'should set the word ID' do
      word_form.id.should == 'w1'
    end

    it 'should set the sentence attribute' do
      word_form.sentence.should == 1
    end

    it 'should set the paragraph attribute' do
      word_form.paragraph.should == 1
    end

    it 'should set the offset' do
      word_form.offset.should == 0
    end

    it 'should set the length' do
      word_form.length.should == 3
    end

    it 'should set the text' do
      word_form.text.should == 'You'
    end
  end

  context 'terms' do
    let(:term) { @document.terms[17] }

    it 'should set the term ID' do
      term.id.should == 't18'
    end

    it 'should set the type' do
      term.type.should == 'open'
    end

    it 'should set the lemma' do
      term.lemma.should == 'need'
    end

    it 'should set the POS' do
      term.pos.should == 'V'
    end

    it 'should set the morphofeat' do
      term.morphofeat.should == 'VB'
    end

    it 'should set the targets' do
      term.targets.should == [@document.word_forms[17].id]
    end

    it 'should set the sentiment' do
      term.sentiment.polarity.should        == 'negative'
      term.sentiment.resource.empty?.should == false
    end
  end

  context 'opinions' do
    let(:opinion) { @document.opinions[5] }

    it 'should set the opinion ID' do
      opinion.id.should == 'o_6'
    end

    it 'should set the expression' do
      opinion.expression.polarity.should == 'positive'
      opinion.expression.strength.should == 1
    end

    it 'should set the expression targets' do
      opinion.expression.targets.should == (207..215).map { |n| "t#{n}" }
    end

    it 'should set the opinion holder' do
      @document.opinions[0].holder.should == ['t1']
    end

    it 'should set the opinion target' do
      @document.opinions[0].target.should == ['t1']
    end
  end
end
