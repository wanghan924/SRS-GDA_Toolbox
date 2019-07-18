function [road, len] = Mapping(traj, mt)  
len = length(traj);  
road = zeros(len, 2);  
for i = 1:len 
    k = mt(:,1) == traj(i);  
    road(i,:) = mt(k,2:3);  
end
end

