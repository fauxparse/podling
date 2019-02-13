module Podling
  class Podcast
    include Singleton
    include ActiveModel::Validations

    CATEGORIES = {
      'Arts' => [
        'Design',
        'Fashion & Beauty',
        'Food',
        'Literature',
        'Performing Arts',
        'Visual Arts'
      ],
      'Business' => [
        'Business News',
        'Careers',
        'Investing',
        'Management & Marketing',
        'Shopping'
      ],
      'Comedy' => [],
      'Education' => [
        'Educational Technology',
        'Higher Education',
        'K-12',
        'Language Courses',
        'Training'
      ],
      'Games & Hobbies' => [
        'Automotive',
        'Aviation',
        'Hobbies',
        'Other Games',
        'Video Games'
      ],
      'Government & Organizations' => [
        'Local',
        'National',
        'Non-Profit',
        'Regional'
      ],
      'Health' => [
        'Alternative Health',
        'Fitness & Nutrition',
        'Self-Help',
        'Sexuality'
      ],
      'Kids & Family' => [],
      'Music' => [],
      'News & Politics' => [],
      'Religion & Spirituality' => [
        'Buddhism',
        'Christianity',
        'Hinduism',
        'Islam',
        'Judaism',
        'Other',
        'Spirituality'
      ],
      'Science & Medicine' => [
        'Medicine',
        'Natural Sciences',
        'Social Sciences'
      ],
      'Society & Culture' => [
        'History',
        'Personal Journals',
        'Philosophy',
        'Places & Travel'
      ],
      'Sports & Recreation' => [
        'Amateur',
        'College & High School',
        'Outdoor',
        'Professional'
      ],
      'Technology' => [
        'Gadgets',
        'Tech News',
        'Podcasting',
        'Software How-To'
      ],
      'TV & Film' => []
    }.freeze

    def self.attribute(name, default_value = nil)
      define_method name do |*args|
        if args.length == 1
          instance_variable_set(:"@#{name}", args.first)
        elsif args.empty?
          instance_variable_get(:"@#{name}") || default_value
        else
          raise ArgumentError,
                "wrong number of arguments (given #{args.size}, expected 1)"
        end
      end
    end

    attribute :name
    attribute :description
    attribute :url
    attribute :author_name
    attribute :author_email
    attribute :keywords, ''
    attribute :language, 'en'
    attribute :explicit, :no

    validates :name, :description, :url, :author_name, :author_email,
              presence: true
    validates :explicit, inclusion: { in: %i[yes no clean] }
    validate :itunes_categories

    def categories(*args)
      @categories ||= []
      @categories += args
    end

    private

    def itunes_categories
      categories.each do |category|
        errors.add :categories, "may not include #{category.inspect}" \
          unless valid_itunes_category?(category)
      end
    end

    def valid_itunes_category?(category, root = CATEGORIES)
      if category.is_a?(Hash)
        category.inject(true) do |valid, (key, value)|
          valid &&
            root.include?(key) &&
            (root.is_a?(Array) || valid_itunes_category?(value, root[key]))
        end
      else
        root.include?(category)
      end
    end
  end

  def self.configure(&block)
    podcast.instance_eval(&block)

    podcast.validate!
  end

  def self.podcast
    Podcast.instance
  end
end
