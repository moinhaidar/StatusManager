## Setup
- rake db:create
- rake db:migrate
- rake db:seed

## Setup foreman Configuration
web: rails server -p  <port_number>
mail:  mailcatcher


## Access the admin
- Start your server
    ``
        forman start
    ``
- go to http://<host>:<port>/smadmin
- If it is unicorn. Access the localhost at 8080. Since unicorm default port is 8080

## Access to local email interface - Mailcatcher
http://localhost:1080


