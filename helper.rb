# frozen_string_literal: true

# Helper
module RecipeHelper
  def include_recipes(*recipes)
    recipes.flatten.each do |recipe|
      path = File.expand_path("cookbooks/#{recipe}/default.rb", __dir__)
      include_recipe path
    end
  end

  def include_role(name)
    path = File.expand_path("roles/#{name}.rb", __dir__)
    include_recipe path
  end
end
