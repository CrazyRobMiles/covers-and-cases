extra = 0.5;
$fs=0.1;

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
    holeLength = holeSpacing * noOfHoles;
    margin = depth-holeLength;
    
    x = width/2.0;
    y = margin/2.0;
    pinRadius = holeRadius;
    topRadius = holeRadius*2;
    pinHeight = height * 0.666;
    topHeight = height * 0.333;
    for ( i=[0:1:noOfHoles]){
        translate([x,y+(i*holeSpacing),0]){
            Hole(pinRadius, pinHeight, topRadius,topHeight);
        }
    }
}
}

module strip( width, depth, height, cornerRadius, holeSpacing, holeRadius, corners )
{
    difference(){
        plate(width,depth,height,cornerRadius,corners);
        holeRow(width,depth,height,holeSpacing,holeRadius);
    }
}

module cornerStrip( width, depth, height, cornerRadius, holeSpacing, holeRadius )
{

    union(){
        color("red",1){
        translate([width/2.0+height,0,width/2.0+height]){
            rotate([0,-90,0]){
                translate([0,0,height]){
                    rotate ([180,0,0]){
                        strip(width, depth, height, cornerRadius, holeSpacing, holeRadius,[0,1,1,0]);
                    }
                }
            }
        }
    }
        translate([0,0,height]){
            rotate ([180,0,0]){
        color("blue",1){
                strip(width, depth, height, cornerRadius, holeSpacing, holeRadius,[0,1,1,0]);
            }
        }
        }
        translate([width/2.0-cornerRadius,-depth/2.0,0]){
            cube([height+cornerRadius,depth,height+cornerRadius]);
        }
        translate([-1.5*width+height,depth/2,0]){
            cube([2*width, height,2*width]);
        }
    }

}

module corner(depth, holeSpacing)
{
    cornerRadius = 1.5;
    screwHoleRadius = 1.45;
    accessHoleRadius = 1.6;
    width=10;
    height=2;
    
translate([-20,0,0]){
    cornerStrip(width=width, depth=depth, height=height, cornerRadius=cornerRadius, holeSpacing=holeSpacing, holeRadius=screwHoleRadius);
}

translate([20,0,0]){
    strip(width=width, depth=depth, height=height, cornerRadius=cornerRadius, holeSpacing=holeSpacing,holeRadius=accessHoleRadius,corners=[1,1,1,1]);
}

    strip(width=width, depth=depth, height=height, cornerRadius=cornerRadius, holeSpacing=holeSpacing,, holeRadius=accessHoleRadius,corners=[1,1,1,1]);
}


// Corner Creator by Rob Miles
// set the depth of the corner and the hole spacing in mm
corner(depth=50,holeSpacing=15);

