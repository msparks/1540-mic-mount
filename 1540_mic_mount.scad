$fa = 0.1;
$fs = 0.1;

kHeadbandWidth = 14;
kHeadbandThickness = 2;
kHeadbandInnerRadius = 92.5;
kHeadbandOuterRadius = kHeadbandInnerRadius + kHeadbandThickness;
kHeadbandGapWidth = 4;

module isocelesTriangle(angle, height, width) {
  b = height * tan(angle / 2);

  linear_extrude(height=width, center=true, convexity=10, twist=0) {
    polygon(points=[[0, 0], [height, 0], [0, b]], paths=[[0, 1, 2]]);
  }
  linear_extrude(height=width, center=true, convexity=10, twist=0) {
    polygon(points=[[0, 0], [height, 0], [0, -b]], paths=[[0, 1, 2]]);
  }
}

module cylinderArc(angle, inner_radius, height, depth) {
  outer_radius = inner_radius + depth;

  intersection() {
    translate([outer_radius, 0, 0]) {
      rotate([0, 0, 180]) {
        isocelesTriangle(angle, kHeadbandOuterRadius, kHeadbandWidth);
      }
    }

    difference() {
      cylinder(h=height, r=outer_radius, center=true);
      cylinder(h=height, r=inner_radius, center=true);
    }
  }
}

// Headband for reference.
%translate([0, 0, -kHeadbandInnerRadius])
rotate([90, -90, 0]) {
  difference() {
    cylinderArc(90, kHeadbandInnerRadius, kHeadbandWidth,
                kHeadbandThickness);

    // Headband gap.
    cylinder(h=kHeadbandGapWidth,
             r=kHeadbandOuterRadius,
             center=true);
  }
}

difference() {
  union() {
    difference() {
      translate([0, 0, -kHeadbandInnerRadius]) rotate([90, -90, 0]) {
        // Jack.
        cylinderArc(30, kHeadbandOuterRadius, kHeadbandWidth, 10);

        // Anchor that fits in the headband gap.
        rotate([0, 0, 6]) {
          cylinderArc(10, kHeadbandInnerRadius, kHeadbandGapWidth,
                      kHeadbandThickness);
        }
      }
    }

    // Barrel outer cylinder.
    translate([-9, 0, 7]) rotate([0, 90, 0]) {
      cylinder(h=34, r=4.5);
    }
  }

  // Barrel inner cylinder.
  translate([-9, 0, 7]) rotate([0, 90, 0]) {
    cylinder(h=34, r=3.5);
  }
}
