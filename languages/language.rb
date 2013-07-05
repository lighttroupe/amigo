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

# base class
class Language
	WORD_TYPE_VERB = 1
	WORD_TYPE_NOUN_MALE = 2
	WORD_TYPE_NOUN_FEMALE = 3
	WORD_TYPE_ADJECTIVE = 4
	WORD_TYPE_ADVERB = 5
	WORD_TYPE_PREPOSITION = 6
	WORD_TYPE_PRONOUN = 7
	WORD_TYPE_INTERJECTION = 8
	WORD_TYPE_CONJECTURE = 9

	WORD_TYPE_NAMES = {WORD_TYPE_VERB => 'v', WORD_TYPE_NOUN_MALE => 'nm', WORD_TYPE_NOUN_FEMALE => 'nf', WORD_TYPE_ADJECTIVE => 'adj', WORD_TYPE_ADVERB => 'adv', WORD_TYPE_PREPOSITION => 'prep', WORD_TYPE_PRONOUN => 'pron', WORD_TYPE_INTERJECTION => 'interj', WORD_TYPE_CONJECTURE => 'conj'}

	def strip_accents(str); str ; end
	def resembles_word(str)	; false ; end
end
