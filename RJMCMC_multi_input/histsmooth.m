function [ B,H ] = histsmooth( b,h )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
if numel(b)>=2
deltab=b(2)-b(1);
B=[b(1)-deltab,b,b(end)+deltab];
H=[0,h,0]+[h,0,0]./2+[0,0,h]./2;
end
B=b;
H=h;
end

