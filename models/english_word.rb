#CREATE TABLE 'english_word' (
#  'id' INTEGER PRIMARY KEY AUTOINCREMENT,
#  'type' INTEGER,
#  'word' TEXT
#);
class EnglishWord < BaseModel
	self.table_name = 'english_word'

	has_many :spanish_english
	has_many :spanish_words, :through => :spanish_english
end
