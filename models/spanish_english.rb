#CREATE TABLE 'spanish_english' (
#  'id' INTEGER PRIMARY KEY AUTOINCREMENT,
#  'spanish_word_id' INTEGER,
#  'english_word_id' INTEGER
#);
class SpanishEnglish < BaseModel
	self.table_name = 'spanish_english'
	set_inheritance_column 'not_used'

	belongs_to :english_word
	belongs_to :spanish_word
end
