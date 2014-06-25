#!/usr/bin/env ruby
 
require 'tk'
require 'nqxml/treeparser'
 
class XMLViewer < TkRoot
  def createMenubar
    menubar = TkFrame.new(self)
    fileMenuButton = TkMenubutton.new(menubar,
                                      'text' => 'File',
                                      'underline' => 0)
    fileMenu = TkMenu.new(fileMenuButton, 'tearoff' => false)
 
    fileMenu.add('command',
                 'label' => 'Open',
                 'command' => proc { openDocument },
                 'underline' => 0,
                 'accel' => 'Ctrl+O')
    self.bind('Control-o', proc { openDocument })
 
    fileMenu.add('command',
                 'label' => 'Quit',
                 'command' => proc { exit },
                 'underline' => 0,
                 'accel' => 'Ctrl+Q')
    self.bind('Control-q', proc { exit })
 
    fileMenuButton.menu(fileMenu)
    fileMenuButton.pack('side' => 'left')
 
    helpMenuButton = TkMenubutton.new(menubar,
                                      'text' => 'Help',
                                      'underline' => 0)
    helpMenu = TkMenu.new(helpMenuButton, 'tearoff' => false)
 
    helpMenu.add('command',
                 'label' => 'About...',
                 'command' => proc { showAboutBox })
 
    helpMenuButton.menu(helpMenu)
    helpMenuButton.pack('side' => 'right')
    menubar.pack('side' => 'top', 'fill' => 'x')
  end
 
  def createContents
    # List
    listBox = TkListbox.new(self) {
      selectmode 'single'
      background 'white'
      font 'courier 10 normal'
    }
    scrollBar = TkScrollbar.new(self) {
      command proc { |*args|
        listBox.yview(*args)
      }
    }
    rightSide = TkFrame.new(self)
    attributesForm = TkFrame.new(rightSide)
    attributesForm.pack('side' => 'top', 'fill' => 'x')
    TkFrame.new(rightSide).pack('side' => 'top', 'fill' => 'both',
      'expand' => true)
    listBox.yscrollcommand(proc { |first, last|
      scrollBar.set(first, last)
    })
    listBox.bind('ButtonRelease-1') {
      itemIndex = listBox.curselection[0]
      if itemIndex
        # Remove currently displayed attributes
        TkGrid.slaves(attributesForm, nil).each { |slave|
          TkGrid.forget(attributesForm, slave)
        }
 
        # Add labels and entry widgets for this entity's attributes
        entity = @entities[itemIndex]
        if entity.kind_of?(NQXML::NamedAttributes)
          keys = entity.attrs.keys.sort
          keys.each_index { |row|
            TkLabel.new(attributesForm) {
              text keys[row] + ":"
              justify 'left'
            }.grid('row' => row, 'column' => 0, 'sticky' => 'nw')
            entry = TkEntry.new(attributesForm)
            entry.grid('row' => row, 'column' => 1, 'sticky' => 'nsew')
            entry.value = entity.attrs[keys[row]]
            TkGrid.rowconfigure(attributesForm, row, 'weight' => 1)
          }
          TkGrid.columnconfigure(attributesForm, 0, 'weight' => 1)
          TkGrid.columnconfigure(attributesForm, 1, 'weight' => 1)
        else
        end
      end
    }
 
    listBox.pack('side' => 'left', 'fill' => 'both', 'expand' => true)
    scrollBar.pack('side' => 'left', 'fill' => 'y')
    rightSide.pack('side' => 'left', 'fill' => 'both', 'expand' => true)
 
    @listBox = listBox
    @attributesForm = attributesForm
  end
 
  def initialize
    # Initialize base class
    super
 
    # Main Window Title
    title 'TkXMLViewer'
    geometry '600x400'
 
    # Menu bar
    createMenubar
    createContents
  end
 
  def populateList(docRootNode, indent)
    entity = docRootNode.entity
    if entity.instance_of?(NQXML::Tag)
      @listBox.insert('end', ' '*indent + entity.to_s)
      @entities.push(entity)
      docRootNode.children.each do |node|
        populateList(node, indent + 2)
      end
    elsif entity.instance_of?(NQXML::Text) &&
          entity.to_s.strip.length != 0
      @listBox.insert('end', ' '*indent + entity.to_s)
      @entities.push(entity)
    end
  end
 
  def loadDocument(filename)
    @document = nil
    begin
      @document = NQXML::TreeParser.new(File.new(filename)).document
    rescue NQXML::ParserError => ex
      Tk.messageBox('icon' => 'error', 'type' => 'ok',
                    'title' => 'Error', 'parent' => self,
                    'message' => "Couldn't parse XML document")
    end
    if @document
      @listBox.delete(0, @listBox.size)
      @entities = []
      populateList(@document.rootNode, 0)
    end
  end
 
  def openDocument
    filetypes = [["All Files", "*"], ["XML Documents", "*.xml"]]
    filename = Tk.getOpenFile('filetypes' => filetypes,
                              'parent' => self)
    if filename != ""
      loadDocument(filename)
    end
  end
 
  def showAboutBox
      Tk.messageBox('icon' => 'info', 'type' => 'ok',
        'title' => 'About TkXMLViewer',
        'parent' => self,
        'message' => 'Ruby/Tk XML Viewer Application')
  end
end
 
# Run the application
root = XMLViewer.new
Tk.mainloop
