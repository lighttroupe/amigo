require 'dictionary_window'
require 'preferences_window'
require 'mouse_selection_watcher'

class Application
	def initialize(native_language, foreign_language)
		@dictionary_window = DictionaryWindow.new(native_language, foreign_language)
		@dictionary_window.show

		@mouse_selection_watcher = MouseSelectionWatcher.new.on_selection { |text|
			@dictionary_window.on_receive_text_selection(text)
		}
	end

	def run
		Gtk.main
	end
end
