 extra = 0.5;
$fs=0.1;

// radius of rounded corners on edges
cornerRadius = 1.5;
// Radius of screw holes. 1.45 will allow M3 bolts to screw into the holes.
screwHoleRadius = 1.45;

// bracket width
width=10;

// bracket height
height=2;

module plate(width,depth,height, cornerRadius,corners)
{
    translate([-width/2.0, -depth/2.0, 0])
    {
        difference()
        {
            cube([width,depth,height]);
            if (corners[0]==1){
                translate([-extra,-extra,-extra])
                {
                     cube([cornerRadius+extra,cornerRadius+extra,height+2*extra]);
                }
            }
            if (corners[1]==1){
                translate([-extra,depth-cornerRadius,-extra])
                {
                    cube([cornerRadius+extra,cornerRadius+extra,height+2*extra]);
                }
            }
            if (corners[2]==1){
                translate([width-cornerRadius,depth-cornerRadius,-extra])
                { 
                    cube([cornerRadius+extra,cornerRadius+extra,height+2*extra]);
                }
            }
            if (corners[3]==1){
                translate([width-cornerRadius,-extra,-extra])
                {
                    cube([cornerRadius+extra,cornerRadius+extra,height+2*extra]);
                }
            }
        }
        translate([cornerRadius,cornerRadius,0]) cylinder(r=cornerRadius,h=height);
        translate([width-cornerRadius,cornerRadius,0]) cylinder(r=cornerRadius,h=height);
        translate([cornerRadius,depth-cornerRadius,0]) cylinder(r=cornerRadius,h=height);
        translate([width-cornerRadius,depth-cornerRadius,0]) cylinder(r=cornerRadius,h=height);
    }
}   

module Hole( pinRadius, pinHeight, topRadius,topHeight)
{
    union(){
        translate([0,0,-extra]){
            cylinder(r=pinRadius,h=pinHeight+extra*2);
        }
        translate([0,0,pinHeight]){
            cylinder(h=topHeight+extra,r1=pinRadius,r2=topRadius);
        }
    }
}


module holeRow ( width,depth,height, holeSpacing, holeRadius  ){
    translate([-width/2.0, -depth/2.0, 0])
    {
        noOfHoles = floor(depth/holeSpacing)-1;
        startY = width/2.0;
        yLength = depth-width;
        holeGap = yLength/noOfHoles;
        
        x = width/2.0;
        y = width/2.0;
        pinRadius = holeRadius;
        topRadius = holeRadius*2;
        pinHeight = height * 0.666;
        topHeight = height * 0.333;
        for ( i=[0:1:noOfHoles]){
            translate([x,y+(i*holeGap),0]){
                Hole(pinRadius, pinHeight, topRadius,topHeight);
            }
        }
    }
}

module sideStrip( width, depth, height, cornerRadius)
{
    union(){
        color("red",1){
            translate([width/2.0+height,0,width/2.0+height]){
                rotate([0,-90,0]){
                    plate(width,depth,height,cornerRadius,[1,1,1,1]);
                }
            }
        }
        color("blue",1){
            plate(width,depth,height,cornerRadius,[1,1,1,1]);
        }
        translate([width/2.0-cornerRadius,-depth/2.0,0]){
            cube([height+cornerRadius,depth,height+cornerRadius]);
        }
    }
}

module sideHoles( width, depth, height, holeSpacing, holeRadius )
{
    union(){
        color("red",1){
            translate([width/2.0+height,0,width/2.0+height]){
                rotate([0,-90,0]){
                    translate([0,0,height]){
                        rotate ([180,0,0]){
                            holeRow(width,depth,height,holeSpacing,holeRadius);
                        }
                    }
                }
            }
        }
        color("blue",1){
            translate([0,0,height]){
                rotate ([180,0,0]){
                        holeRow(width,depth,height,holeSpacing,holeRadius);;
                }
            }
        }
    }
}


module cornerStrip( width, depth, height, cornerRadius, holeSpacing, holeRadius )
{
    union(){
        
        sideStrip(width=width, depth=depth, height=height, cornerRadius=cornerRadius, holeSpacing=holeSpacing, holeRadius=holeRadius);
        translate([-1.5*width+height,depth/2,0]){
            cube([2*width, height,2*width]);
        }
    }
}

module corner3D(x,y,z, holeSpacing)
{

    difference(){
        union(){
            sideStrip(width=width, depth=x, height=height, cornerRadius=cornerRadius);
            translate([-y/2.0+width/2.0,x/2.0-width/2.0,0]){
                rotate([0,0,90]){
                    sideStrip(width=width, depth=y, height=height, cornerRadius=cornerRadius);
                }
            }
            translate([0,x/2.0+height,z/2.0+height]){
                rotate([90,0,0]){
                    sideStrip(width=width, depth=z, height=height, cornerRadius=cornerRadius);
                }
            }
            translate([width/2.0,x/2.0,0]){
                color("blue",1){
                    cube([height,height,height]);
                }
            }
        }
        union(){
            sideHoles(width,x,height,holeSpacing,screwHoleRadius);
            translate([-y/2.0+width/2.0,x/2.0-width/2.0,0]){
                rotate([0,0,90]){
                    sideHoles(width,y,height,holeSpacing,screwHoleRadius);
                }
            }
            translate([0,x/2.0+height,z/2.0+height]){
                rotate([90,0,0]){
                        sideHoles(width,z,height,holeSpacing,screwHoleRadius);
                }
            }
        }
    }
}


// Corner Creator by Rob Miles
// set the depth of the corner and the hole spacing in mm
//corner(depth=50,holeSpacing=15);

corner3D(x=40,y=40,z=40,holeSpacing=12);

