class ContentfulAPI
  # Fetch one or more recipes from the Contenful API and provide them as simple data objects that
  # include accessible data on chefs, photos, tags etc
  class RecipeFetcher
    attr_reader :contentful_api, :recipe_id

    def self.all_recipes
      new(ContentfulAPI.default).recipes
    end

    def self.recipe(recipe_id)
      new(ContentfulAPI.default, recipe_id).recipes.first
    end

    def initialize(contentful_api, recipe_id = nil)
      @contentful_api = contentful_api
      @recipe_id = recipe_id
    end

    # Grab and parse recipes from the API
    def recipes
      recipe_entries['items'].map do |item|
        parse_recipe(item)
      end
    end

    private

    # Fetch recipes from the API. We memoize this here to make sure this is only ever done once when
    # we're using this object
    def recipe_entries
      @recipe_entries ||= contentful_api.recipe_entries(recipe_id)
    end

    # Group included items (chefs, tags, assets) by type for easy accessing
    def included_entries_by_type
      @included_entries_by_type ||= recipe_entries.dig('includes', 'Entry').group_by do |item|
        item.dig('sys', 'contentType', 'sys', 'id')
      end
    end

    def assets_by_id
      @assets_by_id ||= index_by_id(recipe_entries.dig('includes', 'Asset'))
    end

    def chefs_by_id
      @chefs_by_id ||= index_by_id(included_entries_by_type['chef'])
    end

    def tags_by_id
      @tags_by_id ||= index_by_id(included_entries_by_type['tag'])
    end

    # Merge in chef, photo and tags data to make it easily accessible in our frontend
    def parse_recipe(item)
      fields = item_fields(item)

      fields.merge(
        id: item.dig('sys', 'id'),
        chef: parse_chef(fields),
        photo: parse_photo(fields),
        tags: parse_tags(fields)
      ).deep_symbolize_keys
    end

    def parse_chef(fields)
      item_fields(chefs_by_id[fields.dig('chef', 'sys', 'id')])
    end

    def parse_photo(fields)
      item_fields(assets_by_id[fields.dig('photo', 'sys', 'id')])
    end

    def parse_tags(fields)
      return [] unless fields['tags']

      fields['tags'].map do |tag|
        item_fields(tags_by_id[tag.dig('sys', 'id')])
      end
    end

    def item_fields(item)
      item&.fetch('fields')
    end

    def index_by_id(collection)
      return {} unless collection

      collection.index_by { |item| item.dig('sys', 'id') }
    end
  end
end
