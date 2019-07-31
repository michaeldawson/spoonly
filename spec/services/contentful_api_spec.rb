require 'rails_helper'

describe ContentfulAPI do
  subject { described_class.new(space_id, environment_id, access_token) }

  let(:space_id) { 'SPACE-ID' }
  let(:environment_id) { 'ENVIRONMENT-ID' }
  let(:access_token) { 'ACCESS-TOKEN' }

  describe '#recipe_entries' do
    context 'when the service returns recipe_entries' do
      before { stub_service(:contentful_recipes_entries) }

      it 'returns the recipe data' do
        recipe_entries = subject.recipe_entries
        expect(recipe_entries['total']).to eq(4)
        expect(recipe_entries['items'].length).to eq(4)

        recipe = recipe_entries['items'].first
        expect(recipe.dig('sys', 'id')).to eq('437eO3ORCME46i02SeCW46')
      end
    end

    context 'when the service returns an error' do
      before { stub_service(:contentful_recipes_entries, status: 400) }

      it 'raises a network error' do
        expect {
          subject.recipe_entries
        }.to raise_error(
          ContentfulAPI::NetworkError
        )
      end
    end
  end
end
