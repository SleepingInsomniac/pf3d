module PF3d
  class Transform
    include PF2d

    def self.identity
      Mat4x4[
        1.0, 0.0, 0.0, 0.0,
        0.0, 1.0, 0.0, 0.0,
        0.0, 0.0, 1.0, 0.0,
        0.0, 0.0, 0.0, 1.0,
      ]
    end

    def self.rot_x(theta : Float64)
      cox, sox = Math.cos(theta), Math.sin(theta)
      Mat4x4[
        1.0, 0.0, 0.0, 0.0,
        0.0, cox, sox, 0.0,
        0.0, -sox, cox, 0.0,
        0.0, 0.0, 0.0, 1.0,
      ]
    end

    def self.rot_y(theta : Float64)
      coy, soy = Math.cos(theta), Math.sin(theta)
      Mat4x4[
        coy, 0.0, soy, 0.0,
        0.0, 1.0, 0.0, 0.0,
        -soy, 0.0, coy, 0.0,
        0.0, 0.0, 0.0, 1.0,
      ]
    end

    def self.rot_z(theta : Float64)
      coz, siz = Math.cos(theta), Math.sin(theta)
      Mat4x4[
        coz, siz, 0.0, 0.0,
        -siz, coz, 0.0, 0.0,
        0.0, 0.0, 1.0, 0.0,
        0.0, 0.0, 0.0, 1.0,
      ]
    end

    def self.rotation(x : Float64, y : Float64, z : Float64)
      self.rot_x(x) * self.rot_y(y) * self.rot_z(z)
    end

    def self.rotation(angle : PF2d::Vec3(Float64))
      self.rotation(angle.x, angle.y, angle.z)
    end

    def self.translation(x : Float64, y : Float64, z : Float64)
      Mat4x4[
        1.0, 0.0, 0.0, x,
        0.0, 1.0, 0.0, y,
        0.0, 0.0, 1.0, z,
        0.0, 0.0, 0.0, 1.0,
      ]
    end

    def self.translation(pos : PF2d::Vec3(Float64))
      self.translation(pos.x, pos.y, pos.z)
    end

    def self.scale(scale : PF2d::Vec3(Float64))
      Mat4x4[
        scale.x, 0.0, 0.0, 0.0,
        0.0, scale.y, 0.0, 0.0,
        0.0, 0.0, scale.z, 0.0,
        0.0, 0.0, 0.0, 1.0,
      ]
    end

    # Does not work for scaling, only for rotation / translation
    def self.quick_inverse(other : Mat4x4)
      matrix = Mat4x4(Float64).new
      matrix[0, 0] = other[0, 0]; matrix[1, 0] = other[0, 1]; matrix[2, 0] = other[0, 2]; matrix[3, 0] = 0.0
      matrix[0, 1] = other[1, 0]; matrix[1, 1] = other[1, 1]; matrix[2, 1] = other[1, 2]; matrix[3, 1] = 0.0
      matrix[0, 2] = other[2, 0]; matrix[1, 2] = other[2, 1]; matrix[2, 2] = other[2, 2]; matrix[3, 2] = 0.0
      matrix[0, 3] = -(other[0, 3] * matrix[0, 0] + other[1, 3] * matrix[0, 1] + other[2, 3] * matrix[0, 2])
      matrix[1, 3] = -(other[0, 3] * matrix[1, 0] + other[1, 3] * matrix[1, 1] + other[2, 3] * matrix[1, 2])
      matrix[2, 3] = -(other[0, 3] * matrix[2, 0] + other[1, 3] * matrix[2, 1] + other[2, 3] * matrix[2, 2])
      matrix[3, 3] = 1.0
      matrix
    end

    def self.point_at(position : PF2d::Vec3(Float64), target : PF2d::Vec3(Float64), up : PF2d::Vec3(Float64) = PF2d::Vec[0.0, 1.0, 0.0])
      new_forward = (target - position).normalized
      new_up = (up - new_forward * up.dot(new_forward)).normalized
      new_right = new_up.cross(new_forward)

      Mat4x4[
        new_right.x, new_up.x, new_forward.x, position.x,
        new_right.y, new_up.y, new_forward.y, position.y,
        new_right.z, new_up.z, new_forward.z, position.z,
        0.0, 0.0, 0.0, 1.0,
      ]
    end

    def self.apply(point : PF2d::Vec3(Float64), matrix : Mat4x4(Float64))
      vec = PF2d::Vec[
        point.x * matrix[0, 0] + point.y * matrix[0, 1] + point.z * matrix[0, 2] + matrix[0, 3],
        point.x * matrix[1, 0] + point.y * matrix[1, 1] + point.z * matrix[1, 2] + matrix[1, 3],
        point.x * matrix[2, 0] + point.y * matrix[2, 1] + point.z * matrix[2, 2] + matrix[2, 3],
      ]
      w = point.x * matrix[3, 0] + point.y * matrix[3, 1] + point.z * matrix[3, 2] + matrix[3, 3]
      vec /= w unless w == 0.0
      {vec, w}
    end

    property matrix : Mat4x4(Float64)

    def initialize
      @matrix = Transform.identity
    end

    def initialize(@matrix)
    end

    def reset
      @matrix = Transform.identity
      self
    end

    def rot_x(theta : Float64)
      @matrix = Transform.rot_x(theta) * @matrix
      self
    end

    def rot_y(theta : Float64)
      @matrix = Transform.rot_y(theta) * @matrix
      self
    end

    def rot_z(theta : Float64)
      @matrix = Transform.rot_z(theta) * @matrix
      self
    end

    def self.rotate(r : PF2d::Vec3(Float64))
      rot_x(r.x)
      rot_y(r.y)
      rot_z(r.z)
      self
    end

    def translate(pos : PF2d::Vec3(Float64))
      @matrix = Transform.translation * @matrix
      self
    end

    # Does not work for scaling, only for rotation / translation
    def quick_invert
      @matrix = Transform.quick_inverse(@matrix)
      self
    end

    def apply(point : PF2d::Vec3(Float64))
      Transform.apply(point, @matrix)
    end
  end
end
