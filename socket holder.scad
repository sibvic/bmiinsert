item_unit = 25;
screw_width = 4;
delta = 0.01;
base_thickness = 7;
connecting_holes_step = 12.5;

socket_dia        = 20;   // Diameter of the socket, mm
mount_thickness   = 2;    // Mount of the base, mm
tolerance         = 0.25; // 3D printing tolerance per side, mm
cut_percent       = 60;   // % of the cut

difference() {
    total_width = ceil((socket_dia + mount_thickness * 2) / connecting_holes_step) * connecting_holes_step;
    main_height = screw_width * 2;
    mount_width = screw_width * 3;
    mount_height = screw_width * 4;
    union() {
        // base
        cube(size = [total_width, main_height, base_thickness], center = false);
        
        // holder body
        translate([total_width / 2, main_height / 2, socket_dia / 2 + base_thickness]) {
            rotate([90, 90, 0]) {
                cylinder(r = socket_dia / 2 + mount_thickness, h = main_height, center = true);
            }
        }
        translate([total_width / 2 - socket_dia / 2 - mount_thickness, 0, base_thickness]) {
            cube(size = [socket_dia + mount_thickness * 2, main_height, socket_dia / 2], center = false);
        }
    }
    // cut in the holder's body
    translate([total_width / 2, main_height / 2, socket_dia / 2 + base_thickness]) {
        rotate([90, 90, 0]) {
            cylinder(r = socket_dia / 2 + tolerance, h = main_height + delta, center = true);
        }
    }
        
    cut_width = socket_dia * cut_percent / 100;
    translate([total_width / 2 + cut_width / 2, 0, socket_dia / 2 + base_thickness]) {
        rotate([0, -90, 0]) {
            cube(size = [socket_dia / 2 + base_thickness, main_height, cut_width], center = false);
        }
    }
    
    // cut connecting holes
    for (i=[0:total_width / connecting_holes_step - 1]) {
        translate([(i + 0.5) * connecting_holes_step, main_height / 2, base_thickness / 2]) {
            rotate([90, 90, 0]) {
                cylinder(r = screw_width / 2 + tolerance, h = main_height + delta, center = true);
            }
        }
    }
}