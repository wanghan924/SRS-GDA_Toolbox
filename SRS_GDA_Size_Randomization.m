clear;clc;
load NewMap.mat
load NewAdj.mat
%% Randomize size (keep same size and location)
% Inputs:
disp('Please define the inputs, or SRS-GDA toolbox will randomly assign them!');
k = input('Please tell the resolution of your map: (1:1km, 5:5km, 10:10km)');
NumPoly = input('Please define the number of samples N = ');% Number of samples
Size = input('Please define an approximate begining size of those samples(km^2) S = ');% size
ctrX = input('Please define x index of the central location of those samples(km) x = ');% Center location: x index
ctrY = input('Please define y index of the central location of those samples(km) y = ');% Center location: y index
sp = input('Please define the shape index sp = ');% Shape index
if isempty(k)
    error('You must input the resolution of the based map!');
end
if isempty(NumPoly)
    NumPoly = randperm(10,1);
end
if isempty(Size)
    NN = randperm(100,1);
end
switch k
    case 1
        NN = Size;
    case 5
        NN = round(Size/25);
    case 10
        NN = round(Size/100);
end
if isempty(ctrX) && isempty(ctrY)
    x_sta = randi(length(Adj),1,1);
    sta = Adj(x_sta,1);
    [ctrX,ctrY]=find(NewMap == sta);
elseif isempty(ctrX) && ~isempty(ctrY)
    [cX,~]=find(~isnan(NewMap(:,ctrY)));
    ctrX = cX(randi(length(cX)),1); 
elseif ~isempty(ctrX) && isempty(ctrY)
    [~,cY]=find(~isnan(NewMap(ctrX,:)));
    ctrY = cY(randi(length(cY)),1);
end
if isempty(sp)
    sp = 5*rand;
end
InRatio = 0.2; % Increasing step
aveRadius_x = randi([1 NN*10],1,1);
aveRadius_y = aveRadius_x * sp;
irregularity=rand;
spikeyness=rand*0.1;
numVerts=randi([3 7],1,1);
% Start generation
[x,y] = generatePolygon(ctrX,ctrY,aveRadius_x,aveRadius_y,irregularity,spikeyness,numVerts,InRatio,NumPoly);
A = polyarea(x,y);
while round(A(1)) ~= NN
    aveRadius_x = randi([1 NN*10],1,1);
    aveRadius_y = aveRadius_x * sp;
    [x,y] = generatePolygon(ctrX,ctrY,aveRadius_x,aveRadius_y,irregularity,spikeyness,numVerts,InRatio,NumPoly);
    A = polyarea(x,y);
end
for id = 1:NumPoly
    in_x = x(:,id);
    in_y = y(:,id);
    xx=(fix(min(in_x)):1:fix(max(in_x)));
    yy=(fix(min(in_y)):1:fix(max(in_y)));
    N = 0;
    for i = 1:length(xx)
        for j = 1:length(yy)
            in=inpolygon(xx(i),yy(j),in_x,in_y);
            if double(in) == 1
                N = N+1;
                X(N,1) = xx(i);
                Y(N,1) = yy(j);
            end
        end
    end
    XY_size{id} = [X,Y];
    disp(['The Size of sample ',num2str(id),' is ',num2str(length(XY_size{id})*k^2),'km^2']);
end
figure
subplot(1,2,1)
for i = 1:NumPoly
    Color = [rand rand rand];
    for j = 1:length(XY_size{1,NumPoly+1-i}(:,1))
        rectangle('Position',[XY_size{1,NumPoly+1-i}(j,1)-0.5,XY_size{1,NumPoly+1-i}(j,2)-0.5,1,1],'FaceColor',Color);
        hold on;
    end
    axis equal;
    axis off;
end
title('Samples with same shape and location but different sizes');
subplot(1,2,2)
NewMap(~isnan(NewMap))=1;
f = imagesc(NewMap');
set(f,'alphadata',~isnan(NewMap'));
title('Location of those samples');
xlabel(['Easting (grid per ',num2str(k),'km)']);
ylabel(['Southing (grid per ',num2str(k),'km)']);
grid on;
hold on;
plot(ctrX,ctrY,'*r','MarkerSize',8);
title('Location of those samples');
save Info_Size.mat XY_size;