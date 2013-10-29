class GrayscaleImage
  attr_reader :width
  attr_reader :height
  attr_reader :pixels

  def [](x, y) @pixels[y * @width + x] end
  def []=(x, y, brightness) @pixels[y * @width + x] = brightness end

  def initialize(width, height)
    @width, @height = width, height
    @pixels = Array.new(@width * @height, 0)
  end

  def self.rgb_delta28_image(image1, image2)
    width = [image1.width, image2.width].min
    height = [image1.height, image2.height].min
    output_image = GrayscaleImage.new(width, height)
    y=0
    while y < height
      x=0
      while x < width
        pixel1 = image1.get_pixel(x, y)
        pixel2 = image2.get_pixel(x, y)
        if pixel1 != pixel2
          output_image[x, y] = rgb_delta28(pixel1, pixel2) #upto 255*3
        end
        x += 1
      end
      y += 1
    end
    output_image
  end

  # Note that the edge image is offset by half a pixel in the negative X direction
  # since at (x,y) source pixels (x,y) and (x-1,y) are compared.
  def self.rgb_delta28_contrast_image_x(image)
    width, height = image.width, image.height
    output_image = GrayscaleImage.new(width, height)
    y = 0
    while y < height
      x = 1
      while x < width
        output_image[x, y] = rgb_delta28(image.get_pixel(x, y), image.get_pixel(x - 1, y))
        x += 1
      end
      y += 1
    end
    output_image
  end

  # Note that the edge image is offset by half a pixel in the negative Y direction
  # since at (x,y) source pixels (x,y) and (x,y-1) are compared.
  def self.rgb_delta28_contrast_image_y(image)
    width, height = image.width, image.height
    output_image = GrayscaleImage.new(width, height)
    y = 1
    while y < height
      x = 0
      while x < width
        output_image[x, y] = rgb_delta28(image.get_pixel(x, y), image.get_pixel(x, y - 1))
        x += 1
      end
      y += 1
    end
    output_image
  end

  def to_chunkypng_image
    output_image = ChunkyPNG::Image.new(width, height)
    y = 0
    while y < height
      x = 0
      while x < width
        val = self[x, y]
        output_image.set_pixel(x, y, ChunkyPNG::Color::rgb(val, val, val))
        x += 1
      end
      y += 1
    end
    output_image
  end

  # Note that the edge image is offset by half a pixel in the negative X direction
  # since at (x,y) source pixels (x,y) and (x-1,y) are compared.
  def contrast_image_x
    output_image = GrayscaleImage.new(@width, @height)
    y = 0
    while y < height
      x = 1
      while x < width
        output_image[x, y] = (self[x, y] - self[x - 1, y]).abs
        x += 1
      end
      y += 1
    end
    output_image
  end

  def +(other)
    width = [self.width, other.width].min
    height = [self.height, other.height].min
    output_image = GrayscaleImage.new(width, height)
    y=0
    while y < height
      x=0
      while x < width
        output_image[x, y] = self[x, y] + other[x, y]
        x += 1
      end
      y += 1
    end
    output_image
  end

  # Note that the edge image is offset by half a pixel in the negative Y direction
  # since at (x,y) source pixels (x,y) and (x,y-1) are compared.
  def contrast_image_y
    output_image = GrayscaleImage.new(@width, @height)
    y = 1
    while y < height
      x = 0
      while x < width
        output_image[x, y] = (self[x, y] - self[x, y - 1]).abs
        x += 1
      end
      y += 1
    end
    output_image
  end

  #output[X,Y] stores the sum of self[x, y] for all x in [0..X) and y in [0..Y)
  def accumulated_image
    output_image = GrayscaleImage.new(@width + 1, @height + 1)
    width, height = output_image.width, output_image.height
    y = 1
    while y < height
      x = 1
      while x < width
        output_image[x, y] = self[x - 1, y - 1] +
            output_image[x - 1, y] + output_image[x, y - 1] - output_image[x - 1, y - 1]
        x += 1
      end
      y += 1
    end
    output_image
  end

  private
  def self.rgb_delta28 pixel1, pixel2 #produces upto delta 28*255
    r1 = ChunkyPNG::Color::r(pixel1)
    r2 = ChunkyPNG::Color::r(pixel2)
    g1 = ChunkyPNG::Color::g(pixel1)
    g2 = ChunkyPNG::Color::g(pixel2)
    b1 = ChunkyPNG::Color::b(pixel1)
    b2 = ChunkyPNG::Color::b(pixel2)
    lum1 = 3*r1 + 10*g1 + 1*b1
    lum2 = 3*r2 + 10*g2 + 1*b2
    # The human eye is most sensitive to green, and least sensitive to blue

    red_delta = (r1 - r2).abs
    green_delta = (g1 - g2).abs
    blue_delta = (b1 - b2).abs
    lum_delta = (lum1 - lum2).abs
    # the human eye is more sensitive to changes in luminance than in hue/saturation.
    lum_delta + 3 * red_delta + 10 * green_delta + 1 * blue_delta
  end
end
