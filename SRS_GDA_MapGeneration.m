clear;clc;
%% This is the first part of program to generate digital indexed map under defined
At = load('adjtable.txt');  % Adjacency table
disp('Please note that the toolbox has its matching Map which is the mainland of United Kindom!');
scene = input('Do you want to use your map (size:km*km)? (Yes:1/No:2)');
inputid = str2double(inputdlg({'Please choose subdivision rule (1:1km*1km;2:5km*5km;3:10km*10km)'},'Generate Grid-based Map',1,{'1'}));
switch inputid
    case 3 % Rule: 10km*10km
        inputEt = '10km*10km';
        for i = 1:10
            for j = 1:10
                Et(j+(i-1)*10,1) = j+(i-1)*10;
                Et(j+(i-1)*10,2) = j;
                Et(j+(i-1)*10,3) = i;
            end
        end
    case 2 % Rule: 5km*5km
        inputEt = '5km*5km';
        for i = 1:20
            for j = 1:20
                Et(j+(i-1)*20,1) = j+(i-1)*20;
                Et(j+(i-1)*20,2) = j;
                Et(j+(i-1)*20,3) = i;
            end
        end
    case 1 % Rule: 1km*1km
        inputEt = '1km*1km';
        for i = 1:100
            for j = 1:100
                Et(j+(i-1)*100,1) = j+(i-1)*100;
                Et(j+(i-1)*100,2) = j;
                Et(j+(i-1)*100,3) = i;
            end
        end
end
inter = 100;
if isempty(scene)
    error('Invalid input!');
