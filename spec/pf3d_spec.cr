require "./spec_helper"

describe PF3d do
  describe "line_intersects_plane" do
    it "intersects a plane at a known point" do
      line_start = PF2d::Vec[0.0, 0.0, -5.0]
      line_end = PF2d::Vec[0.0, 0.0, 5.0]

      plane_normal = PF2d::Vec[0.0, 0.0, 1.0]
      plane_point = PF2d::Vec[0.0, 0.0, 0.0]

      intersect = PF3d.line_intersects_plane(plane_point, plane_normal, line_start, line_end)
      intersect.should eq({PF2d::Vec[0.0, 0.0, 0.0], 0.5})
    end
  end
end
