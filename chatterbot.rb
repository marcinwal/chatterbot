
# extending String class by adding colour methods
class String
  def black;          "\033[30m#{self}\033[0m" end
  def red;            "\033[31m#{self}\033[0m" end
  def green;          "\033[32m#{self}\033[0m" end 
  def brown;          "\033[33m#{self}\033[0m" end
  def blue;           "\033[34m#{self}\033[0m" end
  def magenta;        "\033[35m#{self}\033[0m" end
  def cyan;           "\033[36m#{self}\033[0m" end
  def gray;           "\033[37m#{self}\033[0m" end
  def bg_black;       "\033[40m#{self}\033[0m" end
  def bg_red;         "\033[41m#{self}\033[0m" end
  def bg_green;       "\033[42m#{self}\033[0m" end
  def bg_brown;       "\033[43m#{self}\033[0m" end
  def bg_blue;        "\033[44m#{self}\033[0m" end
  def bg_magenta;     "\033[45m#{self}\033[0m" end
  def bg_cyan;        "\033[46m#{self}\033[0m" end
  def bg_gray;        "\033[47m#{self}\033[0m" end
  def bold;           "\033[1m#{self}\033[22m" end
  def reverse_color;  "\033[7m#{self}\033[27m" end
end

#adding new ikey,ivalue to table if teacher mode was selected
def teacher(ikey,ivalue)
	puts 'adding'.red
	RESPONSES[ikey]=ivalue unless RESPONSES.key?(ikey)
end

def get_response(input)
  key = RESPONSES.keys.select {|k| /#{k}/ =~ input }.sample
  /#{key}/ =~ input
  response = RESPONSES[key]
  response.nil? ? 'sorry?' : response % { c1: $1, c2: $2, c3: $3}
  #teacher() if ($pattern =~ input)
end

#saving human chats from script to path file
def save_human_script(path,script)
  begin	
  	puts "Saving/overwritting the file #{path}."
	file=File.open(path,"w")
	script.each do |line| 
		file.write(line+"\n")
	end	
  rescue IOError
  	puts "Some file error occured".red
  ensure
  	file.close unless file==nil
  end
end  		
  	

#reading previous chats to script from path file
def load_human_history(path,script)
  begin	
  	puts "Reading the file #{path}."
	file=File.open(path,"r")
	file.each_line do |line|
		script << line
	end	
  rescue IOError
  	puts "Some file error occured".red
  ensure
  	file.close unless file==nil
  end
end  		


PATTERN = /teacher: k=(.*) v=(.*)/   #pattern for adding new key-value pairs
PATH = 'human.txt'				 #file for storing human inputs


RESPONSES = { 'goodbye' => 'bye', 
              'sayonara' => 'sayonara', 
              'the weather is (.*)' => 'I hate it when it\'s %{c1}', 
              'I love (.*)' => 'I love %{c1} too', 
              'I groove to (.*) and (.*)' => 'I love %{c1} but I hate %{c2}',
          	  'Buy me a (.*)' => 'I would love to buy you %{c1} but I am just a bot',
          	  'Do you like me' => 'Yes',
          	  'What is your name ?' => 'BOT',
          	  'Do you like (.*)\?' => 'I do not think i like %{c1}',
          	  'how many responses you know' => 'as many as you like',
          	  'quit' => 'thank you for the chat',
          	  'buy me (.*) or (.*) but not (.*)' => 'i will try to buy %{c1} or %{c2} but not %{c3}',
          	  'teacher: k=(.*) v=(.*)' => 'adding new k=%{c1} v=%{c2} to my dictionary'}

human=[] #storing human's responses
load_human_history(PATH,human)
#puts human
#exit(0)

puts "Hello, what's your name?"
name = gets.chomp
human << name   #starts collecting human's responses
puts "Hello #{name}>"

while(input = gets.chomp) do
  human << input	
  puts "bot>#{get_response(input)}".blue
  a=input =~ PATTERN   #option to add more pairs to dictionary in teacher mode "teacher: k=key_sentence v=reply"
  teacher($1,$2) unless a==nil
  print "#{name}>"
  break if input == 'quit'
end

save_human_script(PATH,human)

#p human