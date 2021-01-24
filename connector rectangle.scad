item_unit = 25;
screw_width = 4;

width_count       = 2;    // Number of items X
height_count      = 1;    // Number of items Y

tolerance         = 0.25; // 3D printing tolerance per side, mm
thickness         = 2;    // Thickness of base, mm

screw_head_height = 3;    // Height of the screw head, mm
leg_size          = 5;    // Leg size, mm

module plotLegs(x, y) {
    function calcX(x_index) = (x_index == x ? x_index * item_unit - tolerance - leg_size : max(0, x_index * item_unit - tolerance));
    function calcY(y_index) = (y_index == y ? y_index * item_unit - tolerance - leg_size : max(0, y_index * item_unit - tolerance));

    for (x_index = [0 : x]) {
        for (y_index = [0 : y]) {
            translate([calcX(x_index), calcY(y_index), thickness]) {
                cube(size = [leg_size, leg_size, screw_head_height]);
            }
        }
    }
}

union() {
    difference() {
        cube(size = [item_unit * width_count - tolerance, item_unit * height_count - tolerance, thickness]);
        for (x_index = [0 : width_count - 1]) {
            for (y_index = [0 : height_count - 1]) {
                translate([x_index * item_unit + item_unit / 2 - tolerance, y_index * item_unit + item_unit / 2 - tolerance, 0]) {
                    cylinder(r = screw_width / 2, h = thickness);
                }
            }
        }
    }

    plotLegs(width_count, height_count);
}