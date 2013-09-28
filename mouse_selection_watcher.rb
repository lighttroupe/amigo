class MouseSelectionWatcher
	CLIPBOARD_WATCH_TIMEOUT = 300

	def initialize
		@clipboard = Gtk::Clipboard.get('PRIMARY')
		@last_clipboard_text = ''
	end

	def on_selection(&proc)
		@selection_callback = proc
		start!
	end

	def started?
		raise NotImplementedError
	end

	def start!
		Gtk.timeout_add(CLIPBOARD_WATCH_TIMEOUT) {
			@clipboard.request_text { |clipboard, text| receive_text(text) }
		}
	end

	def stop!
		raise NotImplementedError
	end

private

	def receive_text(text)
		@selection_callback.call(text) if text_suitable_to_notify?(text) 
		@last_clipboard_text = text
	end

	def text_suitable_to_notify?(text)
		text && text != @last_clipboard_text && text.strip != ''
	end
end
