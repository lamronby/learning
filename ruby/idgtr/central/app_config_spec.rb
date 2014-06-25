
describe 'The app config class' do

	it 'parses an app config file' do
		appSettings = AppConfig.load( "D:\\Projects\\Raptor\\Plus\\v5.0\\Source\\Applications\\Managed\\nSightCentral\\bin\\Debug\\nSightCentral.exe.config")
		appSettings.should_not == nil
		appSettings["executable_links"].should_not == nil
		appSettings["external_links"].should_not == nil
	end
end
