function plot_bearings(ax,bearing,obj)

for i=bearing
    zp=i.cnfg.position;
    
    bearing_pos = bearing.position; %Anders will die Funktion drunter dies nicht annehmen --> too many input arguments
    diameter = obj.get_diameter(bearing_pos);
    
    % Zylinderfläche;
    [x,y,z] = cylinder(diameter);

    h = surf(ax, x, y, z*0.01+zp);

    set(h, 'edgecolor','none')
    set(h, 'facecolor','[1 .5 0]')

end