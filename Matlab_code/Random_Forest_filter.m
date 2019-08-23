clc
clear

% %% read data from module 1-9
% %train data 
% data_x=[];
% data_y=[];
% for i=3:11
%     [X,Y]=extract_new_data(i);
%     data_x=[data_x; X];
%     data_y=[data_y; Y];
% end
% 
% %test data
% [test_X,test_Y]=extract_new_data(12);
%% Read from updated data (#1332)

M = readmatrix('full_data.xlsx');
M = shuffle(M);
M = filter_data(M, 80, 100);
Y = M(:,1);
X = M(:,2:7);

%train, test split
test_size = 0.2;
[train_X,train_Y,test_X,test_Y] = test_train_split(X,Y,test_size);

train_X=normalize(train_X);
train_Y=train_Y/100;
test_X = normalize(test_X);
test_Y = test_Y/100;
%% start random forest regression

%find optimal value of ntree
% optimal_n = [];
% k = 200;
% dataset = [train_X, train_Y];
% for i=1:100
%     optimal_ntree=optimal_n_RFregression(dataset, k);
%     optimal_n=[optimal_n;optimal_ntree];
% end
% figure(1)
% histogram(optimal_n, 20)
optimal_nTree = 60;
[model,pred_y,score] = random_forest_regression(optimal_nTree,train_X,train_Y,test_X,test_Y);
% previous rmse is 0.02
% rmse=0.0609

%% plot
figure(2)
plot(test_Y*100,'b');
hold on
plot(pred_y*100,'r-');
legend('true value','predict value')
ylabel('SOC')



%% Residual plot

residual=zeros(size(test_Y));
for i=1:length(test_Y)
    residual(i)=test_Y(i)-pred_y(i);
end

rmse = score;
Rsq = 1 - sum((test_Y - pred_y).^2)/sum((test_Y - mean(test_Y)).^2);
MAE = mae(residual);
figure(3)
plot(test_Y*100,residual,'ro')
hold on
yline(0,'r--')
xlabel('State of Charge')
ylabel('Residual')
legend('Residual','Baseline')
title('SOC VS Residual')
