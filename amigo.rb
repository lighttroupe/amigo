#!/usr/bin/ruby1.9.1

$LOAD_PATH << '.'
$LOAD_PATH << 'models'
$LOAD_PATH << 'languages'
$LOAD_PATH << 'utils'
$LOAD_PATH << 'gui'

DATABASE_FILENAME = 'amigo.db'

# So this file can be run from anywhere
Dir.chdir(File.dirname(File.expand_path(File.symlink?(__FILE__) ? File.readlink(__FILE__) : __FILE__)))

require 'rubygems'		# required for latest gtk and activerecord until they're available via apt-get
require 'logger'

#
# Init Database
#
puts 'Loading Libraries...'
gem 'activerecord', '= 3.2.13'
require 'active_record'

puts 'Opening Database...'
ActiveRecord::Base.logger = Logger.new(STDOUT)
ActiveRecord::Base.establish_connection(adapter:'sqlite3',database:DATABASE_FILENAME)

#
# Init Languages
#
puts 'Loading Languages...'
require 'base_model'
require 'spanish_english'		# joiner
require 'spanish_word'
require 'english_word'
require 'spanish_verb_conjugation'
require 'language_english'
require 'language_spanish'

#
# Init GUI
#
puts 'Loading Gtk...'
require 'gtk3'
require 'addons'

#
# Create Windows
#
puts 'Creating Windows...'

require 'dictionary_window'
$dictionary_window = DictionaryWindow.new(LanguageEnglish.new, LanguageSpanish.new)

#
# Run
#
begin
	puts 'Running...'
	$dictionary_window.show
	Gtk.main
ensure
	puts 'Shutdown...'
end
