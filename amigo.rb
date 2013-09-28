#!/usr/bin/ruby1.9.1

# coding: utf-8

###############################################################################
#  Copyright 2013 Ian McIntosh <ian@openanswers.org>
#
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU Library General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software
#  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
###############################################################################

$LOAD_PATH << '.'
$LOAD_PATH << 'models'
$LOAD_PATH << 'languages'
$LOAD_PATH << 'utils'
$LOAD_PATH << 'gui'

DATABASE_FILENAME = 'amigo.db'

# So this file can be run from anywhere
Dir.chdir(File.dirname(File.expand_path(File.symlink?(__FILE__) ? File.readlink(__FILE__) : __FILE__)))

require 'rubygems'		# required for latest gtk and activerecord until they're available via apt-get

#require 'logger'
#puts 'Creating Logger...'
#ActiveRecord::Base.logger = Logger.new(STDOUT)

puts 'Loading Gtk...'
require 'gtk3'
require 'addons'

puts 'Loading ActiveRecord...'
gem 'activerecord', '= 3.2.13'
require 'active_record'

puts 'Opening Database...'
ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => DATABASE_FILENAME)

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
# Run
#
require 'application'

begin
	puts 'Running...'
	$application = Application.new(LanguageEnglish.new, LanguageSpanish.new)
	$application.run
ensure
	puts 'Shutdown...'
end
