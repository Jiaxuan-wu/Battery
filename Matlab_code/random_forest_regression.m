function [model,pred_y,rmse] = random_forest_regression(nTree,train_X,train_Y,test_X,test_Y)
model=TreeBagger(nTree,train_X,train_Y,'Method','regression');
pred_y=predict(model,test_X);
rmse=sqrt(mean((pred_y-test_Y).^2));
end

