require "pf2d"

module PF3d
  VERSION = {% `shards version`.chomp.stringify %}

  # Given a point on a plane *plane_point*, and a normal to the plane *plane_normal*,
  # see if a line from *line_start* to *line_end* intersects a plane, and return the
  # point at intersection
  def self.line_intersects_plane(plane_point : PF2d::Vec3(Float64), plane_normal : PF2d::Vec3(Float64), line_start : PF2d::Vec3(Float64), line_end : PF2d::Vec3(Float64))
    plane_normal = plane_normal.normalized
    plane_dot_product = -plane_normal.dot(plane_point)
    ad = line_start.dot(plane_normal)
    bd = line_end.dot(plane_normal)
    t = (-plane_dot_product - ad) / (bd - ad)
    line_start_to_end = line_end - line_start
    line_to_intersect = line_start_to_end * t
    {line_start + line_to_intersect, t}
  end
end

require "./pf3d/depth_buffer"
require "./pf3d/camera"
require "./pf3d/projector"
require "./pf3d/tri"
require "./pf3d/mesh"
require "./pf3d/transform"
