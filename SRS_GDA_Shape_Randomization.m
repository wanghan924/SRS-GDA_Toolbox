clear;clc;
load NewMap.mat
load NewAdj.mat
load MapForShape.mat
%% Randomize Shape (keep same size and location)
disp('Please define the inputs, or SRS-GDA toolbox will randomly assign them!');
kk = input('Please tell the resolution of your map: (1:1km, 5:5km, 10:10km)');
NumPoly = input('Please define the number of samples N = ');% Number of samples
Size = input('Please define the size of those samples(km^2) S = ');% size
ctrX = input('Please define x index of the central location of those samples(km) x = ');% Center location: x index
ctrY = input('Please define y index of the central location of those samples(km) y = ');% Center location: y index
Method = input('Please choose random sampling method (1:Shape-unconstrained; 2:Shape-constrained):');% Sampling Method

if isempty(kk)
    error('You must input the resolution of the based map!');
end
if isempty(Method)
    error('You must choose random sampling method!');
end
if isempty(NumPoly)
    NumPoly = randperm(10,1);
end
if isempty(Size)
    NN = randperm(1000,1);
end
switch kk
    case 1
        NN = Size;
    case 5
        NN = ceil(Size/25);
    case 10
        NN = ceil(Size/100);
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


switch Method
    case 1 % Shape unconstrained
        sta = NewMap(ctrX,ctrY);
        i = 1;
        k = 1;
        while k<=NumPoly
            Attampt_XY_shape1 = Sample(sta, Adj, Map, NN, NumPoly);
            figure(i)
            for j = 1:NN
                if j == 1
                    rectangle('Position',[Attampt_XY_shape1(j,1)-0.5,Attampt_XY_shape1(j,2)-0.5,1,1],'FaceColor','k');
                else
                    hold on
                    rectangle('Position',[Attampt_XY_shape1(j,1)-0.5,Attampt_XY_shape1(j,2)-0.5,1,1],'FaceColor','r');
                end
            end
            axis equal;
            axis off;
            fname = ['Attampt_',num2str(i),'.png'];
            saveas(gcf, fname);
            close(figure(i));
            i = i+1;
            [lib] = Holes(fname);
            if lib == 0
                XY_shape1{k}= Attampt_XY_shape1;
                fname = ['Shape_free_',num2str(k),'.png'];
                saveas(gcf, fname);
                k = k+1;
            end
        end
        close(figure(1));
        figure
         for ii = 1:NumPoly
            subplot(NumPoly,2,ii*2-1)
            for j = 1:NN
                if j == 1
                    rectangle('Position',[XY_shape1{ii}(j,1)-0.5,XY_shape1{ii}(j,2)-0.5,1,1],'FaceColor',[0.7,0.7,0.7]);
                else
                    hold on
                    rectangle('Position',[XY_shape1{ii}(j,1)-0.5,XY_shape1{ii}(j,2)-0.5,1,1]);
                end
            end
            axis equal;
            axis off;
            title(['Sample ',num2str(ii),' (grid size = ',num2str(kk),'km*',num2str(kk),'km)']);
         end
         delete *.png;
         save Info_Shape_unconstrained.mat XY_shape1;
    case 2 % Shape constrained
        sp = input('Please define the shape index sp = ');% Shape index
        if isempty(sp)
            sp = 5*rand;
        end
        id = 1;
        irregularity = input('Please define the irregularity of the shape(0~1) ir = ');% Shape index
        if isempty(irregularity)
            irregularity = 0.3;
        end
        spikeyness = input('Please define the spikeyness of the shape(0~1) sn = ');% Shape index
        if isempty(spikeyness)
            spikeyness = 0.1;
        end
        while id <= NumPoly
            aveRadius_x = ceil(sqrt(NN./sp));
            aveRadius_y = aveRadius_x * sp;
            numVerts=5; % numVerts=randi([3 7],1,1);
            [x,y] = generatePolygon2(ctrX,ctrY,aveRadius_x,aveRadius_y,irregularity,spikeyness,numVerts);
            A = polyarea(x,y);
            while fix(A) ~= NN+5
                aveRadius_x = randi([1 ceil(sqrt(NN./sp))*2],1,1);
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
                XY_shape2{id} = [X,Y];
                id = id+1;
            elseif deltaN>0
                flag = 1;
            else
                XY_shape2{id} = [X,Y];
                id = id+1;
            end
        end
        save Info_Shape_constrained.mat XY_shape2;
        figure
        for id = 1:NumPoly
            subplot(NumPoly,2,id*2-1)
            for i = 1: length(XY_shape2{id}(:,1))
                rectangle('Position',[XY_shape2{id}(i,1)-0.5,XY_shape2{id}(i,2)-0.5,1,1]);
                hold on
                rectangle('Position',[ctrX-0.5,ctrY-0.5,1,1],'FaceColor',[0.7,0.7,0.7]);
            end
            axis equal;
            axis off;
            title(['Sample ',num2str(id),' (sp = ',num2str(sp),', grid size = ',num2str(kk),'km*',num2str(kk),'km)']);
        end
end
plotindex = (2:2:NumPoly*2);
subplot(NumPoly,2,plotindex)
NewMap(~isnan(NewMap))=1;
f = imagesc(NewMap');
set(f,'alphadata',~isnan(NewMap'));
title('Location of those samples');
xlabel(['Easting (grid per ',num2str(kk),'km)']);
ylabel(['Southing (grid per ',num2str(kk),'km)']);
set(gca,'ydir','reverse');
grid on;
hold on;
plot(ctrX,ctrY,'*r','MarkerSize',8);
title(['Central Location of those samples x=',num2str(ctrX*kk),'km y=',num2str(ctrY*kk),'km']);
disp(['The modified size is ',num2str(NN*kk*kk),'km^2']);