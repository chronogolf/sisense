RSpec.describe String do
  describe '#underscore' do
    it 'converts any string to make the snake_case convention' do
      expect('MyString-needs_toBe-changed'.underscore).to eq 'my_string_needs_to_be_changed'
    end
  end

  describe '#camelize' do
    it 'converts any string to match the camelcase convention' do
      expect('my_string_needs_to_be_changed'.camelize).to eq 'myStringNeedsToBeChanged'
    end
  end
end
