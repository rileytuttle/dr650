include <openscad-library-manager/BOSL2/std.scad>
include <openscad-library-manager/rosetta-stone/std.scad>

$fn=50;

base_plate_size = [49, 55];
base_plate_thickness = 1/8 * INCH;
post_size = 12.5;
post_height = 13;

post_spin = [0, 90, 90, 0];

post_hole_screw_shaft_diam = 5.5;
post_hole_screw_head_diam = 9;

plate_through_hole_loc = [
    [0, 0],
    [35/2, 0],
    [-35/2, 0],
    [0, 38/2],
    [0, -38/2]
];
plate_through_hole_diam = 5.5;

module basic_hourglass(length=100)
{
    attachable() {
        prismoid(size1=[3, length], size2=[1.5, length], height=1.5, anchor=TOP)
        position(TOP) prismoid(size1=[1.5, length], size2=[3, length], height=1.5, anchor=BOTTOM);
        children();
    }
}

module auxetic_lattice(anchor=CENTER)
{
    wall_thickness = 0.75;
    attachable(anchor=anchor, size=[100, 15, 3*3+wall_thickness*2]) {
        zrot(90)
        intersection() {
            union() {
                xcopies(n=5, spacing=(2.45+wall_thickness)*2) {
                    zcopies(n=5, spacing=3+wall_thickness) basic_hourglass();
                    right(2.5+wall_thickness) up((3+wall_thickness)/2)
                    zcopies(n=5, spacing=3+wall_thickness) basic_hourglass();
                }
                xcopies(n=2, l=(2.45+wall_thickness)*4) zcopies(n=2, l=3+wall_thickness) cuboid([3, 100, wall_thickness]);
            }
            cuboid([15, 100, 3*3 + wall_thickness*2]);
        }
        children();
    }
}

module isolator_consumable()
{
    diff() {
        cuboid(concat(base_plate_size, base_plate_thickness), rounding=2.25, except=[TOP, BOTTOM]) {
            position(TOP) cuboid([6.5,19,1.7], anchor=BOTTOM, rounding=6.5/2, except=[TOP, BOTTOM]);
            position(TOP) grid_copies(n=[2,2], size=amps_spacing)
            cuboid([post_size, post_size, post_height], anchor=BOTTOM, rounding=post_size/2, edges=[FRONT+LEFT, BACK+RIGHT], spin=post_spin[$idx]) {
                tag("remove") position(BACK+LEFT) fillet(l=post_height, r=1, spin=270);
                tag("remove") position(FRONT+RIGHT) fillet(l=post_height, r=1, spin=90);
                tag("remove") position(TOP) cyl(d=post_hole_screw_shaft_diam, l=base_plate_thickness+post_height, anchor=TOP);
                tag("remove") position(TOP) down(3.5) cyl(d=post_hole_screw_head_diam, l=base_plate_thickness+post_height-3.5, anchor=TOP);
            }
            tag("remove") move_copies(plate_through_hole_loc) cyl(d=plate_through_hole_diam, l=10);
            ycopies(n=2, l=38) position(TOP) tag("remove") auxetic_lattice(anchor=BOTTOM);
        }
    }
}

isolator_consumable();
// auxetic_lattice();
// basic_hourglass();
