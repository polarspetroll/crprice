#!/usr/bin/ruby
require 'cryptocompare'
require 'net/smtp'
require 'mysql'
require 'colorize'

inputs = Array(ARGV)
#------functions------#
def help()
  puts "
    crprice.rb [options]

    options :
    --currency    type of currency to check(default : BTC)
    --time        time to check and send email every day(default : 12:00)
    --smtp-domain smtp server domain(default : localhost)
    --smtp-port   smtp server port(default : 25)
    --smtp-usr    username for smtp
    --smtp-passwd password for smtp(default : null)
    --from        email of sender
    --db-passwd   password for database
    --email       email of recever
    --history     get the history of last checks
    "
end
######################################
def insert_data(cap_time)
  db = Mysql.connect('127.0.0.1', 'root', @db_passwd, 'crprice')
  db.query("INSERT INTO data VALUES('#{@currency}', '#{cap_time}', '#{@primary_data}');")
end
######################################
def send_mail(body)
  messege = "Subject: currency report☚\n\n#{body}"
  smtp = Net::SMTP.new @smtp_domain, @smtp_port
  smtp.enable_starttls
  smtp.start(@smtp_domain, @smtp_usr, @smtp_passwd, :plain) do
    smtp.send_message(messege, @from, @email)
  end
end
######################################
def history()
  db = Mysql.connect('127.0.0.1', 'root', @db_passwd, 'crprice')
  db.query("select * from data").each do |col|
    p col
  end
end
##------end of functions------##

######checking the inputs######
if inputs[0] == nil
  help()
  abort
end
###############################
if inputs.include?("--history")
  if inputs.index("--db-passwd") != nil
    begin
  @db_passwd = inputs[(inputs.index("--db-passwd") + 1)]
  @db_passwd.to_s
  history()
  abort
rescue
  abort "error! incorrect password for database".light_red.bold
end
else
  abort "you need to declare database password to accessing history".light_red.bold
end
end
###############################
if inputs.include?("-h")
  help()
  abort
end
###############################
if inputs.index("--email") != nil
  @email = inputs[(inputs.index("--email") + 1 )]
  @email.to_s
else
  abort "no email address epecified".red.bold
end
###############################
if inputs.index("--currency") != nil
  @currency = inputs[(inputs.index("--currency") + 1 )]
  @currency.to_s
else
  @currency = "BTC"
end
###############################
if inputs.index("--time") != nil
  @check_time = inputs[(inputs.index("--time") + 1)]
  @check_time.to_s
else
  @check_time = "12:00"
end
###############################
if inputs.index("--smtp-domain") != nil
  @smtp_domain = inputs[(inputs.index("--smtp-domain") + 1)]
  @smtp_domain.to_s
else
  @ssmtp_domain = "localhost"
end
###############################
if inputs.index("--smtp-port") != nil
  @smtp_port = inputs[(inputs.index("--smtp-port") + 1)]
  @smtp_port.to_i
else
  @smtp_port = 25
end
###############################
if inputs.index("--smtp-passwd") != nil
  @smtp_passwd = inputs[(inputs.index("--smtp-passwd") + 1)]
  @smtp_passwd.to_s
else
  @smtp_passwd = nil
end
###############################
if inputs.index("--smtp-usr") != nil
  @smtp_usr = inputs[(inputs.index("--smtp-usr") + 1)]
  @smtp_usr.to_s
else
  abort "no smtp username specified".red.bold
end
###############################
if inputs.index("--from") != nil
  @smtp_usr = inputs[(inputs.index("--from") + 1)]
  @smtp_usr.to_s
else
  abort "no sender specified".red.bold
end
###############################
if inputs.index("--db-passwd") == nil
  abort "error. no database password specified.".red.bold
else
  @db_passwd = inputs[(inputs.index("--db-passwd") + 1)]
  @db_passwd.to_s
end
#-----------end of input check -----------#
puts "server is running...".light_green.bold
loop {
  clock = Time.now
  @local_time = "#{clock.hour}:#{clock.min}"
  while @check_time == @local_time
    price = Cryptocompare::Price.find(@currency, 'USD')
    avg = Cryptocompare::Price.day_avg(@currency, 'USD')
    @primary_data = price[@currency]['USD']
    @secondary_data = avg['USD']
    @captured = Time.now
    insert_data(@captured)
    @text = "
    type of currency : #{@currency}.
    today's price : #{@primary_data}$.
    today's average price : #{@secondary_data}$.
    data captured at #{@captured}.

    Thanks for using crprice. ♥
"
    send_mail(@text)
    sleep(60)
    break
  end
}
