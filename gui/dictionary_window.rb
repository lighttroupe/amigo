require 'glade_window'

#
# DictionaryWindow is the main search and results window
#
class DictionaryWindow < GladeWindow
	TEXTVIEW_TAGS = [
		['indent', {:indent => 14}],
		['header', {:scale => Pango::AttrScale::X_LARGE, :weight => Pango::FontDescription::WEIGHT_BOLD}],
		['definition', {}],
		['word-details', {:indent => 14, :style => Pango::FontDescription::STYLE_ITALIC}],
		['word-type', {:style => Pango::FontDescription::STYLE_ITALIC}],
		#['no-results', {:style => Pango::FontDescription::STYLE_ITALIC}],
		['regular-conjugation', {}],
		['irregular-conjugation', {:foreground => '#0000D0'}],
		['tense', {:indent => 4, :scale => Pango::AttrScale::LARGE, :weight => Pango::FontDescription::WEIGHT_BOLD}],
		['person', {:foreground => '#A8A8A8', :style => Pango::FontDescription::STYLE_ITALIC}],
		['nulltag', {}],
	]

	def initialize(native_language, foreign_language)
		super('dictionary_window', :widgets => [:preferences_button, :search_entry, :textview, :statusbar_label])

		@native_language, @foreign_language = native_language, foreign_language

		@buffer = @textview.buffer	# for easier access
		TEXTVIEW_TAGS.each { |name, options| @buffer.create_tag(name,options) }

		@preferences_button.signal_connect('clicked') { puts 'preferences' } #$preferences_window.present }
	end

	#def has_selection
		#@search_entry.has_selection || @buffer.has_selection
	#end

	def set_statusbar_markup(markup)
		@statusbar_label.markup = markup
	end

	def set_results(results)
		@textview.clear 		# NOTE: doesn't clear if there's nothing new to show
		@foreign_language.render_results_to_textbuffer(results, @buffer)
	end

	def on_search_entry_activate
		search_term = @search_entry.text
		results = @foreign_language.search(search_term)
		if results.size > 0
			set_statusbar_markup ""
			set_results(results)
		else
			set_statusbar_markup "<i>No results for #{search_term}</i>"
		end
	end
end
