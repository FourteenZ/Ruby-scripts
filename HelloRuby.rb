# Sep, 2013 - checkin to github
#KYC, this is a testing module to test various functionalities of Ruby
#puts "hello ruby!"

#Testing of regular function
def sayGoodnight(name)
# this #{xxx} thing is called expression interpolation
"Goodnight, #{name}"
end

#puts sayGoodnight("Tobey")

puts ENV['HOME']

#Testing Windows GUI
=begin
require 'win32/autogui'
include Autogui::Input

class Calculator < Autogui::Application
  def initialize
	super :name => "calc", :title => "Calculator"
  end
  def edit_window
	main_window.children.find {|w| w.window_class == 'Edit'}
  end
end
calc = Calculator.new
calc.running?
calc.pid
calc.main_window.window_class
calc.main_window.children.count
calc.set_focus; type_in('2+2=')
calc.edit_window.text
calc.close
calc.running?
=end

#Testing external process
=begin
#system("cat /etc/passwd")
#system("dir")
#or 
#extern = `dir`
#puts("listing directories #{extern}")
rb = IO.popen("ruby", "w+")
rb.puts "puts 'whoa! subprocess, dude!'"
rb.close_write
puts rb.gets
=end

#Testing threads
=begin
mate = Thread.new do
               puts "Ahoy! Can i be dropping the anchor sir"               
               Thread.stop               
               puts "Aye sir, dropping anchor"
end
captain = Thread.new do
	puts "CAPTAIN: Aye, laddy!"
	mate.run	
end
#mate.run
mate.join
captain.join
=end


#Testing arrays and hashes
=begin
a = [1, 'cat', 3.14]
#puts a[2]	

instSection = {
    'cello' => 'string',
    'drum' => 'percussion',
    'violin' => 'string'
}
#puts instSection['violin']
#puts instSection['piano']
=end

#puts "Danger, will robinson" if radiation > 3000
=begin
#Testing regular expressions
line = "Perl"
if line=~ /Perl|Python/
#    puts "scripting language mentioned: #{line}"
else
	puts "Can't find matching string!"
end


#Testing reg expression
#line="How I like to be good at Perl"
#line = "How I like to be good at Perl".gsub(/Perl/, 'Ruby')
#puts line
=end

animals = %w(ant bee cat dog elk)
#animals.each{|animal| puts animal }

#Testing puts, print and printf
#printf("Number: %5.2f, \nString: %s\n", 1.23, "Hello")

#Testing looping
#5.times{ print "*"}
#3.upto(6) {|i| print i}
#('a'..'e').each{|char| print char}

#Testing of getting user inputs
#ARGF.each{|line| print line if line =~ /Ruby/}

#Testing class creation
class Song
	attr_reader :name, :artist, :duration
	def initialize(name, artist, duration)
		@name = name
		@artist = artist
		@duration = duration
	end
end

song1 = Song.new("my way", "Beatles", 300)
#print song1.artist

#testing instance variable setters
class Song
	def duration=(new_duration)
		@duration = new_duration
	end
end
song1.duration=240
#print song1.duration

#testing assigning objects
#person1 = "Tim"
#person2 = person1
#print person1 + ' ' + person2 
#person1[0] = 'J'
#print person1 + ' ' + person2 


#Testing the iterators, "each", "find" and something called "collect"
#[1,3,5,7,9].each {|i| puts "\n#{i}"}
print "\n"
#puts [1,3,5,7,9].find {|y| y*y>30}

#another example of block
def fib_up_to(max)
	i1, i2 = 1, 1 
	while i1 <= max
		yield i1
		i1, i2 = i2, i1+i2
	end
end
#fib_up_to(1000) {|f| print f, " "}


#puts 2.methods

#puts 2.between?(1,3)


#Testing usage of other libs
#require 'fileutils'
#FileUtils.cp("FileToScan.ini", "logFileList.cfg")


=begin
File parsing example
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



#testing reading an XML file into objects
#require 'rexml/document'
#require 'xmlsimple'
#config = XmlSimple.xml_in('WSProvider.xml', {})


