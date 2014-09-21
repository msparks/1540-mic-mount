use <mscad/extrusions.scad>

$fa = 2;
$fs = 0.7;

kHeadbandWidth = 14;
kHeadbandThickness = 2;
kHeadbandInnerRadius = 92.5;
kHeadbandOuterRadius = kHeadbandInnerRadius + kHeadbandThickness;
kHeadbandGapWidth = 4;
kBarrelLength = 34;
kClipLength = 31;

module headband() {
  // How much of the headband to show.
  sweep = 45;

  translate([0, 0, -kHeadbandInnerRadius])
  // Rotate headband upright and centered.
  rotate([90, -(90 - sweep) - sweep / 2])
  // The cross-section of the headband is a rectangle with the middle missing
  // for the gap.
  rotate_extrude_sweep(outer_radius=kHeadbandOuterRadius,
                       min_z=-kHeadbandWidth, max_z=kHeadbandWidth,
                       sweep=sweep)
  translate([kHeadbandInnerRadius + kHeadbandThickness / 2, 0])
  difference() {
    // Solid band.
    square([kHeadbandThickness, kHeadbandWidth], center=true);

    // Gap.
    square([kHeadbandThickness, kHeadbandGapWidth], center=true);
  }
}

module mount() {
  sweep = 28;
  radius = kHeadbandWidth / 2;

  translate([0, 0, -kHeadbandInnerRadius])
  // Rotate mount upright and centered.
  rotate([90, -(90 - sweep) - sweep / 2])
  // Cross-section is a semi-circle.
  rotate_extrude_sweep(outer_radius=kHeadbandOuterRadius + 2 * radius,
                       min_z=-kHeadbandWidth, max_z=kHeadbandWidth,
                       sweep=sweep)
  translate([kHeadbandOuterRadius, 0])
  difference() {
    circle(r=radius, center=true);
    translate([-radius / 2, 0])
    square([radius, radius * 2], center=true);
  }
}

module mount_clip() {
  gap_fill(sweep=5, radius=kHeadbandInnerRadius, rotation=5);
  clip_rounder(kHeadbandThickness, -2.5);
  clip_rounder(kHeadbandThickness, -7.5);
}

module gap_fill(sweep, radius, rotation=0) {
  translate([0, 0, -kHeadbandInnerRadius])
  rotate([90, -(90 - sweep) - sweep / 2 - rotation])
  // Cross-section is a rectangle.
  rotate_extrude_sweep(outer_radius=radius + kHeadbandThickness,
                       min_z=-kHeadbandWidth, max_z=kHeadbandWidth,
                       sweep=sweep)
  translate([radius + kHeadbandThickness / 2, 0])
  square([kHeadbandThickness, kHeadbandGapWidth], center=true);
}

module clip_rounder(height, rotation) {
  translate([0, 0, -kHeadbandInnerRadius])
  rotate([0, rotation, 0])
  difference() {
    cylinder(h=kHeadbandOuterRadius, d=kHeadbandGapWidth);
    cylinder(h=kHeadbandOuterRadius - height, d=kHeadbandGapWidth);
  }
}

module mount_rounder(height, rotation) {
  translate([0, 0, -kHeadbandInnerRadius])
  rotate([0, rotation, 0])
  difference() {
    cylinder(h=kHeadbandOuterRadius + height, d=kHeadbandWidth);
    cylinder(h=kHeadbandOuterRadius, d=kHeadbandWidth);
  }
}

module barrel() {
  // Barrel outer cylinder.
  translate([-9, 0, 7])
  rotate([0, 90, 0])
  cylinder(h=kBarrelLength, r=4.5);

  // Cap at end of barrel.
  translate([-9, 0, 7])
  sphere(r=4.5);
}

module barrel_inner() {
  // Barrel inner cylinder.
  translate([-9, 0, 7])
  rotate([0, 90, 0])
  cylinder(h=kBarrelLength, r=3.5);
}

// Headband for reference.
%headband();

difference() {
  union() {
    mount();
    mount_clip();
    barrel();
  }

  barrel_inner();
}
