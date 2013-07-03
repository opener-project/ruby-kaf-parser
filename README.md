# Ruby KAF Parser

This repository contains the source code of the opener-kaf-parser, a simple and
fast KAF parser based on Nokogiri. The KAF parser is a stack based parser that
uses the SAX parsing API of Nokogiri, thus it should (in theory) be able to
handle large KAF files without too much trouble.

## Usage

Basic usage is as following:

    require 'opener/kaf_parser'

    parser   = Opener::KafParser::Parser.new
    input    = '...'
    document = parser.parse(input)

    puts document.word_forms.first.text # => "Something ..."

For more information see the documentation of `Opener::KafParser::SaxParser`.

## Requirements

* Ruby 1.9.2 or newer
* libxml2 (newer versions of Nokogiri ship libxml themselves)

## Installation:

Installing as a Gem:

    gem install opener-kaf-parser

Using Bundler:

    gem 'opener-kaf-parser',
      :git => 'git@github.com:opener-project/ruby-kaf-parser'
