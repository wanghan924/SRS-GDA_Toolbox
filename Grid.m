function [Map, Adj] = Grid(Et,Mt)
%Grid and generate map table and adjacent table 
colen = max(Mt(:,3))*sqrt(length(Et));
rolen = max(Mt(:,2))*sqrt(length(Et));
ne = length(Et);
sne = sqrt(ne);
nm = length(Mt);

%Generate new map table
N = 1: max(Mt(:,1));

for i = 1:length(N)
    Map1 = Et(:,1)+ne*(N(i)-1);
    Map2 = (Mt(i,2)-1)*sne+ Et(:,2);
    Map3 = (Mt(i,3)-1)*sne+ Et(:,3);
    Map(i+(ne-1)*(i-1):i*ne,1) = Map1;
    Map(i+(ne-1)*(i-1):i*ne,2) = Map2;
    Map(i+(ne-1)*(i-1):i*ne,3) = Map3; 
end
%Gave the index of map
Nmap = zeros(colen+2,rolen+2);
for j = 1:length(Map)
    Nmap(Map(j,3)+1,Map(j,2)+1) = Map(j,1);
end

%Generate new adjacent table
Adj = zeros(length(Map),5);
i = 1;
for n = 1:length(Nmap(:,1)) 
    for m = 1:length(Nmap(1,:))
        if Nmap(n,m)~=0
            Adj(i,:) = [Nmap(n,m),Nmap(n-1,m),Nmap(n+1,m),Nmap(n,m+1),Nmap(n,m-1)];
            i = i+1;
        end
     end
end
end