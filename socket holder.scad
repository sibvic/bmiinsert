item_unit = 25;
screw_width = 4;
delta = 0.01;

socket_dia        = 20;   // Diameter of the socket, mm
base_thickness    = 2;    // Thickness of the base, mm
mount_thickness   = 2;    // Mount of the base, mm
tolerance         = 0.25; // 3D printing tolerance per side, mm
cut_percent       = 60;   // % of the cut

difference() {
    total_width = item_unit + screw_width * 3;
    main_height = screw_width * 2;
    mount_width = screw_width * 3;
    mount_height = screw_width * 4;
    union() {
        // base
        cube(size = [total_width, main_height, base_thickness], center = false);
        translate([0, main_height, 0]) {
            cube(size = [mount_width, mount_height, base_thickness], center = false);
        }
        translate([total_width - mount_width, main_height, 0]) {
            cube(size = [mount_width, mount_height, base_thickness], center = false);
        }
        
        // holder body
        translate([total_width / 2, main_height / 2, socket_dia / 2 + mount_thickness]) {
            rotate([90, 90, 0]) {
                cylinder(r = socket_dia / 2 + mount_thickness, h = main_height, center = true);
            }
        }
        translate([total_width / 2 - socket_dia / 2 - mount_thickness, 0, 0]) {
            cube(size = [socket_dia + mount_thickness * 2, main_height, socket_dia / 2 + base_thickness], center = false);
        }
    }
    // cut in the holder's body
    translate([total_width / 2, main_height / 2, socket_dia / 2 + mount_thickness]) {
        rotate([90, 90, 0]) {
            cylinder(r = socket_dia / 2 + tolerance, h = main_height + delta, center = true);
        }
    }
    cut_width = socket_dia * cut_percent / 100;
    translate([total_width / 2 + cut_width / 2, 0, socket_dia / 2 + mount_thickness]) {
        rotate([0, -90, 0]) {
            cube(size = [cut_width, main_height, socket_dia / 2 + base_thickness], center = false);
        }
    }

    // screw holes
    translate([mount_width / 2, main_height + mount_height / 2, base_thickness / 2]) {
        cylinder(r = screw_width / 2 + tolerance * 2, h = base_thickness, center = true);
    }
    translate([mount_width / 2 + item_unit, main_height + mount_height / 2, base_thickness / 2]) {
        cylinder(r = screw_width / 2 + tolerance * 2, h = base_thickness, center = true);
    }
}