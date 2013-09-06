#LogFile class
class LogFile < File
	#an array of keywords to search for
	@keywordArray	
	@mapping
	#attr_reader :type
	def initialize(filename, attrib)
		super(filename, attrib)
		@keywordArray = ['exception', 'fatal', 'crash']
	end
	
end

# LogFileList class - class is capitalized
=begin
class LogFileList
	# constructor
	def initialize
		@logfiles = Array.new
	end
	# utility methods
	def append(logfile)
		@logfiles.push(logfile)
	end
	def delete_first
		@logfiles.shift
	end
	def delete_last
		@logfiles.pop
	end
	def [](index)
		@logfiles[index]
	end
end
=end


#The main portion
if File.exists?("logFileList.cfg")
	#because a block is given, file will automatically close
	# when terminated
	_listOfFiles = Array.new
	
	configFile = File.open('logFileList.cfg', 'r') do |_logfileList|		
		_logfileList.each do |_onefile|
			
			if _onefile =~ /^\s*#/
				next
			end
			name, mapping, keywords = _onefile.chomp.split(/\s*\|\s*/)
			name = name.strip
			mapping = mapping.strip
			keywords = keywords.strip
			
			
			print "currently dealing with file "+name+ " in "+ mapping+ "\n"

			#print "pushing "+_onefile + " into the array\n"
			_listOfFiles.push(_onefile)
			
=begin
			logfile = LogFile.open(name, 'r') do |afile|
				print "opening file "+name+" to analyze\n"	
				#puts afile[1]
				#process the file
			end
			print "closing logfile "+name		
			logfile.close
	
			#(String)name.gsub(/\W/, '_')
			logfiles.append(logfile)
			#logfiles.append(File.new(name, "r"))
=end
		end		
		puts _listOfFiles			
	end
		
else 
	puts "sentinel config file missing!"
end	

=begin
if File.exists?("Test_wsIVR.log")
	inputFile = File.open("Test_wsIVR.log", "r")
	outputFile = File.open("result.txt", "w+")
	#inputFile.each {|line| print line}
	inputFile.each do |line|
		if line =~ /^.*transactionNumber.*/
			outputFile.puts line
		end
	end
	
	inputFile.close	
	outputFile.close
else 
	puts "can't open the file specified!\n"
end
=end





