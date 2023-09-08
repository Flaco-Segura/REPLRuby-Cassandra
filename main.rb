require 'dotenv/load'
require_relative 'config/application'
require_relative 'config/provider/database'
require 'dry/cli'

Dry::CLI.new(Cli).call

Application.finalize!
