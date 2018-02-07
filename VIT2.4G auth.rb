require 'rubygems'
require 'mechanize'
require 'restclient'


Thread.new do
	loop do
		if Time.now.strftime("%H:%M")=="00:28"
			RestClient.get("http://phc.prontonetworks.com/cgi-bin/authlogout")
			puts "\nUser logged out. Time for proxy.\n"
			system("REG ADD \"HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings\" /v ProxyEnable /t REG_DWORD /d 1 /f")
			gets
			exit
		end
		sleep(60)
	end
end


agent = Mechanize.new
loop do
	puts "\n1. Login"
	puts "2. Logout"
	puts "3. Check Status"
	inp=gets.chomp
	inp=inp.to_i
	if inp==1
		check= agent.get("http://www.vit.ac.in/")
		if check.title=="Redirect"
			page = agent.get('http://phc.prontonetworks.com/cgi-bin/authlogin?URI=http://go.microsoft.com/fwlink/&LinkID=219472&clcid=0x409')
			google_form = page.form()
			puts "\nEnter user ID "
			uid=gets.chomp
			google_form.userId=uid
			puts "Enter Password "
			pid=gets
			google_form.password=pid
			page=agent.submit(google_form)#
			#puts page.title
			if page.title=="Successful Pronto Authentication"
				puts "User logged in!"
			else
				puts "Invalid Credentials"
			end
		else
			puts "User already logged in."
		end
	elsif inp==2
		RestClient.get("http://phc.prontonetworks.com/cgi-bin/authlogout")
		puts "Logged out"
	else
		check= agent.get("http://www.vit.ac.in/")
		if check.title=="Redirect"
			puts "User is logged out"
		else
			puts "User is logged in"
		end
	end
end