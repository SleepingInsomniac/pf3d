module PF3d
  # A buffer of depth values for rending 3d scenes
  class DepthBuffer
    include PF2d::Drawable(Float64)

    @values : Slice(Float64)
    @width : Int32
    @height : Int32

    def initialize(@width, @height)
      @values = Slice(Float64).new(@width * @height, 0.0)
    end

    def clear
      @values.fill(0.0)
    end

    def [](x : Int, y : Int)
      @values[y * @width + x]
    end

    def []=(x : Int, y : Int, value : Float64)
      @values[y * @width + x] = value
    end

    def draw_point(x : Number, y : Number, value : Float64)
      self[x, y] = value
    end
  end
end
