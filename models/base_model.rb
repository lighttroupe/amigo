class BaseModel < ActiveRecord::Base
	# Prevents ActiveRecord from looking for a database table for this class
	self.abstract_class = true

	self.inheritance_column = 'not_used'		# this is needed until we stop using a column named 'type'
end
