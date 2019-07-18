function [lib] = Holes(fname) 
% This function helps detect ill-set samples
I = imread(fname);
BW = ~im2bw(I,0.5);
BW2 = bwperim(BW,18);
BW3 = bwfill(BW,'holes');
BW4 = BW3-BW2;
lib = ismember(1,BW4);
end