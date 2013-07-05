#!/usr/bin/ruby1.9.1

#
# Init Database
#
require 'active_record'
ActiveRecord::Base.establish_connection(adapter:'sqlite3',database:'amigo.db')
ActiveRecord::Base.logger = Logger.new(STDOUT)

$LOAD_PATH << 'models'

require 'base_model'
require 'spanish_english'		# joiner
require 'spanish_word'
require 'english_word'
require 'spanish_verb_conjugation'

# puts SpanishWord.last.spanish_verb_conjugations.map(&:conjugation)
puts SpanishWord.last.english_words.map(&:word)

#
# Init GUI
#

#
# Run
#
