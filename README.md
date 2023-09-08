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

- `ruby main.rb add` add a new register. Example: `ruby main.rb add "Rough Ridin" "The Good Neighbors Jazz" "Major Molley"`
  
- `ruby main.rb list` list the registers. Example `ruby main.rb list`
  
- `ruby main.rb delete` remove the selected register after to be listed the registers on the DB. Example `ruby main.rb delete`
  
- `ruby main.rb update` update the selected register. It is necessary to include all the fields as you been adding a new register. Example `ruby main.rb update "Rough Ridin" "The Good Neighbors Jazz" "Major Molley, Casé"`
