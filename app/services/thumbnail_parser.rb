class ThumbnailParser
  attr_reader :src, :data, :page, :image_type, :image_size, :cached_file

  def initialize(url)
    @url = url
    parse
  end

  def self.parse(url)
    new(url)
  end

  def parse
    # TODO: zkusit tohle vyresit jinak
    LinkThumbnailer.generate('http://localhost:3000/test_product')
    @page = LinkThumbnailer::Page.new(@url)
    @data = @page.generate
    @src = @page.source
  end

  def is_image?
    file = open(@url.gsub("\u0000", ''))
    content_type = file.content_type
    if content_type.split('/').first == 'image'
      @image_type = content_type.split('/').last
      @image_size = file.size
      true
    else
      false
    end
  end

  def resize_image
    image = MiniMagick::Image.open(@cached_file)
    image.resize "600x600"
    image.write @cached_file
    binding.pry
  end

  def save_image
    if is_image?
      ThumbnailParser.as_ascii_8bit do      
        filename = ['image', 'cache', (Time.now.to_i), @image_type].join('.')
        @cached_file = 'tmp/' + filename
        File.open(@cached_file, 'w') { |file| file.write(@src) }
      end
      true
    else
      false
    end
  end

  def self.as_ascii_8bit
    Encoding.default_external = Encoding::ASCII_8BIT
    yield
    Encoding.default_external = Encoding::UTF_8
  end

  def contains_data?
    return false if @data[:images].blank? && @data[:title].blank?
  end

  def image=(url)
  end
end