function [X,Y] = extract_new_data(sheet_no)

M=readmatrix('new_data.xlsx','Sheet',sheet_no);
Y=M(:,1);
X=M(:,2:7);


end

