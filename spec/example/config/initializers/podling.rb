Podling.configure do
  name         'The Pod People'
  description  'A sample podcast'
  url          'https://example.com'
  author_name  'Mr Pod'
  author_email 'podling@example.com'
  keywords     'example, test, podcast'
  explicit     :no
  categories   'Music', 'Technology' => 'Podcasting'
end
