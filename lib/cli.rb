# frozen_string_literal: true

require 'dry/cli'

module Cli
  extend Dry::CLI::Registry

  register 'add', Commands::Add
  register 'list', Commands::List
  register 'delete', Commands::Delete
  register 'update', Commands::Update
end
