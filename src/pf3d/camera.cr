module PF3d
  class Camera
    property position : PF2d::Vec3(Float64) = PF2d::Vec[0.0, 0.0, 0.0]
    property up : PF2d::Vec3(Float64) = PF2d::Vec[0.0, 1.0, 0.0]
    property rotation : PF2d::Vec3(Float64) = PF2d::Vec[0.0, 0.0, 0.0]

    # Rotation about the X axis
    def pitch
      @rotation.x
    end

    def pitch=(value)
      @rotation.x = value
    end

    # Rotation about the Z axis
    def roll
      @rotation.z
    end

    def roll=(value)
      @rotation.z = value
    end

    # Rotation about the Y axis
    def yaw
      @rotation.y
    end

    def yaw=(value)
      @rotation.y = value
    end

    def forward_vector
      v, w = Transform.apply(PF2d::Vec[0.0, 0.0, 1.0], rotation_matrix)
      v
    end

    def strafe_vector
      v, w = Transform.apply(PF2d::Vec[1.0, 0.0, 0.0], rotation_matrix)
      v
    end

    def up_vector
      v, w = Transform.apply(PF2d::Vec[0.0, 1.0, 0.0], rotation_matrix)
      v
    end

    def matrix
      Transform.point_at(@position, @position + forward_vector, up_vector)
    end

    def view_matrix
      Transform.quick_inverse(matrix)
    end

    def rotation_matrix
      Transform.rot_x(pitch) * Transform.rot_y(yaw) * Transform.rot_z(roll)
    end

    def move_right(delta : Float64)
      @position = @position - (strafe * delta)
    end

    def move_left(delta : Float64)
      @position = @position + (strafe * delta)
    end

    def move_up(delta : Float64)
      @position.y = @position.y + delta
    end

    def move_down(delta : Float64)
      @position.y = @position.y - delta
    end

    def rotate_left(delta : Float64)
      self.yaw += delta
    end

    def rotate_right(delta : Float64)
      self.yaw -= delta
    end

    def move_forward(delta : Float64)
      @position = @position + (@look_direction * delta)
    end

    def move_backward(delta : Float64)
      @position = @position - (@look_direction * delta)
    end
  end
end
