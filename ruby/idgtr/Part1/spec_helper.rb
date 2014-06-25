=begin
	RSpec common setup and teardown code.
=end

describe 'a new document', :shared => true do
	before do
		@note = Note.open
	end

	after do
		@note.exit! if @note.running?
	end
end

describe 'a saved document', :shared => true do
	before do
		Note.fixture 'SavedNote'
	end
end

describe 'a reopened document', :shared => true do
	before do
		@note = Note.open 'SavedNote'
	end

	after do
		@note.exit! if @note.running?
	end
end

describe 'a searchable document', :shared => true do
	before do
		@example = 'The longest island is Isabel Island.'
		@term = 'Is'

		@first_match = @example.index(/Is/i)
		@second_match = @example.index(/Is/i, @first_match + 1)
		@reverse_match = @example.rindex(/Is/i)
		@word_match = @example.index(/Is\b/i)
		@case_match = @example.index(/Is/)

		@note.text = @example
	end
end


