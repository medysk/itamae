# frozen_string_literal: true

require './helper'
require 'itamae/secrets'

include_recipe './helper.rb'
Itamae::Recipe::EvalContext.include(RecipeHelper)

secret_node = File.join(__dir__, "secret/#{node['environment']}")

node['secrets'] ||= Itamae::Secrets(secret_node)
node['roles'].each(&method(:include_role))
