function [train_X,train_Y,test_X,test_Y] = test_train_split(X,Y,test_size)
cv=cvpartition(size(X,1),'HoldOut',test_size);
index=cv.test;
train_X=X(~index,:);
train_Y=Y(~index,:);
test_X=X(index,:);
test_Y=Y(index,:);
end

