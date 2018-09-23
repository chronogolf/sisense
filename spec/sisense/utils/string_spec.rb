RSpec.describe String do
  describe '#to_snake_case' do
    it 'converts any string to make the snake_case convention' do
      expect('MyString-needs_toBe-changed'.to_snake_case).to eq 'my_string_needs_to_be_changed'
    end
  end

  describe '#to_camel_case' do
    it 'converts any string to match the camelcase convention' do
      expect('my_string_needs_to_be_changed'.to_camel_case).to eq 'myStringNeedsToBeChanged'
    end
  end
end
