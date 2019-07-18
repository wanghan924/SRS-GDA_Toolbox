function [ x,y ] = generatePolygon2( ctrX, ctrY, aveRadius_x, aveRadius_y , irregularity, spikeyness, numVerts )
% Detailed explanation goes here
% Start with the centre of the polygon at (ctrX,ctrY) 
% then creates the polygon by sampling points on a circle around the centre. 
% Randon noise is added by varying the angular spacing between sequential points,
% and by varying the radial distance of each point from the centre.

for i = 1:length(irregularity)
    if irregularity(i) <=0
        irregularity(i) = 0;
    elseif irregularity(i) >=1
        irregularity(i) = 1;
    end
end

for i = 1:length(spikeyness)
    if spikeyness(i) <=0
        spikeyness(i) = 0;
    elseif spikeyness(i) >=1
        spikeyness(i) = 1;
    end
end
Irregularity = irregularity*2*pi / numVerts;
Spikeyness_x = spikeyness * aveRadius_x;
Spikeyness_y = spikeyness * aveRadius_y;
% generate n angle steps
angleSteps = [];
AngleSteps = [];
lower = (2*pi / numVerts) - Irregularity;
upper = (2*pi / numVerts) + Irregularity;
sum = 0;
for i = 1:numVerts
    tmp = lower + (upper-lower).*rand;
    angleSteps(i) = tmp;
    sum = sum + tmp;
end

% normalize the steps so that point 0 and point n+1 are the same
k = sum / (2*pi);
for i = 1:numVerts
    AngleSteps(i) = angleSteps(i)/k;
end

% now generate the points
points = [];
angle = 2*pi.*rand;
for i = 1:numVerts
    r_x(i) = normrnd(aveRadius_x, Spikeyness_x);
    r_y(i) = normrnd(aveRadius_y, Spikeyness_y);
    if r_x(i) <=0
        r_x(i) = 0;
    elseif r_x(i) >= 2*aveRadius_x
    r_x(i) = 2*aveRadius_x;
    end
    x(i,1) = ctrX + r_x(i)*cos(angle);
    if r_y(i) <=0
        r_y(i) = 0;
    elseif r_y(i) >= 2*aveRadius_y
    r_y(i) = 2*aveRadius_y;
    end
    y(i,1) = ctrY + r_y(i)*sin(angle);
    angle = angle + angleSteps(i);
end
x(numVerts+1,1) = x(1,1);
y(numVerts+1,1) = y(1,1);
end

