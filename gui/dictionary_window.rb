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

require 'glade_window'

#
# DictionaryWindow is the main search and results window
#
class DictionaryWindow < GladeWindow
	attr_reader :native_language, :foreign_language

	def initialize(native_language, foreign_language)
		super('dictionary_window', :widgets => [:preferences_button, :search_entry, :textview, :statusbar_label])

		@native_language, @foreign_language = native_language, foreign_language

		@buffer = @textview.buffer	# for easier access

		install_textview_formatting_tags

		@preferences_button.signal_connect('clicked') { $preferences_window.present }
	end

	def has_selection?
		false
	end

	def install_textview_formatting_tags
		[
			['indent', {:indent => 14}],
			['header', {:scale => Pango::AttrScale::LARGE, :weight => Pango::FontDescription::WEIGHT_BOLD}],
			['definition', {}],
			['word-details', {:indent => 14, :style => Pango::FontDescription::STYLE_ITALIC}],
			['word-type', {:style => Pango::FontDescription::STYLE_ITALIC}],
			#['no-results', {:style => Pango::FontDescription::STYLE_ITALIC}],
			['regular-conjugation', {}],
			['irregular-conjugation', {:foreground => '#0000D0'}],
			['tense', {:indent => 4, :scale => Pango::AttrScale::MEDIUM, :weight => Pango::FontDescription::WEIGHT_BOLD}],
			['person', {:foreground => '#A8A8A8', :style => Pango::FontDescription::STYLE_ITALIC}],
			['nulltag', {}]
		].each { |name, options|
			@buffer.create_tag(name, options)
		}
	end

	#
	# Helpers
	#
	def set_statusbar_markup(markup)
		@statusbar_label.markup = markup
	end

	def set_results(results)
		@textview.clear
		@foreign_language.render_results_to_textbuffer(results, @buffer)
	end

	#def has_selection
		#@search_entry.has_selection || @buffer.has_selection
	#end

	def search(search_term)
		@foreign_language.search(search_term)
	end

	def notification_summary
		'notification_summary stub'
	end

	#
	# Gtk Callbacks
	#

	# user hits Enter in search box
	def on_search_entry_activate
		search_term = @search_entry.text.strip
		results = search(search_term)
		if results.size > 0
			set_statusbar_markup ""
			set_results(results)
		else
			set_statusbar_markup "<i>No results for #{search_term}</i>"
		end
	end
end
