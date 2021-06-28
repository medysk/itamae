# frozen_string_literal: true

require './helper'

include_recipe './helper.rb'
Itamae::Recipe::EvalContext.include(RecipeHelper)

node['roles'].each(&method(:include_role))
