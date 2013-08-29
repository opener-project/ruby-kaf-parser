[![Build Status](https://drone.io/github.com/opener-project/ruby-kaf-parser/status.png)](https://drone.io/github.com/opener-project/ruby-kaf-parser/latest)

# Ruby KAF Parser

This repository contains the source code of the opener-kaf-parser, a simple and
fast KAF parser based on Nokogiri. The KAF parser is a stack based parser that
uses the SAX parsing API of Nokogiri, thus it should (in theory) be able to
handle large KAF files without too much trouble.

## Usage

Basic low level parsing is as following:

    require 'opener/kaf_parser'

    parser   = Opener::KafParser::Parser.new
    input    = '...'
    document = parser.parse(input)

    puts document.word_forms.first.text # => "Something ..."

There are also a few high level classes that let you reconstruct parts of the
original text, retrieve opinions and retrieving lists of words and their
polarity. For example, to get a list of the opinions you'd do the following:

    # ...

    document    = parser.parse(input)
    constructor = Opener::KafParser::OpinionList.new(document)
    opinions    = constructor.construct

    opinions[0].polarity                # => "positive"
    opinions[0].expression.map(&:value) # => ["You", "did", "great"]

## Requirements

* Ruby 1.9.3 or newer
* libxml2 (newer versions of Nokogiri ship libxml themselves)

## Installation:

Installing as a Gem:

    gem install opener-kaf-parser

Using Bundler:

    gem 'opener-kaf-parser',
      :git => 'git@github.com:opener-project/ruby-kaf-parser'
