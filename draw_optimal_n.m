optimal_n=[];

for i=1:50
    optimal_ntree=optimal_n_RFregression(train_X,train_Y,test_X,test_Y);
    optimal_n=[optimal_n;optimal_ntree];
end