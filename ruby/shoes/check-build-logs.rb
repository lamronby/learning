=begin
	Check nSight build logs.
=end
Shoes.app :height => 500, :width => 450 do
  BuildLog = "PlusBuild.log"
  BuildLogSubdir = "Builds/Logs"
  nspire_api_dir = "r:/nSpire API/v1.0"
  nsight_dir = "r:/Raptor/Plus/v5.0"

  def check_build_logs( dir, fails_only = false )
    @edit.text = ""
    
    build_log_dir = dir + "/" + BuildLogSubdir
    fail "Could not find build logs directory #{build_log_dir}" if !File.directory?(build_log_dir)
  
    # Find the most recent build log subdirectory.
    build_no = 0
    latest_build_subdir = 'Build-0'
    Dir.foreach(build_log_dir) do |build_dir|
      next if build_dir !~ /Build-\d+/
      build_no = 
      latest_build_subdir = build_dir if build_dir.split('-')[1].to_i > 
                            latest_build_subdir.split('-')[1].to_i
    end
  
    log_line "Latest build log directory: #{latest_build_subdir}"
  
    build_log_path = build_log_dir + "/" + latest_build_subdir + "/" + BuildLog
  
    regex = fails_only ? /[1-9]+\s(fail|error)/i : /(succee|fail)/i
  
    line_num = 0
    IO.foreach( build_log_path ) do |line|
            line_num += 1
            
            # Ignore empty lines.
            next if (line =~ /^$/)
  
            line.chomp!
  
            log_line "#{line_num} #{line}" if line =~ regex
    end
  end

  def log_line( line )
    @edit.text = (@edit.text.length > 0) ?  @edit.text + "\n" + line : line
  end
  
  caption "Check Build Logs"
  background "#eee"
  stack :width => "95%" do
    border "#00D0FF", :strokewidth => 3
    para( link("nSpire API build") { check_build_logs(nspire_api_dir) } )
    para( link("nSight 2009.1 build") { check_build_logs(nsight_dir) } )
  end
     
  @edit = edit_box :width => 0.95, :height => 400, :scroll => true
  
end



