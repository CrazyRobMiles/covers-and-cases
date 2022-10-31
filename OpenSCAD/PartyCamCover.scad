extra = 0.5;
$fs=0.1;

// Diameter of the holes in the panels. An m3 bolt will engage with this size
// If you want to put bolts through the holes rather than tighten into them, change to 
// holeDiam to 3.2

holeDiam = 2.9;

// Spacing between holes in the edges of the panels
holeSpacing = 10.0;

// Size of thin layer margin around panels. 
margin = 1.0;

// Margin into the panel of the holes in the corners
// This is the distance from the edge of the panel
// It is independent of the hole spacing

panelHoleMargin = 8.0;

// Thickness of the panel
foldThickness=0.2;

// Thickness of the base
baseThickness = 0.6;

// You can cut holes around openings so that they can be bound
// with thread. See the modules makeRoundHoleCutter and makeRectHoleCutter

// borderHoleMargin is the distance of these 
borderHoleMargin = 1.5;
borderHoleDiam = 1.0;
borderHoleSpacing = 1.5;


// heights and sizes of the pillars around the bolt holes
pillarHeight=1.5;
pillarTopDiam=2.0;
pillarBotDiam=5.0;

// Distance from the edge of a hole for mounting holes
// for hole covers
holePillarOffset=3.0;

module makeFoldHoleCutouts(distance){
    noOfHoles = floor(distance/holeSpacing)-1;
    holeGap = distance-margin;
    holeSpacing = holeGap/noOfHoles;
    for(i=[0:1:noOfHoles]){
        translate([-margin/2.0,margin/2.0+(i*holeSpacing),extra]){
            cylinder(h=foldThickness+(2*extra),d=holeDiam,center=true);
        }
    }
} 

module makePanelHoleCutouts(distance){
    noOfHoles = floor(distance/holeSpacing)-1;
    holeGap = distance-panelHoleMargin;
    holeSpacing = holeGap/noOfHoles;
    for(i=[0:1:noOfHoles]){
        translate([panelHoleMargin/2.0,panelHoleMargin/2.0+(i*holeSpacing),0]){
            ch=baseThickness+pillarHeight+(2*extra);
            translate([0,0,(ch/2)-extra]){
                cylinder(h=ch,d=holeDiam,center=true);
            }
        }
    }
} 

module makePanelHolePillars(distance){
    noOfHoles = floor(distance/holeSpacing)-1;
    holeGap = distance-panelHoleMargin;
    holeSpacing = holeGap/noOfHoles;
    for(i=[0:1:noOfHoles]){
        translate([panelHoleMargin/2.0,panelHoleMargin/2.0+(i*holeSpacing),baseThickness+(pillarHeight/2.0)]){
            cylinder(h=pillarHeight,d1=pillarBotDiam,d2=pillarTopDiam,center=true);
        }
    }
} 

module makePanel(width,depth,holes){
    outerWidth = width+(2*margin);
    outerDepth = depth+(2*margin);
    difference(){
        union(){
            translate([-margin,-margin,0]){
                color("red",1){
                    cube([outerWidth,outerDepth,foldThickness]);
                }
            }
            cube([width,depth,baseThickness]);
            if(holes[0]==1){
                makePanelHolePillars(depth);
            }
            if(holes[1]==1){
                translate([width-panelHoleMargin,0,0]){
                    makePanelHolePillars(depth);
                }
            } 
            if(holes[2]==1){
                translate([0,panelHoleMargin,0]){
                    rotate([0,0,-90]){
                        makePanelHolePillars(width);
                    }
                }
            }
            if(holes[3]==1){
                translate([0,depth,0]){
                    rotate([0,0,-90]){
                        makePanelHolePillars(width);
                    }
                }
            }
        }
        union(){
            if(holes[0]==1){
                makePanelHoleCutouts(depth);
            }
            if(holes[1]==1){
                translate([width-panelHoleMargin,0,0]){
                    makePanelHoleCutouts(depth);
                }
            } 
            if(holes[2]==1){
                translate([0,panelHoleMargin,0]){
                    rotate([0,0,-90]){
                        makePanelHoleCutouts(width);
                    }
                }
            }
            if(holes[3]==1){
                translate([0,depth,0]){
                    rotate([0,0,-90]){
                        makePanelHoleCutouts(width);
                    }
                }
            }
        }
    }
}

