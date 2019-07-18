function [ XY ] = Sample(sta, Adj, Map, NN, Times)
global k;
MM = 1;
% Radom Sampling
for tt = 1:Times
    TRAJ = cell(MM,1);
    ROAD = cell(MM,2);
    % sta = randi(length(Adj),1,1);
    kk = 0;
    while kk <= MM-1
        flag1 = false;
        kk = kk+1;
        temp = sta;
        traj = zeros(1,10000);
        index = 1;
        traj(index) = sta;
        while index <= NN-1 % Number of elements to be selected+1
            temp = Search(temp, Adj, traj);
            if k >= 100
                flag1 = true;
                kk = kk-1;
                break;
            else
                index = index + 1;
                traj(index) = temp;
            end
        end
        if flag1 == true
            continue;
        else
            loca = find(traj > 0);
            traj = traj(loca);
            [road,len] = Mapping(traj, Map);
            TRAJ{kk,1}= traj;
            ROAD{kk,1}= road(:,1);
            ROAD{kk,2}= road(:,2);
        end
    end
    XY = cell2mat(ROAD);
end

end

