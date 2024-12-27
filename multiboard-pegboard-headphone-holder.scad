/* Multiboard Pegboard Headphone Holder */

/* [Advanced] */

$fn = 200;
animate = false;


/* [Hidden] */

nothing=0.01; // z-fighting fix
multiboard_grid_offset = 25;
multiboard_peghole_width = 14.64;
click_height = 36.8;
click_mount_depth = 4;
multipoint_rail_max_width = 18.6;
multipoint_rail_max_depth = 2.2;
multipoint_rail_offset = -6; // Adjust the holder position to match the rail slot


/* [Headphone] */

headphone_width = 160;
headphone_bracket_depth = 30;


/* [Holder] */

mount_type = "click"; // [click:Pegboard Click, rail:Multipoint Rail Slot]

// Width measrued in the number of multiboard grid holes
number_of_grid_holes = 4;

// Keep the peg holes close to the holder so that they can be used
keep_pegholes = true;

wall_thickness = 4;
wall_height = 10;

click_position = -6; // [-16 : 16]

preview_sample_multiboard = true;


/* Calculations */

animated_click_position = 16 * sin($t*360); // Animation
calculated_click_position = $preview && animate ? animated_click_position : click_position;

holder_width = multiboard_grid_offset * number_of_grid_holes - (keep_pegholes ? multiboard_peghole_width : 0);
total_width = headphone_width + wall_height + wall_thickness + click_mount_depth;
inner_depth = headphone_bracket_depth + click_mount_depth;
total_depth = inner_depth + wall_thickness;

// Rail

rail_width = multipoint_rail_max_width + click_mount_depth;
rail_depth = click_mount_depth;
rail_height = click_height;

// Sample Multiboard

sample_multiboard_size = 4 * multiboard_grid_offset;
sample_multiboard_offset = sample_multiboard_size / 2 + multiboard_grid_offset / 2;

/* Parts */

module sampleMultiboardCorner() {
  translate([-sample_multiboard_offset, -sample_multiboard_offset, 2]) {
    color("#cccccc") import("4x4 Multiboard Corner.stl", $fn=200);
  }
}

module pegboardClick() {
  rotate([0, -90, 90]) {
    translate([-6.6, 0, 0]) {
      import("Pegboard Click.stl", $fn=200);
    }
  }
}

module railSlot() {
  rotate([0, 180, 0]) {
    translate([0, 0, click_mount_depth]) {
      difference() {
        union() {
          cube([rail_height, rail_width, rail_depth], center=true);
          translate([0, 0, -rail_depth + multipoint_rail_max_depth / 2]) {
            cube([rail_height, rail_width, rail_depth / 2], center=true);
          }
        }
        rotate([180, 0, 90]) {
          translate([0, multiboard_grid_offset / 2 - click_mount_depth, -multipoint_rail_max_depth]) {
            import("Lite Multipoint Rail - Negative.stl", $fn=200);
          }
        }
      }
    }
  }
}

module holder() {
  difference() {
    union() {
      // Main Holder Circle
      linear_extrude(total_depth - 2 * nothing) {
        difference() {
          circle(d = headphone_width);
          circle(d = headphone_width - wall_thickness);
        }
      }
      // Front Wall Holder Circle
      translate([0, 0, inner_depth]) {
        linear_extrude(wall_thickness - 2 * nothing) {
          difference() {
            circle(d = headphone_width + wall_thickness + wall_height);
            circle(d = headphone_width);
          }
        }
      }
    }
    // Cut Holder
    translate([-total_width / 2, 0, -nothing]) {
      linear_extrude(total_depth) {
        difference() {
          square([total_width * 2, total_width], center=true);
          square([holder_width, holder_width], center=true);
        }
      }
    }
  }
}


/* Main */

if ($preview && preview_sample_multiboard) {
  translate([
    headphone_width / 2 + calculated_click_position - click_height / 2 + multiboard_peghole_width / 2 + (mount_type == "click" ? 0 : multipoint_rail_offset),
    0,
    0
  ]) {
    sampleMultiboardCorner();
  }
}

rotate([0, 180, 0]) {
  holder();

  translate([-headphone_width / 2 - calculated_click_position, 0, click_mount_depth]) {
    if (mount_type == "click") {
      pegboardClick();
    } else {
      railSlot();
    }
  }
}
