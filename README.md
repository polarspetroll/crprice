# :moneybag:crprice:moneybag:

currency price checker including mail notifier and database
# feature
- email notification 

- automatic data sorting

- easy to use
## introduction 
this script makes your life easier! all you need is mail server and database .
this script sends you any currency prices every day , Just check your email ! 
after each time of price checkings , it will automatically sorts the price in database so you can check them anytime.

### requirements

- :globe_with_meridians: **mysql**

- :diamonds: **ruby**

- :email: **smtp server** (I used free google smtp server)

### installation

**creating database**:hammer:

after you installed mysql , its time to create database.

```sql
CREATE DATABASE crprice;
```

**installing the program**:wrench:

```bash
git clone https://github.com/polarspetroll/crprice.git && cd crprice

chmod +x install.sh

./install.sh
```
### options
```
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
```
#### included informations 

- price of currency. 
- average price of currency in past 24h.

#### view history in Mysql(recommended)

```sql
USE crprice;

SELECT * FROM data;
```
