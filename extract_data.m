function [X,Y] = extract_data(filename,table_no)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
M=readmatrix(filename,'Sheet',table_no);
if (length(strfind(filename,'1'))==0 & length(strfind(filename,'4'))==0)
    %not test 1
    M(:,2)=[];
else
    M(6,:)=[];
end

X=[M(:,2:5) M(:,10)];
Y=M(:,11);
end

