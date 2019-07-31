require 'rails_helper'

describe ContentfulAPI::RecipeFetcher do
  subject { described_class.new(ContentfulAPI.default) }

  describe '#recipes' do
    before { stub_service(:contentful_recipe_entries) }

    it 'returns recipes data with chef, tag and photo data merged in' do
      recipes = subject.recipes

      recipe = recipes.first

      expect(recipe[:title]).to eq("Crispy Chicken and Rice\twith Peas & Arugula Salad")
      expect(recipe.dig(:chef, :name)).to eq('Jony Chives')
      expect(recipe.dig(:photo, :file, :url)).to eq('//images.ctfassets.net/kk2bw5ojx476/5mFyTozvSoyE0Mqseoos86/fb88f4302cfd184492e548cde11a2555/SKU1479_Hero_077-71d8a07ff8e79abcb0e6c0ebf0f3b69c.jpg')
      expect(recipe[:tags].length).to eq(2)
    end
  end
end
