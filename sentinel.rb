#This is the sentinel
# In it, we do a few things
# 1. Define the Logfile class, which extends the File class, but with a 
# 	of special properties, such as the keywordList(a list of keywords to
# 	watch for, and sizeWatch(if the size of a file gets too big, it write
# 	to a special watchResult file)...
# It creates a list of file objects instances

require 'logger'
require 'time'
require 'date'

#LogFile class
=begin
class Logfile < File
	#an list of keywords to search for
	@keywordlist	
	@mapping
	def open(filename, mode)
		super(filename, mode)
		@keywordlist = ['exception', 'fatal', 'crash']
	end

	def addkeyword(newkeyword)
		@keywordlist.push(newkeyword)
	end
	
	def listkeywords
		print @keywordlist
	end
	
end
=end

class Time
	# time since epoch in days
	def inDays
		return self.to_i/60/60/24
	end
	
	# time since epoch in hours
	def inHours
		return self.to_i/60/60
	end
	
end


#need the file list as an Argument, store in a global variable
if ARGV.size > 0
	$configfile = ARGV[0]
else
	puts "no config file detected"
	exit
end
$maxfilesize = 10


#New logger that rotates monthly.. 
$log = Logger.new('sentialWarning.log', 'daily')
$log.level = Logger::DEBUG
$log.formatter = proc do |severity, datetime, progname, msg|
	"#{datetime}: [#{severity}] #{msg}\n"
end

#Array to store the list of "dir"
dirToWatch = Array.new()

#Method to check the 'other' files in the directories
#puts Time.now.inDays


#Method to check the timestamp close-up
# Parm: timestamp - timestamp string, can be different format
#		restString - the rest of the line of the log, for display if we need to
# 		offset - the time offset we are suppose to account for
#		watchwindow - the number of hours we are limiting our sential to watch for
# returns: a boolean, whether the timestamp should count towards 
#			the total number of error or not
# Comment: THe "parse" function of DateTime is pretty in this version of Ruby
#			1.9.3 that I don't think it will go into the exception portion at all. 
# History: KYC, Apr, 2013- creation
def timeChecker (timestamp, restString, offset, watchwindow)
	#timeobj=DateTime.new
	#use DateTime.strptime(date_time, format) to create a DateTime object	
	begin
		
		#If it's the XX/xx/ZZ date format, assume ZZ are the years(american dates) first.
		if (timestamp =~ /\d{2}\/\d{2}\/\d{2}\s*\d{2}:\d{2}:\d{2}/)
			timeobj= DateTime.strptime(timestamp, '%m/%d/%y %H:%M:%S')
		else				
			timeobj = DateTime.parse(timestamp)
		end
		
		if ((timeobj + watchwindow.to_i + (offset.to_f/24) ) > DateTime.now)
			$log.debug("#{timeobj} #{restString}")
			true
		else	
			$log.debug("record outside of window..")
			false
		end
	rescue  #exception handling, we'll have to throw the exception..
	
		#exception formats, means it's a special format of some sort where
		#the year is in 2 digits, which is some weird american time format
		#very weird. 
		if (timestamp =~ /\d{2}\/\d{2}\/\d{2}\s*\d{2}:\d{2}:\d{2}/)
			timeobj= DateTime.strptime(timestamp, '%y/%d/%m %H:%M:%S')			
		elsif (line =~ /\d{2}-\d{2}-\d{2}\s*\d{2}:\d{2}:\d{2}/)
		#	#timeobj = DateTime.strptime("#{timestamp}", '%d-%m-%y %H:%M:%S')
			puts "world"
		end		
		$log.debug("#{timeobj} #{restString}")
	end				
	
	
end

=begin	
	if (line =~ /\d{2}\/\d{2}\/\d{2}\s*\d{2}:\d{2}:\d{2}/) || (line =~ /\d{4}\-\d{2}\-\d{2}\s*\d{2}:\d{2}:\d{2}/)
	# scan for different formatted timestamp
	scanResult = line.scan(/(\d{2}\/\d{2}\/\d{2}\s*\d{2}:\d{2}:\d{2})(.*)/)
	puts scanResult
	if (scanResult.size != 0)
		timestr, therest = scanResult[0], scanResult[1]
		#puts timestr
		#logFileTime = Time.parse(timestr)
		#diffInDays = (Time.now-Time.parse(timestr)).abs 
		#if ( diffInDays < watchwindow.to_i)
		#	$log.debug(timestr+therest)
		#	errorCount += 1
		#	next
		#end						
		#$log.debug(line.chomp)
		
	end
=end
	

