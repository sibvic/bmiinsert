item_unit = 25;
screw_width = 4;

width_count       = 2;    // Number of items X
height_count      = 1;    // Number of items Y

tolerance         = 0.25; // 3D printing tolerance per side, mm
thickness         = 2;    // Thickness of base, mm

nut_height        = 3;    // Height of the nut, mm

module plotBase(x, y, tolerance, thickness, screw_width) {
    difference() {
        cube(size = [item_unit * x - tolerance, item_unit * y - tolerance, thickness]);
        for (x_index = [0 : x - 1]) {
            for (y_index = [0 : y - 1]) {
                translate([x_index * item_unit + item_unit / 2 - tolerance, y_index * item_unit + item_unit / 2 - tolerance, 0]) {
                    cylinder(r = screw_width / 2 + tolerance * 2, h = thickness);
                }
            }
        }
    }
}

module plotM4NutSpace(x, y, z, nutHeight) {
    width = 7.8;
    translate([x, y, z + nutHeight / 2]) {
        cylinder(r = width / 2 + tolerance * 2, h = nutHeight, $fn = 6, center = true);
    }
}

module plotInvertedMount(x, y) {
    plotM4NutSpace(x, y, 0, nut_height);
    translate([x, y, thickness / 2 + thickness]) {
        cylinder(r = screw_width / 2 + tolerance * 2, h = thickness, center = true);
    }
}

difference() {
    union() {
        plotBase(width_count, height_count, tolerance, thickness, screw_width);
        translate([0, 0, thickness]) {
            cube(size = [item_unit * width_count - tolerance, item_unit * height_count - tolerance, thickness]);
        }
    }
    translate([0, 0, thickness]) {
        for (x_index = [0 : width_count - 1]) {
            for (y_index = [0 : height_count - 1]) {
                plotM4NutSpace(x_index * item_unit + item_unit / 2 - tolerance, y_index * item_unit + item_unit / 2 - tolerance, thickness - nut_height, nut_height);
            }
        }
    }
    if (width_count > 1) {
        for (x_index = [1 : width_count - 1]) {
            for (y_index = [0 : height_count - 1]) {
                plotInvertedMount(x_index * item_unit - tolerance, y_index * item_unit + item_unit / 2 - tolerance);
            }
        }
    }
    if (height_count > 1) {
        for (x_index = [0 : width_count - 1]) {
            for (y_index = [1 : height_count - 1]) {
                plotInvertedMount(x_index * item_unit + item_unit / 2 - tolerance, y_index * item_unit - tolerance);
            }
        }
    }
}