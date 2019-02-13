if category.is_a?(Hash)
  category.each do |key, value|
    xml.itunes :category, text: key do
      xml << render('category', category: value).gsub(/^/, '  ')
    end
  end
else
  xml.itunes :category, text: category
end
