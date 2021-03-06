# Ruby KAF Parser

This repository contains the source code of the opener-kaf-parser, a simple and
fast KAF parser based on Nokogiri. The KAF parser is a stack based parser that
uses the SAX parsing API of Nokogiri, thus it should (in theory) be able to
handle large KAF files without too much trouble.

## Usage

Create a parser instance and parse some KAF:

    require 'opener/kaf_parser'

    parser = Opener::KafParser::Parser.new
    ast    = parser.parse('...')

The return value is a list of `Opener::KafParser::AST` nodes which behave like
S expressions (and are formatted that way when calling `#inspect` on them).
Currently there are 3 node types:

* document
* text
* opinion

The latter groups a set of text nodes together that make up the opinion.

To iterate over these nodes you'd do something along the lines of the
following:

    ast.language # => "en"

    ast.children.each do |node|
      if node.type == :text
        puts "Word: #{node.inspect}"
      else
        puts "Opinion: #{node.inspect}"
      end
    end

## Presenting Text

To present an AST/text you can use one of the standard presenter classes. For
example, if you want to turn an AST in a regular Ruby String you can use the
Text presenter:

    ast       = parser.parse('...')
    presenter = Opener::KafParser::Presenter::Text.new

    puts presenter.present(ast) # => "Hello, you are doing great"

Currently the following presenters are available:

* `Opener::KafParser::Presenter::Text`
* `Opener::KafParser::Presenter::HTML`

## Requirements

* Ruby 1.9.3 or newer
* libxml2 (newer versions of Nokogiri ship libxml themselves)

## Installation:

Installing as a Gem:

    gem install opener-kaf-parser

Using Bundler:

    gem 'opener-kaf-parser',
      :git => 'git@github.com:opener-project/ruby-kaf-parser'