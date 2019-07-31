require 'rails_helper'

# The 'js' tag is not necessary to run the test, but it makes debugging easier to watch tests
# execute in the chrome browser.
feature 'Recipes', js: true do
  context 'when the contentful API returns recipes' do
    before do
      stub_service(:contentful_recipes_entries)
      stub_service(:contentful_recipe_entries)
    end

    scenario 'I can view all recipes, and click through to view a single recipe' do
      visit recipes_path
      expect(page).to have_content('White Cheddar Grilled Cheese with Cherry Preserves & Basil')

      click_on 'White Cheddar Grilled Cheese with Cherry Preserves & Basil'
      expect(page).to have_content('*Grilled Cheese 101*')
    end
  end
end
