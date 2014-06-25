
# add the path to win32_gui
$: << 'D:/Learning/ruby/idgtr/lib'

require 'win32_gui'
require 'spec_helper'
include WindowsGui

describe 'The nSight desktop shortcut' do
	it_should_behave_like 'a debug spec session'
	
	it 'starts nSight Central' do
		options = {
			:use_desktop_link => true,
			:link_name => 'nSight'
		}
		@central = Central.open( 'nSightCentral', options )
		@central.should_not == nil
		@central.exit! if @central.running?
	end
end

describe 'The main window' do
	it_should_behave_like 'a debug spec session'
	
	# Open a new Central dialog at the beginning of each test.
	it 'starts when run directly' do
		@central = Central.open
		@central.should_not == nil
		@central.exit! if @central.running?
	end
end

describe 'nSight shortcuts' do
	it_should_behave_like 'a debug spec session'
	it_should_behave_like 'a clicked shortcut'
	
	it 'starts Patient Information when clicked' do
		@central.click_shortcut('Patient Information', 10)
		@shortcut_win = Window.top_level 'nSight - [Patient Information]'
		@shortcut_win.should_not == nil
	end
	
	it 'starts FVC when clicked' do
		@central.click_shortcut('Forced Vital Capacity', 10)
		@shortcut_win = Window.top_level 'nSight - [Forced Vital Capacity]'
		@shortcut_win.should_not == nil
	end
	
	it 'starts N2 when clicked' do
		@central.click_shortcut('Lung Volumes (N2)', 10)
		@shortcut_win = Window.top_level 'nSight - [Lung Volumes (N2)]'
		@shortcut_win.should_not == nil
	end
	
	it 'starts Lung Volumes(He) when clicked' do
		@central.click_shortcut('Lung Volumes (He)', 10)
		@shortcut_win = Window.top_level 'nSight - [Lung Volumes (He)]'
		@shortcut_win.should_not == nil
	end

	it 'starts Diffusion Capacity when clicked' do
		@central.click_shortcut('Diffusion Capacity', 10)
		@shortcut_win = Window.top_level 'nSight - [Diffusion Capacity]'
		@shortcut_win.should_not == nil
	end
	
	it 'starts Plethysmography when clicked' do
		@central.click_shortcut('Plethysmography', 10)
		@shortcut_win = Window.top_level 'nSight - [Plethysmography]'
		@shortcut_win.should_not == nil
	end
	
	it 'starts PImax/PEmax (MIP/MEP) when clicked' do
		@central.click_shortcut('PImax/PEmax (MIP/MEP)', 10)
		@shortcut_win = Window.top_level 'nSight - [PImax/PEmax (MIP/MEP)]'
		@shortcut_win.should_not == nil
	end
	
	it 'starts MVV when clicked' do
		@central.click_shortcut('Maximum Voluntary Ventilation', 10)
		@shortcut_win = Window.top_level 'nSight - [Maximum Voluntary Ventilation]'
		@shortcut_win.should_not == nil
	end
	
	it 'starts Extended Reports when clicked' do
		@central.click_shortcut('Extended Reports')
		@shortcut_win = Window.top_level 'nSight - [Extended Reports]'
		@shortcut_win.should_not == nil
	end
	
	it 'starts Database Utilities when clicked' do
		@central.click_shortcut('Database Utilities')
		@shortcut_win = Window.top_level 'nSight - [Database Utilities]'
		@shortcut_win.should_not == nil
	end
	
end

# describe 'Contains the expected web links' do
	# it_should_behave_like 'a debug spec session'
	# 
	# it 'contains the configured external links' do
		# @central = Central.open
		# 
		# @central.externalLinks.each_key do |link|
			# puts "Link name is: #{link}"
			# @central.click_web_link(String.new(link))
			# break
		# end
		# 
		# @central.should_not == nil
		# @central.exit! if @central.running?
	# end
# end
	