#res= "Testing       12     3 4 5".squeeze(' ')
#puts res


#test command line argument
=begin
if ARGV.size > 0
	puts ARGV[0]
else
	puts "no arguments detected"
end
=end

=begin
require 'getoptlong'
unless ARGV.length == 4
	puts "I need more arguments"
	exit
end
opts = GetoptLong.new(
	["--hostname", "-h", GetoptLong::REQUIRED_ARGUMENT],
	["--port", "-n", GetoptLong::REQUIRED_ARGUMENT],
	["--username", "-u", GetoptLong::REQUIRED_ARGUMENT],
	["--pass", "-p", GetoptLong::REQUIRED_ARGUMENT]
	)

#process the parses options
opts.each do |opt, arg|
	case opt
	when '--hostname'
		host_name = arg
	when '--port'
		port_no = arg
	when '--username'
		user_name = arg
	when '--pass'
		password = arg
	end
end
=end

#str='hello'
#print Array(str).class

=begin
def get_files(path)
	#Dir.glob("#{path}/**/*").each{|e| puts e}
	Dir.glob("#{path}/*").each{|e| puts e}
end

get_files("//TRN-IVR-SV01/ScriptedIVR")
=end

=begin
#testing logging
#require 'logger'
#log = Logger.new('log.txt')
#log.debug "Log file created"
=end


=begin
#testing enumerator like all, each..
%w[ant bear cat].all? do |word| 
	if word.length >= 3 
		puts word 
	end
end
=end

=begin
require 'rubygems'
require 'net/ssh'

@hostname = "192.168.1.68"
@username = "root"
@password = "linux_admin"
@cmd = "ls -al"

 begin
    ssh = Net::SSH.start(@hostname, @username, :password => @password)	
    res = ssh.exec!(@cmd)
    ssh.close
    puts res
  rescue
    puts "Unable to connect to #{@hostname} using #{@username}/#{@password}"
  end
=end  

=begin
#Testing ssh to something
require 'net/ssh'
 def execute_ssh(commands) 
    begin
    
      results = {}
    
      Timeout::timeout(2) do
        begin
          Net::SSH.start( '192.168.1.68', 'root', 
            :password => 'linux_admin', :port => 22 ) do |ssh|
            
            commands.each { |command|
              results[command] = ssh.exec!(command)
            }
          end  
        rescue Net::SSH::HostKeyMismatch => e
          e.remember_host!
          retry
        rescue StandardError => e
          return e.to_s
        end
      end
    
      return results
    
   rescue Timeout::Error
      return "Timed out trying to get a connection"
    end
  end
  
  linuxcommands = ['ls', 'pwd', 'cd /etc/asterisk', 'file extensions.conf']
  execute_ssh(linuxcommands)
  
=end

#puts 5*Integer("-3")

#testing time
=begin
require 'time'
puts Time.parse('2013-02-25 11:34:11')
=end 

=begin
#test scan and time arithmetic
class Time
	def inDays 
		#puts self
		return self.to_i/60/60/24
		#print "in what days\n"
	end
end
require 'time'
testStr = '13/03/18 16:56:06 [5752] DEBUG filelogger %% - Active WS provider UT2 was discovered. [.\wservice.cpp:884]'
#testStr.scan(/(\d{2}\/\d{2}\/\d{2}\s*\d{2}:\d{2}:\d{2})(\w*)/) {|a,b| puts "#{a}"}
testStr.scan(/(\d{2}\/\d{2}\/\d{2}\s*\d{2}:\d{2}:\d{2})(.*)/) do |a,b,c| 
	print "#{a}\n"
	print "#{b}\n"
	print "#{c}\n"
	#puts Time.parse(a)
	logTime = Time.parse(a)
	puts Time.now.inDays - logTime.inDays 

	if ( (Time.now.inDays - logTime.inDays) < 15)
		print "#{logTime} \n"
	else 
		puts "outside of watch window"
	end
end
require 'date'


test_date = '2/20/2012 6:46:00'
last_login = DateTime.strptime(test_date, '%m/%d/%Y %l:%M:%S')

