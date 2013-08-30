require 'spec_helper'

describe Opener::KafParser::Presenter::Text do
  let(:presenter) { Opener::KafParser::Presenter::HTML.new }

  let :ast do
    document_node(
      :children => [
        text_node(:value => 'Hello,', :offset => 0, :pos => 'Q'),
        opinion_node(
          :polarity => 'negative',
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

  example 'present an AST as a block of HTML' do
    output   = presenter.present(ast)
    expected = <<-EOF
<span class="text" data-pos="Q">Hello,</span>
<span class="opinion" data-polarity="negative">
<span class="whitespace">&nbsp;</span>
<span class="text">you</span>
<span class="whitespace">&nbsp;</span>
<span class="text">are</span>
<span class="whitespace">&nbsp;</span>
<span class="text">doing</span>
<span class="whitespace">&nbsp;</span>
<span class="text">great</span>
</span>
    EOF

    output.should == expected.strip.gsub("\n", '')
  end
end
