include <BOSL2/std.scad>
include <BOSL2/screws.scad>

mount_hole_dist = 40;
base_thickness = 20;
$fn=50;
mount_block_size = [72, 31];

module spacer()
{
    diff() {
        cuboid(concat(mount_block_size, base_thickness), rounding=15, except=[TOP, BOTTOM])
        tag("remove") xcopies(n=2, l=mount_hole_dist) cyl(d=10.5, l=base_thickness+1);
    }
}

module foot_peg_wall()
{
    holes=[
        [-10, 72],
        [-10-1*INCH, 72-1.5*INCH],
        [-10, 72-1.5*INCH]
    ];
    diff() {
        cuboid(concat(mount_block_size, 10), rounding=15, except=[TOP,BOTTOM]) {
            cuboid([90, 95, 10], anchor=FRONT);
            tag("remove") xcopies(n=2, l=mount_hole_dist) cyl(d=10.5, l=base_thickness+1);
            for (hole = holes)
            {
                tag("remove") translate(hole) screw_hole("1/4-20", thread=true, l=10);
            }
        }
    }
}

module peg()
{
    diff() {
        cuboid([40, 40, 100])
        position(BOTTOM) up(10) screw_hole("1/4-20", l=50, thread=false, head="hex", counterbore=100, anchor="shaft_top");
    }
}

foot_peg_wall();
// spacer();
// back_half()
// peg();
