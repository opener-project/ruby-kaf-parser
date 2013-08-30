require 'spec_helper'

describe Opener::KafParser::Presenter::Text do
  let(:presenter) { Opener::KafParser::Presenter::Text.new }

  let :ast do
    document_node(
      :children => [
        text_node(:value => 'Hello,', :offset => 0),
        opinion_node(
          :children => [
            text_node(:value => 'you', :offset => 7),
            text_node(:value => 'are', :offset => 11),
            text_node(:value => 'doing', :offset => 15),
            text_node(:value => 'great', :offset => 21),
          ]
        )
      ]
    )
  end

  example 'present an AST as a String' do
    presenter.present(ast).should == 'Hello, you are doing great'
  end
end
