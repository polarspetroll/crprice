#!/usr/bin/env bash
if [ `whoami` != 'root' ]
  then
    echo -e "\e[91mI need root privilege!"
    exit
fi

if [ -f /etc/init.d/mysql* ]; then
  echo -e "\e[32mmysql : installed ⎷\n"
else
    echo "\e[91mmysql not installed. install mysql and run the script again.\n"
    exit
fi
	

echo -e "\e[94mcreating database requirements..."
echo -e "\e[93menter your mysql password"
mysql -u root -p crprice < tables.sql
echo -e "\e[92mTable created⎷\n"
echo -e "\e[35minstalling ruby..."
echo -e "\e[39m"
apt install ruby -y

echo -e "\n\e[33minstalling gems..."
echo -e "\e[34m"
gem install net-smtp
gem install cryptocompare
gem install colorize
gem install ruby-mysql

chmod +x crprice.rb
cp crprice.rb /usr/local/bin

echo -e "\n\e[96m Done!"