#Method to check the file
def checkFile (filename, keywords, offset, watchwindow)
	#$log.debug("peekaboo")
	$log.debug("Scanning #{filename} for keywords: #{keywords} with offset: #{offset} and watch window of: #{watchwindow} days")
	archivedErr=currErr = 0
	File.open(filename, 'r') do |lines|
		lines.each do |line|			
			keywords.each{ |keyword|
				#TODO: This could be a problem, if different keyword appear on the same time
				# , it will be counted twice.
				if (line=~ /.*#{keyword}.*/)
					#call the timeChecker
					#use scan to parse the matching line into variables
					line.scan(/((\d{4}|\d{2})[\/ -]\d{2}[\/ -]\d{2}\s*\d{2}:\d{2}:\d{2})(.*)/) do |timestamp,x,restString|
						#puts timestamp
						rc=timeChecker(timestamp, restString, offset, watchwindow)
						#$log.debug("#{timestamp}@@@@ ")
						#TODO, pass in as parameter to timeChecker and only increment this when
						# constraints are met
						if (rc)
							currErr += 1
						else 
							archivedErr += 1
						end
					end					
					
=begin
					#if (line =~ /\d{2}\/\d{2}\/\d{2}\s*\d{2}:\d{2}:\d{2}/) || (line =~ /\d{4}\-\d{2}\-\d{2}\s*\d{2}:\d{2}:\d{2}/)
					# scan for different formatted timestamp
					scanResult = line.scan(/(\d{2}\/\d{2}\/\d{2}\s*\d{2}:\d{2}:\d{2})(.*)/)
					puts scanResult
					if (scanResult.size != 0)
						timestr, therest = scanResult[0], scanResult[1]
						#puts timestr
						#logFileTime = Time.parse(timestr)
						#diffInDays = (Time.now-Time.parse(timestr)).abs 
						#if ( diffInDays < watchwindow.to_i)
						#	$log.debug(timestr+therest)
						#	errorCount += 1
						#	next
						#end						
						#$log.debug(line.chomp)
						
					end					
					#line.scan(/\d{4}\-\d{2}\-\d{2}\s*\d{2}:\d{2}:\d{2}/)
=end
				end
			}
		end
	end
	$log.warn("Found #{currErr} number of errors in #{filename} within limited time window")
	$log.warn("Found #{archivedErr} number of archived errors in #{filename} OUTSIDE of the limited time window")
end

#Read the list of files to watch from the config file
if File.exists?($configfile)	
	#starter
	$log.info("============Sentinel scan starting========================")
	
	#No need to close the file because the block will close it for us
	File.open($configfile, 'r') do |listOfFiles|		
		listOfFiles.each do |_onefile|
			
			#skip if the line is commented out(ie: first character is non-white char is #)
			if _onefile =~ /^\s*#/
				next
			end
			
			#chop up the line into parameters we will be using 
			#file_name, network_or_local_mapping, keywords_to_watch, TZ_Offset_in_hours, watchwindow_in_days = _onefile.chomp.split(/\s*\|\s*/)
			name, mapping, keywords, offset, watchwindow = _onefile.chomp.split("|")
			
			#validates the parameters, certain things are not allowed to be null
			if name.to_s != ''
				name.strip!
			else 
				$log.warn("empty file name is not allowed!")
				next
			end
			
			#only watch the dir if it's specified
			if mapping.to_s != ''
				mapping.strip!
				dirToWatch.push(mapping)
			end
			
			if keywords.to_s != ''
				keywords = keywords.strip.scan(/\w+/)	
			else 
				keywords = []
			end
			
			#check to see if the following list of keywords are 
			# already part of the array. if not, add them. 
			def addSuperWord
				yield 'exception'
				yield 'fatal'
				yield 'crash'
			end
			addSuperWord{ |superword| 
				if (keywords.count(superword) == 0)					
					keywords.concat([superword])					
				end
			}													
			
			#absolute path
			filename = mapping+name

			if offset.to_s == ''
				offset = '0'
			end
			Integer(offset.strip!) & 24
			
			if watchwindow == ''
				watchwindow = '0'				
			end
			Integer(watchwindow.strip!) & 24
			
			
			if (File.file?(filename) && File.readable?(filename) && !File.socket?(filename)  )
				#$log.debug("#{filename} is being processed for keywords")
				
				#do some checks on the file before opening
				#size check for file larger than 10MB				
				if (File.size(filename).to_f/2**20 > $maxfilesize)
					$log.warn("#{filename} is a bit large, you probably want to take a gander first.")
					next
				end
				
				#again, no need to close the files, the block will do it
				#puts "checkFile with keywords: #{keywords} offset: #{offset} watchwidow: #{watchwindow}"
				checkFile(filename, keywords, offset, watchwindow)
			else
				$log.debug("#{filename} is not a readable file!")			
			end
		end	
	end
	$log.info("============Sentinel scan Completed========================")
	puts "Your log is waiting to be viewed at sentialWarning.log."
else 
	puts "sentinel config file is missing!\n"
end	
	





