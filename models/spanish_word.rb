#CREATE TABLE 'spanish_word' (
#  'id' INTEGER PRIMARY KEY AUTOINCREMENT,
#  'type' INTEGER,
#  'word' TEXT
#);
class SpanishWord < BaseModel
	self.table_name = 'spanish_word'

	has_many :spanish_english
	has_many :english_words, :through => :spanish_english
	has_many :spanish_verb_conjugations, :foreign_key => :word_id

	def self.search(term)
		where(['word LIKE ?', term])
	end
end
