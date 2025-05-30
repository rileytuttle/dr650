include <BOSL2/std.scad>
include <BOSL2/screws.scad>

$fn=50;

bolt_dist = 100;
amps_dist = sqrt(30^2+38^2);
bolt_to_amps = 20;
bolt_radius = 18;
bolt_diam = 11;
amps_diam = 6.5;
indicator_square = [50, 21];
usb_square = [23, 38.5];
toggle_circle = 20;
thickness = 3;

speedo_diam = 90;
speedo_displacement = [-35, 83];
bottom_cube_size = [bolt_dist+bolt_radius*2, 68, thickness];
fillet_r = 15;
top_cube_size = [76, 95, thickness];
top_cube_x_offset = 57;
top_cube_y_offset = 40;
top_cube_offset = [top_cube_x_offset,  top_cube_y_offset];
indicator_y_offset = 14;
usb_x_offset = 7.5;
usb_y_offset = 8.5;
switches_y_offset = 30;
switches_gap_to_right_side = 9;
switches_center_to_center = 29;
indicator_screw_x_dist = 52;
switch_notch_d = 2.5;
indicator_screw_y_offset = 2;
indicator_screw_diam = 5;

module bracket() {
    diff() {
        cuboid(bottom_cube_size, anchor=BOTTOM+FRONT+RIGHT, rounding=bolt_radius, edges=[FRONT+RIGHT, FRONT+LEFT, BACK+LEFT]) {
            position(FRONT) back(bolt_radius) tag("remove") xcopies(n=2, l=bolt_dist) screw_hole("M10", l=thickness+1);
            position(FRONT) tag("remove") back(bolt_to_amps+bolt_radius) xcopies(n=2, l=amps_dist) screw_hole("M6", l=thickness+1);
            position(BACK+RIGHT) left(top_cube_size[0]-top_cube_x_offset) fillet(r=fillet_r, l=thickness, spin=90);
            position(FRONT+RIGHT) back(top_cube_offset[1]) fillet(r=fillet_r, l=thickness, spin=-90);
            position(FRONT+RIGHT) translate(top_cube_offset) cuboid(top_cube_size, anchor=FRONT+RIGHT, rounding=fillet_r, except=[TOP, BOTTOM, FRONT+LEFT]) {
                position(FRONT) tag("remove") back(indicator_y_offset) cuboid(concat(indicator_square, thickness+1), anchor=FRONT)
                position(FRONT) back(indicator_screw_y_offset) xcopies(n=2, l=indicator_screw_x_dist) cyl(d=indicator_screw_diam, l=thickness+1);
                position(FRONT+LEFT) tag("remove") back(indicator_y_offset+indicator_square[1]+usb_y_offset) right(usb_x_offset) cuboid(concat(usb_square, thickness+1), anchor=FRONT+LEFT);
                position(FRONT+RIGHT) tag("remove") back(indicator_y_offset+indicator_square[1]+switches_y_offset) left(switches_gap_to_right_side+toggle_circle/2) ycopies(n=2, l=switches_center_to_center) cyl(d=toggle_circle, l=thickness+1)
                position(RIGHT) cyl(d=switch_notch_d, l=thickness+1);
            }
            #position(FRONT) tag("remove") back(bolt_radius) translate(speedo_displacement) cyl(d=speedo_diam, l=thickness+1);
        }
    }
}

projection(cut=false) bracket();
