#CREATE TABLE 'spanish_verb_conjugation' (
#  'id' INTEGER PRIMARY KEY AUTOINCREMENT,
#  'word_id' INTEGER,
#  'tense' INTEGER,
#  'person' INTEGER,
#  'conjugation' TEXT
#);
class SpanishVerbConjugation < BaseModel
	self.table_name = 'spanish_verb_conjugation'

	belongs_to :word, :class_name => 'SpanishWord'
end
