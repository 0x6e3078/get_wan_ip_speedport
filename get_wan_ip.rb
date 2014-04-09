#!/usr/bin/env ruby

password=''

#
# Read config
def read_config(file)
    #PASSWORD in HASH
    File.open(file, "r").each_line do |line|
	    begin
            # configname = value
            data = line.split("=")
            config, value = line.chomp.split("=")
            if config[0] == "#"
            elsif config == "passwd"
                $password=value
            end
        rescue
		end
    end
end

#
# login on speedport
def login(password)
    _output = `curl -s "http://speedport.ip/data/Login.json" --data "password=#{password}&showpw=0" --referer "http://speedport.ip/html/login/?lang=en" --cookie-jar /tmp/speedport.cookie`
    result=$?.exitstatus
#    puts "Login Result: " + _output.to_s
	return result
end

#
# logout from speedport
def logout()
    _output=`curl -s "http://speedport.ip/data/Login.json" --data "logout=byby" --referer "http://speedport.ip/html/login/?lang=en" --cookie-jar /tmp/speedport.cookie`
    result=$?.exitstatus
#    puts "Logout result: " + _output.to_s
	return result
end

#
# get html page from hidden website and "parse"
def get_hidden_wan_status()
	res=""
    _output=`curl -s http://speedport.ip/hidden/interfaces_hidden_wan.stm  --referer "http://speedport.ip/hidden/interfaces_hidden_wan.stm" --cookie "/tmp/speedport.cookie" --cookie-jar "/tmp/speedport.cookie" `
    result=$?.exitstatus
	_output.to_s.each_line do |line|
        if line.include? "inte_face_ip\[0\]"
			res=line.split("=")[1].tr('\"','')
		end
	end
    return res
end

if __FILE__ == $0
	if ARGV.length == 1
	    read_config(ARGV[0])
	else
        read_config("./config.txt")
	end
	login($password)
	IP=get_hidden_wan_status()
	logout()
    puts "WAN IP: " + IP.to_s
    exit 0
end


