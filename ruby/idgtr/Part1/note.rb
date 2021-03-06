=begin
	Base class for testing note-type applications.
end
=end

require 'fileutils'

class Note

	# The application name.
	@@app = nil

	# An array of window titles for the LockNote application.
	@@titles = {}

	attr_reader :path

	# Default options hash.
	DefaultOptions = {
		:password => 'password',
		:confirmation => true
	}
	
	# Create a new instance of an application
	def self.open(*args)
		raise RuntimeError, 'Could not determine note type' if nil == @@app
		@@app.new *args
	end

	# Create a copy of a test fixture LockNote file. 
	def self.fixture(name)
		source = @@app.path_to(name + 'Fixture')
		target = @@app.path_to(name)

		FileUtils.rm target if File.exist? target
		FileUtils.copy source, target
	end
	
	# Unlock a document by entering a password.
	def unlock_password(with_options = {})
		options = DefaultOptions.merge with_options
		options[:confirmation] = false

		enter_password options
		watch_for_error
	end

	# Assign a password for a note.
	def assign_password(with_options = {})
		options = DefaultOptions.merge with_options

		enter_password options
		watch_for_error

		if @prompted[:with_error]
			enter_password :cancel_password => true
		end
	end

	# Change the password assigned to a note.
	def change_password(with_options = {})
		old_options = {
			:password => with_options[:old_password]
		}

		new_options = {
			:password => with_options[:password],
			:confirmation =>
				with_options[:confirmation] || with_options[:password]
		}

		menu 'File', 'Change Password...'

		unlock_password old_options
		assign_password new_options
	end
	
	# Save a document.
	def save_as(name, with_options = {})
		options = DefaultOptions.merge with_options

		@path = @@app.path_to(name)
		File.delete @path if File.exist? @path

		menu 'File', 'Save As...'

		enter_filename @path
		assign_password options
	end
	
	# Close the note application.
	def exit!(with_options = {})
		options = DefaultOptions.merge with_options
		
		@main_window.close

		# If a save_as option was provided, confirm that we want
		# to save.
		@prompted[:to_confirm_exit] = dialog(@@titles[:exit]) do |d|
			d.click(options[:save_as] ? '_Yes' : '_No')
		end

		# Save the file before existing.
		if options[:save_as]
			path = @@app.path_to options[:save_as]
			enter_filename path
			assign_password options
		end
	end

	# Define a set of methods for cut, paste, and undo
	[:undo, :cut, :copy, :paste, :find_next].each do |method|
		item = method.to_s.split('_').collect {|m| m.capitalize}.join(' ')
		# TODO Why :wait? Why not 'true'?
		define_method(method) {menu 'Edit', item, :wait}
	end
	
	# Did the UI prompt?
	def has_prompted?(kind)
		@prompted[kind]
	end

private

	def enter_filename(path, approval = '_Save')
		dialog(@@titles[:file]) do |d|
			d.type_in path
			d.click approval
		end
	end

end


