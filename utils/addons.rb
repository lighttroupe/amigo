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

# extend/simplify/standardize some GTK/Ruby objects
class Gtk::TextBuffer
	def has_selection
		_unused, _unused2, is_selection = selection_bounds
		return is_selection
	end
end

class Gtk::TextView
	def clear
		iter_start, iter_end = buffer.bounds
		buffer.delete(iter_start, iter_end)
		move_viewport(:pages, -1)	# for some reason GTK doesn't put it at the very top
	end
end

class Gtk::Entry
	def has_selection
		return selection_bounds != nil
	end

	def select_all
		select_region(0, -1)
	end
end

class String
	def limit(chars, indicator='...')
		if length > chars
			self[0, chars] + indicator
		else
			self
		end
	end
end

class Gtk::Window
	def toggle_visibility
		if active?			# is this window the current top level window on the current desktop?
			hide
		else
			present				# show / move to current desktop / bring to top
		end
	end
end

def notify(options)
	options = {:urgency => 'low', :timeout => 5000}.merge(options)

	system("notify-send",
		#"--icon", File.join(Dir.pwd, ICON_PATH),
		"--expire-time", options[:timeout].to_s,
		"--urgency", (options[:urgency] || 'low'),
		options[:summary].to_s,
		options[:body].to_s)
end
