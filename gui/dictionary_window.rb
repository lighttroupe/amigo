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

		# Language
		@native_language, @foreign_language = native_language, foreign_language

		# Output
		@buffer = @textview.buffer	# for easier access
		install_textview_formatting_tags

		# Preferences
		@preferences_window = PreferencesWindow.new
		@preferences_button.signal_connect('clicked') { @preferences_window.present }
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

	def has_selection?
		@search_entry.has_selection || @buffer.has_selection
	end

	def send_notification(options)
		options = {:urgency => 'low', :timeout => 3000}.merge(options)

		system("notify-send",
			#"--icon", File.join(Dir.pwd, ICON_PATH),
			"--expire-time", options[:timeout].to_s,
			"--urgency", options[:urgency].to_s,
			options[:summary].to_s,
			options[:body].to_s)
	end

	def notification_summary
		'notification_summary stub'
	end

	#
	# Gtk Callbacks
	#
	def on_search_entry_activate		# user hits Enter in search box
		search_term = @search_entry.text.strip
		results = @foreign_language.search(search_term)
		if results.size > 0
			set_results(results)
			set_statusbar_markup ""
		else
			set_statusbar_markup "<i>No results for <b>#{search_term}</b></i>"
		end
	end

	#
	# App Callback
	#
	def on_receive_text_selection(text)
		# don't respond to selections in our own window(s)
		return if has_selection? || @preferences_window.has_selection?

		# be friendlier to mouse-cowboys (remove junk characters in selection)
		text = @foreign_language.class.clean_string(text)

		# the text we get from the clipboard seems to be in ASCII8
		# convert to UTF8, which later regular expressions expect
		# TODO: move this above
		text.force_encoding('UTF-8') if text.respond_to? :force_encoding

		# We can ignore garbage
		return unless @foreign_language.class.resembles_word(text)

		# Search for word
		text = @foreign_language.class.downcase(text)
		if @foreign_language.search(text)		# something found?
			send_notification(:summary => text, :body => '', :timeout => 10000, :urgency => 'low')		#if $preferences_window.show_notifications_checkbutton.active?
			self.urgency_hint = true
		end
	end

	#
	# Gtk setup
	#
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
end
