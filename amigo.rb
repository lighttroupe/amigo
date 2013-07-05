#!/usr/bin/ruby1.9.1

DATABASE_FILENAME = 'amigo.db'

# So this file can be run from anywhere
Dir.chdir(File.dirname(File.expand_path(File.symlink?(__FILE__) ? File.readlink(__FILE__) : __FILE__)))		# So that this file can be run from anywhere

require 'rubygems'		# required for gtk3 until it's available via apt-get

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

#
# Init GUI
#
$LOAD_PATH << 'utils'
$LOAD_PATH << 'gui'

require 'gtk3'
require 'glade_window'

require 'dictionary_window'
$dictionary_window = DictionaryWindow.new

#
# Run
#
begin
	$dictionary_window.show
	Gtk.main
ensure
	puts 'Shutdown...'
end
