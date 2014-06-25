# javaSwingHello.rb

require 'java' # Line 2
JFrame = javax.swing.JFrame
JPanel = javax.swing.JPanel
JLabel = javax.swing.JLabel

frame = JFrame.new
panel = JPanel.new
frame.add(panel)
jlabel = JLabel.new("Hello World!")
panel.add(jlabel)

frame.setDefaultCloseOperation(JFrame::EXIT_ON_CLOSE)
frame.pack
frame.setVisible(true)
