#!/usr/bin/ruby1.9.1

DATABASE_FILENAME = 'amigo.db'

#
# Init Database
#
require 'active_record'
ActiveRecord::Base.logger = Logger.new(STDOUT)
ActiveRecord::Base.establish_connection(adapter:'sqlite3',database:DATABASE_FILENAME)

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
