
// Which of the two parts to generate
part = "both"; // [both, plug, rim]

// The inner diameter of the filter
inner_diameter = 87.5;

// The outer diameter of the filter
outer_diameter = 131;

// Height of the plug part
plug_height = 10;

// Height of the base rim
rim_height = 1;

// Width of the rim edge to join the parts neatly
rim_edge_width = 3;

// Diameter of a foot recess
foot_diameter = 14;

// Number of feet
number_of_feet = 6;

// Height of a single print layer
print_layer_height = 0.2;

module Cone(radius, height) {
    rotate_extrude()
    polygon([[0,0],[radius,0],[0,height]]);
};

$fa = 6;

module Plug() {
    ph = plug_height + (rim_height - print_layer_height);
    
    translate([0,0,print_layer_height]) {
        translate([0,0,ph])
        Cone(inner_diameter/2, inner_diameter/2);
    
        cylinder(h = ph, r = inner_diameter/2);
    }
    
    cylinder(h = print_layer_height, r = inner_diameter/2 + rim_edge_width);
}

module Rim() {
    mirror([0,0,1])
    difference() {
        cylinder(h = rim_height, r = outer_diameter/2);
        
        translate([0,0,-0.01])
        cylinder(h = rim_height + 0.02, r = inner_diameter/2);
        
        translate([0,0,-0.01])
        cylinder(h = print_layer_height + 0.01, r = inner_diameter/2 + rim_edge_width);

        for(i = [0:number_of_feet-1]) {
            a = 360 * i/number_of_feet;
            r = (outer_diameter + inner_diameter)/4;
            // The 0.01 here is just for better preview render
            translate([r * cos(a), r * sin(a),-0.01])
            cylinder(h = print_layer_height + 0.01, r = foot_diameter/2);
        }
    }
}

if(part == "plug") {
    Plug();   
} else if(part == "rim") {
    Rim();
} else {
    translate([-(inner_diameter/2 + rim_edge_width + 1), 0, 0])
    Plug();
    
    translate([outer_diameter/2 + 1, 0, 0])
    Rim();
}