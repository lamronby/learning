
require "rexml/document"

class AppConfig
	
	def self.load( path )
		
		raise "File #{path} does not exist." if (!File.exist?(path))

		appSettings = Hash.new
		configFile = File.new(path)
		doc = REXML::Document.new(configFile)

		appSettingsXml = doc.elements["configuration/appSettings"]
		
		appSettingsXml.elements.each("add") do |setting_elem|
			appSettings[setting_elem.attributes["key"]] =
				setting_elem.attributes["value"]
		end

		configFile.close

		return appSettings
	end
end