test_date = '05/10/2012 16:46:00'
last_login = DateTime.strptime(test_date, '%m/%d/%Y %L:%M:%S')

test_date = '12/10/2012 16:46:00'
last_login = DateTime.strptime(test_date, '%m/%d/%Y %L:%M:%S')

puts last_login
=end

#testing of mysql 
#begin
require  'Mysql'
begin
	#con = Mysql.new '192.168.1.63', 'ivr', 'ivr', 'outbound'
	con = Mysql.new 'localhost', 'root', '', 'mysql'
	#puts con.get_server_info
	#rs = con.query 'select version()'
	#puts rs.fetch_row
	con.list_dbs.each do |db|
		puts db
	end
	#rs = con.query("select * from callees")
	rs = con.query("select * from help_category")
	n_rows = rs.num_rows
	n_rows.times do 
		puts rs.fetch_row.join("\s")
	end
	
rescue Mysql::Error => e
	puts e.errno
	puts e.error
	
ensure
	con.close if con
end
#end

#Testing expressions
#puts `dir`

#This block is quite interesting, it tests a couple of things
# 1. gets user input
# 2. make the block more dynamic with the use of & and lambda
=begin
print "(t)imes or (p)lus: "
times = gets
print "number: "
number = Integer(gets)
if times =~ /^t/
calc = lambda {|n| n*number }
else
calc = lambda {|n| n+number }
end
puts((1..10).collect(&calc).join(", "))
=end

#experiement with time and datetime
#puts Time.now
#puts DateTime.parse

#experiement with conditional statements
#eg
=begin
date = "04-11-67"
mon, day, year = $1, $2, $3 if date =~ /(\d\d)-(\d\d)-(\d\d)/
debug = true
puts "a=#{a}" if debug
total = 0
print total unless total.zero? 
=end

#example of case statement
=begin
require 'Date'
year = DateTime.now.year-1
puts leap = case
	when year % 400 == 0 then true
	when year % 100 == 0 then false
	else	 year % 4 == 0
	end 
=end

#windows automation using the builtin win32ole object
=begin
require 'WIN32OLE'
ie = WIN32OLE.new('InternetExplorer.Application')
ie.visible = true
ie.gohome
=end

=begin
File.open("sentialWarning.log") do |lines|
	lines.each do |line|
		if (line =~ /Scanning/)
			puts line
		end
	end
end
=end

=begin
#test assignments
#x=y=z=10
x='testing'
y=x
y.chop!
puts x
x=10
y=x
y=y+1
puts x
=end

#Test SMTP mail
=begin
require 'action_mailer'

ActionMailer::Base.delivery_method = :smtp

ActionMailer::Base.smtp_settings = {
    :address => "smtp.gmail.com",
    :port => 587,
    :domain => 'gmail.com',
    :authentication => :plain,
    :user_name => 'kaiyuchen53',
    :password => '',
    :enable_starttls_auto => true,
    :tls => true
#    
}

ActionMailer::Base.raise_delivery_errors = true
ActionMailer::Base.perform_deliveries = true
ActionMailer::Base.default :from => 'kaiyuchen53@gmail.com'

m = ActionMailer::Base.mail :to => 'kaiyu.chen@ssc-spc.gc.ca', :subject => 'this is a test', :body => 'this is a test body'
m.deliver
=end

=begin
class Notifier < ActionMailer::Base
  def email(address)
    recipients  "kaiyu.chen@ssc-spc.gc.ca"
    from        "kaiyuchen53@gmail.com"
    subject     "Hello World"
    body        "this is a test body"
  end
end
 
# TLS settings are for gmail, not needed for other mail hosts.
Notifier.delivery_method = :smtp
Notifier.smtp_settings = {
  :tls => true,
  :enable_starttls_auto => true,
  :address => "smtp.gmail.com",
  :port => 587,
  :domain => "gmail.com",
  :user_name => "kaiyuchen53@gmail.com",
  :password => "Lynxab",
  :authentication => :plain
}
 
#Notifier.deliver_email("kaiyu.chen@ssc-spc.gc.ca")
Notifier.deliver("kaiyu.chen@ssc-spc.gc.ca")
=end
