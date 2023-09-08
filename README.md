# REPLRuby-Cassandra

A Read-Eval-Print Loop created in ruby using Cassandra as DB
The REPL interacts with a playlist DB with the following attributes:
- title : The title of the song
- album : The name of the album
- artist : The artist of the song

## Start application

`docker compose up -d`

## Using the application

You should use the ruby container with `docker exec -it cassruby-ruby-1 sh`

Inside the terminal you can use `ruby main.rb` to list the available commands

### List of available commands

- `ruby main.rb add` add a new register
  
- `ruby main.rb list` list the registers
  
- `ruby main.rb delete` remove the selected register
  
- `ruby main.rb update` update the selected register
