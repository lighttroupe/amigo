#!/usr/bin/ruby1.9.1

require 'active_record'
ActiveRecord::Base.establish_connection(adapter:'sqlite3',database:'amigo.db')
ActiveRecord::Base.logger = Logger.new(STDOUT)

p ActiveRecord::VERSION

#require 'models/spanish_word'
#require 'models/english_word'

class BaseModel < ActiveRecord::Base
	set_inheritance_column 'not_used'
end

#CREATE TABLE 'spanish_word' (
#  'id' INTEGER PRIMARY KEY AUTOINCREMENT,
#  'type' INTEGER,
#  'word' TEXT
#);
class SpanishWord < BaseModel
	self.table_name = 'spanish_word'

	attr_accessible :word, :type

	has_many :spanish_english
	has_many :english_words, :through => :spanish_english
	has_many :spanish_verb_conjugations, :foreign_key => :word_id
end

#CREATE TABLE 'english_word' (
#  'id' INTEGER PRIMARY KEY AUTOINCREMENT,
#  'type' INTEGER,
#  'word' TEXT
#);
class EnglishWord < BaseModel
	self.table_name = 'english_word'
	set_inheritance_column 'not_used'

	attr_accessible :word, :type

	has_many :spanish_english
	has_many :spanish_words, :through => :spanish_english
end

#CREATE TABLE 'spanish_english' (
#  'id' INTEGER PRIMARY KEY AUTOINCREMENT,
#  'spanish_word_id' INTEGER,
#  'english_word_id' INTEGER
#);
class SpanishEnglish < BaseModel
	self.table_name = 'spanish_english'
	set_inheritance_column 'not_used'

	belongs_to :english_word
	belongs_to :spanish_word
end

#CREATE TABLE 'spanish_verb_conjugation' (
#  'id' INTEGER PRIMARY KEY AUTOINCREMENT,
#  'word_id' INTEGER,
#  'tense' INTEGER,
#  'person' INTEGER,
#  'conjugation' TEXT
#);
class SpanishVerbConjugation < BaseModel
	self.table_name = 'spanish_verb_conjugation'
	set_inheritance_column 'not_used'

	belongs_to :word, :class_name => 'SpanishWord'
end

# puts SpanishWord.last.spanish_verb_conjugations.map(&:conjugation)
puts SpanishWord.last.english_words.map(&:word)
