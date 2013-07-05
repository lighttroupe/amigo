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

require 'language'

class LanguageSpanish < Language
	VERB_PERSON_NONE, VERB_PERSON_YO, VERB_PERSON_TU, VERB_PERSON_EL, VERB_PERSON_NOSOTROS, VERB_PERSON_VOSOTROS, VERB_PERSON_ELLOS = 0, 1, 2, 3, 4, 5, 6
	VERB_PERSON_NAMES = ['', 'yo', 'tú', 'él/ella/Ud', 'nosotros', 'vosotros', 'ellos/ellas/Uds' ]
	VERB_PERSON_SHOW = [true, true, true, true, true, false, true]
	VERB_TENSE_INFINITIVE, VERB_TENSE_PRESENT, VERB_TENSE_PRETERITE, VERB_TENSE_FUTURE, VERB_TENSE_IMPERFECT, VERB_TENSE_CONDITIONAL, VERB_TENSE_SUBJUNCTIVE_PRESENT, VERB_TENSE_SUBJUNCTIVE_IMPERFECT, VERB_TENSE_SUBJUNCTIVE_FUTURE, VERB_TENSE_IMPERATIVE, VERB_TENSE_IMPERATIVE_NEGATIVE, VERB_TENSE_GERUND, VERB_TENSE_PAST_PARTICIPLE = *(0..12).to_a
	TENSE_NAMES = ['infinitive', 'present', 'past preterite', 'future', 'past imperfect', 'future conditional', 'present subjunctive', 'past subjunctive', 'future subjunctive', 'imperative', 'imperative (negative)', 'progressive', 'past participle']
	TENSE_SHOW = [false, true, true, true, true, true, true, true, true, true, true, true, true]
	# some tenses add on to the infinitive (eg "hablar+é") instead of using the verb root ("habl+o")
	TENSE_USES_INFINITIVE = [false, false, false, true, false, true, false, false, false, false, false, false, false]
	# here are all the verb endings which either get added to the root or the infinitive (based on TENSE_USES_INFINITIVE)
	REGULAR_CONJUGATIONS = {
		'ar' => [[],['', 'o', 'as', 'a', 'amos', 'áis', 'an'],['', 'é', 'aste', 'ó', 'amos', 'asteis', 'aron'],['', 'é', 'ás', 'á', 'emos', 'éis', 'án'],['', 'aba', 'abas', 'aba', 'ábamos', 'abais', 'aban'],['', 'ía', 'ías', 'ía', 'íamos', 'íais', 'ían'],['', 'e', 'es', 'e', 'emos', 'éis', 'en'],['', 'ara', 'aras', 'ara', 'áramos', 'arais', 'aran'],['', 'are', 'ares', 'are', 'áremos', 'areis', 'aren'],['', '', 'a', 'e', 'emos', 'ad', 'en'],['', '', 'es', 'e', 'emos', 'éis', 'en'],['ando','','','','','',''],['ado','','','','','','']],
		'er' => [[],['', 'o', 'es', 'e', 'emos', 'éis', 'en'],['', 'í', 'iste', 'ió', 'imos', 'isteis', 'ieron'],['', 'é', 'ás', 'á', 'emos', 'éis', 'án'],['', 'ía', 'ías', 'ía', 'íamos', 'íais', 'ían'],['', 'ía', 'ías', 'ía', 'íamos', 'íais', 'ían'],['', 'a', 'as', 'a', 'amos', 'áis', 'an'],['', 'iera', 'ieras', 'iera', 'iéramos', 'ierais', 'ieran'],['', 'iere', 'ieres', 'iere', 'iéremos', 'iereis', 'ieren'],['', '', 'e', 'a', 'amos', 'ed', 'an'],['', '', 'as', 'a', 'amos', 'áis', 'an'],['iendo','','','','','',''],['ido','','','','','','']],
		'ir' => [[],['', 'o', 'es', 'e', 'imos', 'ís', 'en'],['', 'í', 'iste', 'ió', 'imos', 'isteis', 'ieron'],['', 'é', 'ás', 'á', 'emos', 'éis', 'án'],['', 'ía', 'ías', 'ía', 'íamos', 'íais', 'ían'],['', 'ía', 'ías', 'ía', 'íamos', 'íais', 'ían'],['', 'a', 'as', 'a', 'amos', 'áis', 'an'],['', 'iera', 'ieras', 'iera', 'iéramos', 'ierais', 'ieran'],['', 'iere', 'ieres', 'iere', 'iéremos', 'iereis', 'ieren'],['', '', 'e', 'a', 'amos', 'id', 'an'],['', '', 'as', 'a', 'amos', 'áis', 'an'],['iendo','','','','','',''],['ido','','','','','','']]
	}

	#
	# Language Utilities
	#
	def self.tense_name(id)
		TENSE_NAMES[id]
	end

	def self.person_name(id)
		VERB_PERSON_NAMES[id]
	end

	def self.clean_string(str)
		str.gsub(/[\,\.\!\?\:\'\"\[\]\(\)\{\}\/]/, ' ').strip
	end

	def self.resembles_word(str)
		(str =~ /\A[a-zA-ZÁÉÍÓÚÑáéíóúñ]+\Z/u) != nil
	end

	def self.downcase(str)
		str.tr("ÁÉÍÓÚÑ", "áéíóúñ").downcase
	end

	def self.strip_accents(str)		# better way to do this?
		str.gsub(/á/u, 'a').gsub(/é/u, 'e').gsub(/í/u, 'i').gsub(/ó/u, 'o').gsub(/ú/u, 'u').gsub(/ñ/u, 'n')
	end

	#
	# Search
	#
	def search(search_string)
		results = []

		#puts "searching: #{search_string}"
		# real words (including verbs (infinitive form), nouns, pronouns, etc.)
		SpanishWord.where(['word LIKE ?', search_string]).each { |word|
			results << {:word_type => word.type, :verb_tense => VERB_TENSE_INFINITIVE, :verb_person => VERB_PERSON_NONE, :word_id => word.id, :search => word.word}
		}

		# irregular verb conjugations
		SpanishVerbConjugation.where(:conjugation => search_string).each { |conjugation|
			results << {:word_type => WORD_TYPE_VERB, :verb_tense => conjugation.tense, :verb_person => conjugation.person, :word_id => conjugation.word_id, :search => search_string}
		}

		# regular verb conjugations (not stored in DB)
		unconjugate(search_string) { |infinitive, tense, person|
			# it's a regular conjugation IF the infinitive exist AND no irregular for this verb/person/tense exists
			infinitive = SpanishWord.where(:word => infinitive, :type => WORD_TYPE_VERB).first
			next unless infinitive	# not a verb
			irregular = SpanishVerbConjugation.where(:word_id => infinitive['id'].to_i, :tense => tense, :person => person).first
			next if irregular	# oops-- it's irregular in this tense/person, so no match
			results << {:word_type => WORD_TYPE_VERB, :verb_tense => tense, :verb_person => person, :word_id => infinitive['id'].to_i, :search => search_string}
		}

		results
	end

	###################################################################
	# conjugate() - change an infinitive "hablar" to a specific tense/person conjugation like "hablo" (present tense, first person) using lookup tables
	###################################################################
	def self.conjugate(infinitive, tense, person)
		# remove 'se' if present
		infinitive = infinitive[0, infinitive.length-2] if infinitive[infinitive.length-2, 2] == 'se'
		infinitive = strip_accents(infinitive)
		stem = infinitive[0, infinitive.length-2]
		ar_er_ir = infinitive[infinitive.length-2, 2]
		if(TENSE_USES_INFINITIVE[tense])	# does it add on to the infinitive?
			if REGULAR_CONJUGATIONS[ar_er_ir][tense][person] != ''
				infinitive + REGULAR_CONJUGATIONS[ar_er_ir][tense][person]
			end
		else
			if REGULAR_CONJUGATIONS[ar_er_ir][tense][person] != ''
				stem + REGULAR_CONJUGATIONS[ar_er_ir][tense][person]
			end
		end
	end

	###################################################################
	# unconjugate() - take what MIGHT be a conjugated verb and yield possible infinitives
	# most returned values are JUNK and so caller must check that:
	#  1) the returned infinitive exists,
	#  2) the verb isn't irregular in that tense/person
	###################################################################
	def unconjugate(conjugation)	# yields each possible | infinitive, tense, person |
		REGULAR_CONJUGATIONS.each_key { | ar_er_ir |
			REGULAR_CONJUGATIONS[ar_er_ir].each_index { | tense |
				REGULAR_CONJUGATIONS[ar_er_ir][tense].each_index { | person |
					tail = REGULAR_CONJUGATIONS[ar_er_ir][tense][person]				# one possible tail for the conjugated verb
					next if tail.length == 0 || tail.length >= conjugation.length			# can't possibly match

					# does it have this tail at the end?
					next if tail != conjugation[conjugation.length-tail.length, conjugation.length]

					# yield results
					before_tail = conjugation[0, conjugation.length-tail.length]
					if TENSE_USES_INFINITIVE[tense]
						yield before_tail, tense, person							# bit before the tail is the infinitive
					else
						yield before_tail + ar_er_ir, tense, person		# bit before the tail is the infinitive minus -ar/-er/-ir
					end
				}
			}
		}
	end

	# render_results_to_textbuffer - take an array of results (as created
	#   by search() above) and output to a GTK TextBuffer
	def render_results_to_textbuffer(results, buffer)
		last_word_id = nil

		results.each { |result|
			# We can have many results with the same base word
			# (we expect them to be sorted by word or word_id)
			if last_word_id != result[:word_id]
				#
				word = SpanishWord.find(result[:word_id])
				definitions = word.english_words

				# blank line *between* different words (not before the first)
				buffer.insert(buffer.end_iter, "\n") unless last_word_id.nil?

				# show base word ("hablar")
				buffer.insert(buffer.end_iter, word.word, 'header')

				# show word type ("v.")
				buffer.insert(buffer.end_iter, ' ' + WORD_TYPE_NAMES[word.type] + '.', 'word-type')

				# show definition(s) in a comma-separated list ("to speak, to talk")
				buffer.insert(buffer.end_iter, ' ' + definitions.map { |definition| definition['word'] }.join(", ") + "\n", 'definition')
			end

			if result[:word_type] == WORD_TYPE_VERB
				# show verb table for infinitives
				if result[:verb_tense] == VERB_TENSE_INFINITIVE
					# for each tense (past perfect, etc.)
					TENSE_NAMES.each_index { |tense|
						next if TENSE_SHOW[tense] == false	# some tenses aren't so useful...

						# show tense name ("Past Perfect")
						buffer.insert(buffer.end_iter, "\n" + TENSE_NAMES[tense] + "\n", 'tense')

						# for each person (yo, tu, el, ...)
						VERB_PERSON_NAMES.each_index { |person|
							next if VERB_PERSON_SHOW[person] == false		# skip "vosotros" based on user settings

							# show conjugation
							# attempt to load irregular conjugation (only irregulars are stored in the DB)
							irregular_conjugation = SpanishVerbConjugation.where(:word_id => result[:word_id], :tense => tense, :person => person).first
							if irregular_conjugation
								buffer.insert(buffer.end_iter, irregular_conjugation.conjugation.to_s, 'indent', 'irregular-conjugation')
							else
								# this verb is regular in this tense
								conjugation = self.class.conjugate(word.word, tense, person)
								next if conjugation.nil?	# some tenses (eg. gerund) don't have all persons
								buffer.insert(buffer.end_iter, conjugation, 'indent', 'regular-conjugation')
							end
							buffer.insert(buffer.end_iter, ' ' + VERB_PERSON_NAMES[person], 'person') if VERB_PERSON_NAMES[person] != ''
							buffer.insert(buffer.end_iter, "\n");
						}
					}
				else
					# not an infinitive
					# show the tense ("past simple tense tú form")
					buffer.insert(buffer.end_iter, '↳ ' + TENSE_NAMES[result[:verb_tense]] + ' tense', 'word-details')
					buffer.insert(buffer.end_iter, ' ' + VERB_PERSON_NAMES[result[:verb_person]] + ' form', 'word-details') if VERB_PERSON_NAMES[ result[:verb_person] ] != ''
					buffer.insert(buffer.end_iter, "\n")
				end
			end

			last_word_id = result[:word_id]
		}
	end

	###################################################################
	# render_results_to_notification() - take an array of results (as created
	#   by search() above) and return text suitable for a notification balloon
	###################################################################
=begin
	def render_results_to_notification(results)
		last_word_id = nil

		results.map { |result|
			txt = ''
			if last_word_id != result[:word_id]
				# blank line *between* different words (not before the first)
				txt += "\n\n" unless last_word_id.nil?

				# load up the word details and definitions
				word = SpanishWord.find(result[:word_id])
				definitions = word.english_words

				# show base word ("hablar")
				txt += '<b>' + word.word + '</b>'

				# show word type ("v.")
				txt += ' <i>' + WORD_TYPE_NAMES[word.type] + '</i>.'

				# show definition(s) in a comma-separated list ("to speak, to talk")
				txt += ' ' + definitions.map(&:word).join(', ')
			end

			# show tense/person for verbs
			if result[:word_type] == WORD_TYPE_VERB
				txt += "\n  ↳ "
				if result[:verb_tense] == VERB_TENSE_INFINITIVE
					txt += '<i>' + 'infinitive' + '</i>'
				else
					txt += '<i>' + TENSE_NAMES[result[:verb_tense]] + ' tense' + '</i>'
					txt += ', <i>' + VERB_PERSON_NAMES[result[:verb_person]] + ' form' + '</i>' unless VERB_PERSON_NAMES[result[:verb_person]].empty?
				end
			end
			last_word_id = result[:word_id]
			txt
		}.join
	end
=end
end
