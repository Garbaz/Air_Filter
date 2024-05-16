fan_size = 120;
fan_diameter = 115;

chamfer_width = 4;

screw_hole_diameter = 4.5;
screw_hole_distance = 105.2;

funnel_height = 30;
funnel_wall_thickness = 2;

filter_inner_diameter = 87.5;
plug_height = 10;

$fa = 1.5;
$fs = 1;

module ChamferedSquare(size, chamfer_width)
{
    // Constant figured out experimentally
    delta = 1.207 * chamfer_width;
    offset(delta = delta, chamfer = true) square(size - 2 * delta, center = true);
}

module Plate()
{
    difference()
    {
        ChamferedSquare(fan_size, chamfer_width);

        circle(fan_diameter / 2);

        for (i = [-1, 1])
        {
            for (j = [-1, 1])
            {
                x = i * screw_hole_distance / 2;
                y = j * screw_hole_distance / 2;
                translate([x, y])
                circle(screw_hole_diameter / 2);
            }
        }
    }
}

module Funnel()
{
    translate([0,0,plug_height])
    difference()
    {
        cylinder(h = funnel_height,
                 r1 = filter_inner_diameter / 2,
                 r2 = fan_diameter / 2 + funnel_wall_thickness);

        translate([0, 0, -0.01])
        cylinder(h = funnel_height + 0.02,
                 r1 = filter_inner_diameter / 2 - funnel_wall_thickness,
                 r2 = fan_diameter / 2);
    }
    
    difference() {
        cylinder(h = plug_height, r = filter_inner_diameter/2);
        
        translate([0, 0, -0.01])
        cylinder(h = plug_height + 0.02, r = filter_inner_diameter/2 - funnel_wall_thickness);
    }
}

mirror([0,0,1]) {
    translate([0, 0, funnel_height + plug_height])
    linear_extrude(2)
    Plate();

    Funnel();
}