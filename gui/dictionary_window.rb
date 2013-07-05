#
# DictionaryWindow is the main search and results window
#
class DictionaryWindow < GladeWindow
	def initialize
		super('dictionary_window', :widgets => [:preferences_button, :search_entry, :textview, :statusbar_label])

		@buffer = @textview.buffer	# for easier access

		@preferences_button.signal_connect('clicked') { puts 'preferences' } #$preferences_window.present }
		@statusbar_label.markup = 'bam!'
	end

	def on_search_entry_activate
	end
end
