
require 'test_wizard'
require 'Win32API'

#	Find a control.
#	You can identify a control using caption, class, a custom selection
#	function, or any combination of these. (Multiple selection criteria are
#	ANDed. If this isn't what's wanted, use a selection function.)
#
#	Arguments:
#	topHwnd             The window handle of the top level window in which
#						the required controls reside.
#	wantedText          Text which the required control's captions must
#						contain.
#	wantedClass         Class to which the required control must belong.
#	selectionFunction   Control selection function. Reference to a function
#						should be passed here. The function should take hwnd
#						as an argument, and should return 'true' when passed 
#						the hwnd of the desired control.
#
#	Returns:            The window handle of the first control matching the
#						supplied selection criteria.
#					
#	Raises:
#	RuntimeException    When no control found.
#
#	Usage example:      optDialog = findTopWindow(wantedText="Options")
#						okButton = findControl(optDialog,
#											   wantedClass="Button",
#											   wantedText="OK")

def findControl(wantedText=nil, wantedClass=nil,
				selectionFunction=nil)
	
	controls = findControls(wantedText, wantedClass, selectionFunction)
	
	if (controls)
		return controls[0]
	else
		raise "No control found for topHwnd=#{topHwnd}, wantedText=" +
			"#{wantedText}, wantedClass=#{wantedClass}, " +
			"selectionFunction=#{selectionFunction}"
	end
end

#	Find controls.
#	You can identify controls using captions, classes, a custom selection
#	function, or any combination of these. (Multiple selection criteria are
#	ANDed. If this isn't what's wanted, use a selection function.)
#
#	Arguments:
#	topHwnd             The window handle of the top level window in which
#						the required controls reside.
#	wantedText          Text which the required controls' captions must
#						contain.
#	wantedClass         Class to which the required controls must belong.
#	selectionFunction   Control selection function. Reference to a function
#						should be passed here. The function should take hwnd 
#						as an argument, and should return 'true' when passed
#						the hwnd of a desired control.
#
#	Returns:            An array of the window handles of the controls
#						matching the supplied selection criteria.    


def findControls(wantedText, wantedClass, selectionFunction)
	return searchChildWindows(topHwnd) do |windowText, windowClass, childHwnd|
		true if (wantedText == windowText)
		true if (wantedClass == windowClass)
		true if (selectionFunction != nil && selectionFunction(childHwnd))
		false
	end
end

def searchChildWindows(currentHwnd)
	results = Array.new
	childWindows = Array.new
	
	begin
		win32gui.EnumChildWindows(currentHwnd, _windowEnumerationHandler,
								  childWindows)
	rescue Exception
		# This seems to mean that the control *cannot* have child windows,
		# i.e. not a container.
		return
	end

	for childHwnd, windowText, windowClass in childWindows
		descendentMatchingHwnds = searchChildWindows(childHwnd)
		results += descendentMatchingHwnds if (descendentMatchingHwnds)

		break if yield windowText, windowClass, childHwnd
		
		results.append(childHwnd)
	end

	return results

end

# Pass to Win32API EnumWindows() to generate list of window handle,
# window text, window class tuples.
def windowEnumerationHandler(hwnd, resultList)
	window = Window.new(hwnd)
	resultList.append(hwnd, window.text, window.class_name)
end

# Remove '&' characters and lower case. Useful for matching control text.
def normalizeText(controlText)
    return controlText.lower().replace('&', '')
end

if __FILE__ == $0
	@wizard = TestWizard.open
	puts "main_window.handle= #{@wizard.main_window.handle}"
	@wizard.find_control(@wizard.main_window.handle, "&Cancel")
#	@wizard.exit! if @wizard.running?
end