elseif scene ==1
    [Filename, Pathname]=uigetfile({'*.jpg';'*.bmp';'*.png';'*.tiff'},'Map Selector');
    filemap1 = [Pathname,'\',Filename];
    if (Filename~=0)
        Data = imread(Filename);
        P = double(Data(:,:,1));
    else
        return
    end
    for i = 1:ceil(length(P(:,1))/inter)
        for j = 1:ceil(length(P(1,:))/inter)
            Mt(j+(i-1)*ceil(length(P(1,:))/inter),1) = j+(i-1)*ceil(length(P(1,:))/inter);
            Mt(j+(i-1)*ceil(length(P(1,:))/inter),2) = j;
            Mt(j+(i-1)*ceil(length(P(1,:))/inter),3) = i;
        end
    end
elseif scene ==2
    Mt = load('MapUK.txt');  % Medium table (UK)
end

[Map, Adj] = Grid(Et,Mt);

switch scene
    case 1
        if (Filename~=0)
            ind = find(P == P(1,1));
            P(ind)= NaN;
            numcell = max([ceil(length(P(:,1))/inter)*inter,ceil(length(P(1,:))/inter)*inter]);
            PP = zeros(numcell,numcell)*NaN;
            PP(1:length(P(:,1)),1:length(P(1,:))) = P;
            if inputid == 1
                KMap = P';
            elseif inputid == 2
                row = ones(1,numcell/5)*5;
                col = ones(1,numcell/5)*5;
                B=mat2cell(PP,row,col);
                for i = 1:ceil(length(P(:,1))/inter)*inter/5
                    for j = 1:ceil(length(P(1,:))/inter)*inter/5
                        num = sum(isnan(B{i,j}(:)));
                        if num > 12.5
                            KMap(j,i) = NaN;
                        else
                            KMap(j,i) = 1;
                        end
                    end
                end
            elseif inputid == 3
                row = ones(1,numcell/10)*10;
                col = ones(1,numcell/10)*10;
                B=mat2cell(PP,row,col);
                for i = 1:ceil(length(P(:,1))/inter)*inter/10
                    for j = 1:ceil(length(P(1,:))/inter)*inter/10
                        num = sum(isnan(B{i,j}(:)));
                        if num >= 50
                            KMap(j,i) = NaN;
                        else
                            KMap(j,i) = 1;
                        end
                    end
                end
            end
            id = find(Map(:,3)> length(KMap(1,:)));
            Map(id,:)=[];
            id1 = find(Map(:,2)> length(KMap(:,1)));
            Map(id1,:)=[];
            SMap = [];
            for t = 1:length(Map)
                SMap(Map(t,2),Map(t,3)) = Map(t,1);
            end
        else
            error('No input map!');
        end
    case 2
        load('Original_UK_map_1km.mat');
        P = Original_UK_Map_1km';
        numcell = max([ceil(length(P(:,1))/inter)*inter,ceil(length(P(1,:))/inter)*inter]);
        PP = zeros(numcell,numcell)*NaN;
        PP(1:length(P(:,1)),1:length(P(1,:))) = P;
        if inputid == 1
            KMap = P';
        elseif inputid == 2
            row = ones(1,numcell/5)*5;
            col = ones(1,numcell/5)*5;
            B=mat2cell(PP,row,col);
            for i = 1:ceil(length(P(:,1))/inter)*inter/5
                for j = 1:ceil(length(P(1,:))/inter)*inter/5
                    num = sum(isnan(B{i,j}(:)));
                    if num > 12.5
                        KMap(j,i) = NaN;
                    else
                        KMap(j,i) = 1;
                    end
                end
            end
        elseif inputid == 3
            row = ones(1,numcell/10)*10;
            col = ones(1,numcell/10)*10;
            B=mat2cell(PP,row,col);
            for i = 1:ceil(length(P(:,1))/inter)*inter/10
                for j = 1:ceil(length(P(1,:))/inter)*inter/10
                    num = sum(isnan(B{i,j}(:)));
                    if num >= 50
                        KMap(j,i) = NaN;
                    else
                        KMap(j,i) = 1;
                    end
                end
            end
        end
        id = find(Map(:,3)> length(KMap(1,:)));
        Map(id,:)=[];
        id1 = find(Map(:,2)> length(KMap(:,1)));
        Map(id1,:)=[];
        SMap = [];
        for t = 1:length(Map)
            SMap(Map(t,2),Map(t,3)) = Map(t,1);
        end
end
id3 = find(isnan(KMap));
Adj(ismember(Adj, SMap(id3)))= 0;
id2 = find(Adj(:,1)== 0);
Adj(id2,:)=[]; % Get New Adj Table
NewMap = SMap;
for i = 1:length(SMap(:,1))
    for j = 1:length(SMap(1,:))
        if isnan(KMap(i,j))
            NewMap(i,j) = NaN;
        end
    end
end
save NewMap.mat NewMap;
save NewAdj.mat Adj;
save MapForShape.mat Map;

figure
NewMap(~isnan(NewMap))=1;
f = imagesc(NewMap');
set(f,'alphadata',~isnan(NewMap'));
title(['Resolution ',inputEt],'FontSize',15);
xlabel('Easting','FontSize',15);
ylabel('Southing','FontSize',15);
set(gca,'ydir','reverse');

msgbox('The new map has been saved as NewMap.mat! Grid-based Map Generation has been done!');

txtid = input('Do you want to save the map as txt file? (Yes: please type 1; No:please press Enter)');
if ~isempty(txtid)
    [FileName PathName]=uiputfile({
        '*.txt','Txt Files(*.txt)';'*.*','All Files(*.*)'},'save results');
    if FileName==0
        return;
    else
        fop = fopen( FileName, 'wt' );
        [M,N] = size(NewMap);
        h=waitbar(0,'Start saving map...');
        pause(0.5);
        for m = 1:M
            for n = 1:N
                fprintf( fop, ' %s', mat2str( NewMap(m,n) ) );
            end
            fprintf(fop, '\n' );
            waitbar(m/M,h,['Processing map...' num2str(roundn(m/M,-2).*100) '%']);
            pause(0.05);
        end
        fclose( fop ) ;
    end
    close(h);
    msgbox('Map has been saved as txt file!');
else
    return
end