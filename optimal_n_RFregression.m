function optimal_ntree=optimal_n_RFregression(dataset, k)
%'''cosider normalize here'''
min_rmse=10000;
optimal_ntree=0;
for ntree = 10:10:100
    % sample from dataset
    sample_data = datasample(dataset, k);
    split = round(k * 0.8);
    train = sample_data(1:split,:);
    test = sample_data(split+1:k,:);
    
    train_X = train(:,1:6);
    train_Y = train(:,7);
    test_X = test(:,1:6);
    test_Y = test(:,7);
    [model,pred_y,rmse]=random_forest_regression(ntree,train_X,train_Y,test_X,test_Y);
    if rmse<min_rmse
        min_rmse=rmse;
        optimal_ntree=ntree;
    end
end

end