module makeRoundHoleCutter(radius){
    union(){
        translate([0,0,0]){
            cylinder(h=baseThickness+foldThickness+(2*extra),r=radius,center=true);
        }
        for(i=[0:15:360]){
            rotate([0,0,i]){
                translate([radius+borderHoleMargin,0,0]){
                    cylinder(h=baseThickness+foldThickness+(2*extra),r=borderHoleDiam/2.0,center=true);
                }
            }
        }
    }
}


module makeHorizHoleRow(x,y,length){
    holeLength = length - (2*borderHoleMargin);
    
    noOfHoles = floor(holeLength/borderHoleSpacing)-1;
    holeGap = holeLength/noOfHoles;
    for ( i=[0:1:noOfHoles]){
        translate([borderHoleMargin+x + (i*holeGap),y,0]){
        cylinder(h=baseThickness+foldThickness+(2*extra),r=borderHoleDiam/2.0,center=true);
        }
    }
}

module makeVertHoleRow(x,y,length){
    holeLength = length - (2*borderHoleMargin);
    
    noOfHoles = floor(holeLength/borderHoleSpacing)-1;
    holeGap = holeLength/noOfHoles;
    for ( i=[0:1:noOfHoles]){
        translate([x, borderHoleMargin+y + (i*holeGap),0]){
        cylinder(h=baseThickness+foldThickness+(2*extra),r=borderHoleDiam/2.0,center=true);
        }
    }
}

module makeRectHoleCutter(width,depth){
    union(){
        translate([0,0,0]){
            cube([width,depth,baseThickness+foldThickness+(2*extra)],center=true);
        }
        ox= -((width/2) + borderHoleMargin);
        oy= -((depth/2)  + borderHoleMargin);
        bwidth = width + (2*borderHoleMargin);
        bdepth = depth + (2*borderHoleMargin);
        makeHorizHoleRow(ox,oy,bwidth);
        makeHorizHoleRow(ox,oy+bdepth,bwidth);
        makeVertHoleRow(ox,oy,bdepth);
        makeVertHoleRow(ox+bwidth,oy,bdepth);
    }
  }


module makeTemplate(width,depth,height){
    makePanel(height,depth);
    translate([height+margin,0,0]){
        makePanel(width,depth);
    }
    translate([height+(2*margin)+width,0,0]){
        makePanel(height,depth);
    }
    translate([height+margin,depth+margin,0]){
        makePanel(width,height);
    }
    translate([height+margin,depth+(2*margin)+height,0]){
        makePanel(width,depth);
    }
    translate([height+margin,-(margin+height),0]){
        makePanel(width,height);
    }
}


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
        holeGap = depth-panelHoleMargin;
        holeSpacing = holeGap/noOfHoles;
       
        x = width/2.0;
        y = panelHoleMargin/2.0;
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
                            strip(width, depth, height, cornerRadius, holeSpacing, holeRadius,[1,1,1,1]);
                        }
                    }
                }
            }
        }
        translate([0,0,height]){
            rotate ([180,0,0]){
                color("blue",1){
                    strip(width, depth, height, cornerRadius, holeSpacing, holeRadius,[1,1,1,1]);
                }
            }
        }
        translate([width/2.0-cornerRadius,-depth/2.0,0]){
            cube([height+cornerRadius,depth,height+cornerRadius]);
        }
        translate([-1.5*width+height,depth/2,0]){
            //cube([2*width, height,2*width]);
        }
    }
}

module corner(depth, holeSpacing)
{
    cornerRadius = 1.5;
    screwHoleRadius = 1.45;
    accessHoleRadius = 1.6;
    width=13.5;
    height=2;
    
