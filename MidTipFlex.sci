// DON'T TOUCH THESE FUNCTIONS, USE THEM IN YOUR CODE BELOW ---------------------------------------------------------------------
function [displacement,vel] = accelIntegrate(time,accel,v0,d0)
        
    // initialize velocity and displacement matrices
    vel = zeros(time)+v0;
    displacement = zeros(time)+d0;
    
    // Integrate to find velocity data
    len = size(accel,'r');
    h = waitbar(0,'0% Complete');
    
    for i = 2:size(accel,'r')
        vel(i) = vel(i) + intsplin(time(1:i),accel(1:i));
        displacement(i) = displacement(i) + intsplin(time(1:i),vel(1:i));
        waitbar(i/len,strcat([part(string(100*i/len),1:5),'% Complete']),h);
    end

    close(h);
    plot(time,accel,time,vel,time,displacement);
    
endfunction

function [transPoint] = pointTransform(point,localOrigin,xRot,yRot,zRot,order,toLocal)
    
//    point =         point you want transformed
//    localOrigin =   coordinates of new origin in the Global Coordinate System
//    xRot =          X - Rotation (phi)
//    yRot =          Y - Rotation (theta)
//    zRot =          Z - Rotation (psi)
//    order =         Order of axis rotation (xyz,zyx,yzx,etc...)
//    toLocal =       %t if going from global to local
//                    %f if going from local to global

    transPoint = zeros(point);
    
    phi = xRot*%pi/180;
    theta = yRot*%pi/180;
    psi = zRot*%pi/180;
    
    order = strsplit(order);
    
    for i = 1:3
        if ((order(i) == 'x') | (order(i) == 'X')) then
            A = [1 0 0;0 cos(phi) sin(phi); 0 -sin(phi) cos(phi)];
        elseif ((order(i) == 'y') | (order(i) == 'Y')) then
            A = [cos(theta) 0 -sin(theta); 0 1 0; sin(theta) 0 cos(theta)];
        else
            A = [cos(psi) sin(psi) 0; -sin(psi) cos(psi) 0; 0 0 1];
        end
    
        if i == 1 then
            R = A;
        else
            R = A*R;
        end
    end
    
    if toLocal then
        for i = 1:size(point,'r')
            temp = point(i,:)-localOrigin;
            temp = (R*temp')';
            transPoint(i,:) = temp;
        end
        
    else
        for i = 1:size(point,'r')
            temp = point(i,:);
            temp = (R\temp')';
            transPoint(i,:) = temp+localOrigin;
        end
        
    end
endfunction
// ----------------------------------------------------------------------------------------------------------------------------

// Body of Code for Extranneous Calculations for Mid Tip Flexure --------------------------------------------------------------












//-----------------------------------------------------------------------------------------------------------------------------


//More testing