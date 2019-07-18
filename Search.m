function [des] = Search(sta, list, traj) 
global k;
[m, n] = size(list);
if isempty(find(list(:,1)==sta))
    error('The initial location is invalid');
else
    i = find(list(:,1)==sta);
end  
  
v = list(i,:);  
des = v(randi([2,n],1));  
k = 1;
run = 1;
while run <length(traj)
    for run = 1:length(traj)
        if des  == 0 || des == traj(run)
            des = v(randi([2,n],1));
            run = 1;
            k = k+1;
            if k >= 100
                return
            else
                break
            end
        else
            continue
        end
    end
end
end