    cornerStrip(width=width, depth=depth, height=height, cornerRadius=cornerRadius, holeSpacing=holeSpacing, holeRadius=accessHoleRadius);

}


module partyCamCase(){
    width=113-(2*margin);
    depth=41-(2*margin);
    height=34-(2*margin);
    tripodHoleDiam=10.0;
    tripodHoleHeight=7.0;
    usbHoleWidth=15;
    usbHoleHeight=9;
    usbHolePos=17;
    union(){
        translate([10,-20,0]){
            corner(height,holeSpacing);
        }

        translate([10,60,0]){
            corner(height,holeSpacing);
        }

        translate([160,60,0]){
            corner(height,holeSpacing);
        }

        translate([160,-20,0]){
            corner(height,holeSpacing);
        }

        difference(){
            union(){
                union(){
                    difference(){
                        union(){
                            makePanel(height,depth,[0,0,1,1]);
                            translate([height-tripodHoleHeight,depth/2.0-tripodHoleDiam/2.0-holePillarOffset,baseThickness+(pillarHeight/2.0)]){
                                cylinder(h=pillarHeight,d1=pillarBotDiam,d2=pillarTopDiam,center=true);
                            }
                            translate([height-tripodHoleHeight,depth/2.0+tripodHoleDiam/2.0+holePillarOffset,baseThickness+(pillarHeight/2.0)]){
                                cylinder(h=pillarHeight,d1=pillarBotDiam,d2=pillarTopDiam,center=true);
                            }

                            translate([height-usbHolePos - usbHoleHeight/2.0,depth/2.0-usbHoleWidth/2.0- holePillarOffset,baseThickness+(pillarHeight/2.0)]){
                                cylinder(h=pillarHeight,d1=pillarBotDiam,d2=pillarTopDiam,center=true);
                            }
                            translate([height-usbHolePos - usbHoleHeight/2.0,depth/2.0+usbHoleWidth/2.0+holePillarOffset,baseThickness+(pillarHeight/2.0)]){
                                cylinder(h=pillarHeight,d1=pillarBotDiam,d2=pillarTopDiam,center=true);
                            }


                        }
                        ch=baseThickness+pillarHeight+(2*extra);

                        translate([height-tripodHoleHeight,depth/2.0,(ch/2)-extra]){
                            cylinder(d=tripodHoleDiam,h=ch,center=true);
                        }
                        
                        translate([height-tripodHoleHeight,depth/2.0+tripodHoleDiam/2.0+holePillarOffset,0]){
                            cylinder(d=holeDiam,h=10,center=true);
                        }
                        translate([height-tripodHoleHeight,depth/2.0-tripodHoleDiam/2.0-holePillarOffset,0]){
                            cylinder(d=holeDiam,h=10,center=true);
                        }
                        
                        translate([height-usbHolePos-(usbHoleHeight/2.0),depth/2.0,(ch/2)-extra]){
                            cube([usbHoleHeight,usbHoleWidth,ch],center=true);
                        }
                        
                        translate([height-usbHolePos- usbHoleHeight/2.0,depth/2.0+usbHoleWidth/2.0+holePillarOffset,0]){
                            cylinder(d=holeDiam,h=10,center=true);
                        }
                        translate([height-usbHolePos - usbHoleHeight/2.0,depth/2.0-usbHoleWidth/2.0-holePillarOffset,0]){
                            cylinder(d=holeDiam,h=10,center=true);
                        }
                        
                    }
                }
                translate([height+margin,0,0]){
                    makePanel(width,depth,[0,0,0,0]);
                }
                translate([height+(2*margin)+width,0,0]){
                    makePanel(height,depth,[0,0,1,1]);
                }
                translate([height+margin,depth+margin,0]){
                    makePanel(width,height,[1,1,0,0]);
                }
                translate([height+margin,-(margin+height),0]){
                    makePanel(width,height,[1,1,0,0]);
                }
            }
        }
    }
}

partyCamCase();
