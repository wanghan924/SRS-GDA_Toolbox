clear;clc;
load NewMap.mat
% load NewAdj.mat
%% Randomize location (keep same size and shape)
% Inputs:
disp('Please define the inputs, or SRS-GDA toolbox will randomly assign them!');
k = input('Please tell the resolution (km) of your map: (1:1km, 5:5km, 10:10km)');
NumPoly = input('Please define the number of samples N = ');% Number of samples
Size = input('Please define the size of those samples(km^2) S = ');% size
ctrX = input('Please define x index of the central location for original(km) x = ');% Center location: x index
ctrY = input('Please define y index of the central location for original(km) y = ');% Center location: y index
sp = input('Please define the shape index sp = ');% Shape index
if isempty(k)
    error('You must input the resolution of the based map!');
end
if isempty(NumPoly)
    NumPoly = randperm(10,1);
end
if isempty(Size)
    NN = randperm(1000,1);
end
switch k
    case 1
        NN = Size;
    case 5
        NN = floor(Size/25);
    case 10
        NN = floor(Size/100);
end
if isempty(ctrX) && isempty(ctrY)
    sta = NewMap(~isnan(NewMap));
    x_sta = sta(randi(length(sta)));
    [ctrX,ctrY]=find(NewMap == x_sta);
elseif isempty(ctrX) && ~isempty(ctrY)
    [cX,~]=find(~isnan(NewMap(:,ctrY)));
    ctrX = cX(randi(length(cX)),1); 
elseif ~isempty(ctrX) && isempty(ctrY)
    [~,cY]=find(~isnan(NewMap(ctrX,:)));
    ctrY = cY(randi(length(cY)),1);
end
if isempty(sp)
    sp = rand;
end

aveRadius_x = randi([1,NN],1,1);
aveRadius_y = aveRadius_x * sp;
irregularity=rand;
spikeyness=rand*0.1;
numVerts=randi([3 7],1,1);
[x,y] = generatePolygon2(ctrX,ctrY,aveRadius_x,aveRadius_y,irregularity,spikeyness,numVerts);
A = polyarea(x,y);
while fix(A) ~= NN+5
    aveRadius_x = randi([1 NN*2],1,1);
    aveRadius_y = aveRadius_x * sp;
    [x,y] = generatePolygon2(ctrX,ctrY,aveRadius_x,aveRadius_y,irregularity,spikeyness,randi([3 7],1,1));
    A = polyarea(x,y);
end
xx=(fix(min(x)):1:fix(max(x)));
yy=(fix(min(y)):1:fix(max(y)));
N = 0;
for i = 1:length(xx)
    for j = 1:length(yy)
        in=inpolygon(xx(i),yy(j),x,y);
        if double(in) == 1
            N = N+1;
            X(N,1) = xx(i);
            Y(N,1) = yy(j);
        end
    end
end
deltaN = NN-N;
flag = 0;
if deltaN<0
    X(NN+1:end) = [];
    Y(NN+1:end) = [];
    XY{1} = [X,Y];
elseif deltaN>0
    flag = 1;
else
    XY{1} = [X,Y];
end

disp(['The true size is ',num2str(NN*k^2),'km^2']);

% Show figures
figure
subplot(1,2,1)
Color = [rand rand rand];
for j = 1:length(XY{1,1}(:,1))
    rectangle('Position',[XY{1,1}(j,1)-0.5,XY{1,1}(j,2)-0.5,1,1],'FaceColor',Color);
    hold on;
end
axis equal;
axis off;
title(['Sample with ',num2str(k),'km*',num2str(k),'km grid']);
subplot(1,2,2)
NewMap(~isnan(NewMap))=1;
f = imagesc(NewMap');
set(f,'alphadata',~isnan(NewMap'));
title('Samples with same shape and size but different locations');
xlabel(['Easting (grid per ',num2str(k),'km)']);
ylabel(['Southing (grid per ',num2str(k),'km)']);
% ylim([0 1300]);
grid on;
hold on;
h=waitbar(0,'Begin to do generate sample,please waite...');
pause(0.5);
i = 1;
while i <= NumPoly
    waitbar((i)/NumPoly,h,['Now generating the ' num2str(i) 'th sample...']); 
    pause(0.1);
    flag = 0;
    move_x = randsrc(1).*randi([0 ctrX-1],1,1);
    move_y = randsrc(1).*randi([0 ctrY-1],1,1);
    if isempty(find(XY{1,1}(:,1)+move_x<length(NewMap(:,1)))) || isempty(find(XY{1,1}(:,2)+move_y<length(NewMap(1,:))))
        flag = 1;
    else
        for j = 1:NN
            XY_location{1,i}(j,1) = XY{1,1}(j,1)+ move_x;
            XY_location{1,i}(j,2) = XY{1,1}(j,2)+ move_y;
            if XY_location{1,i}(j,1)<=0 || XY_location{1,i}(j,1)>length(NewMap(:,1)) || XY_location{1,i}(j,2)<=0 || XY_location{1,i}(j,2)> length(NewMap(1,:))
                flag = 1;
                break
            end
            if isnan(NewMap(XY_location{1,i}(j,1),XY_location{1,i}(j,2)))
                flag = 1;
                break
            end
        end
    end
    if flag == 0
        i = i+1;
    end
end
close(h)
for i = 1:NumPoly
    for j = 1:length(XY_location{1,NumPoly+1-i}(:,1))
        rectangle('Position',[XY_location{1,NumPoly+1-i}(j,1)-0.5,XY_location{1,NumPoly+1-i}(j,2)-0.5,1,1],'FaceColor','r');
        hold on;
    end
    axis equal;
end
save Info_Location.mat XY_location;
