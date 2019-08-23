clc
clear


% %% read data from module 1-9
% %train data 
% data_x=[];
% data_y=[];
% for i=3:12
%     [X,Y]=extract_new_data(i);
%     data_x=[data_x; X];
%     data_y=[data_y; Y];
% end
% 
% % %test data
% % [test_X,test_Y]=extract_new_data(12);
% % train_X=data_x;
% % train_Y=data_y;

%% Read from updated data (#1332)

M = readmatrix('full_data.xlsx');
M = shuffle(M);

%filter data in range(start, end)
M = filter_data(M, 80, 100);


Y = M(:,1);
X = M(:,2:7);

%train, test split
test_size = 0.2;
[train_X,train_Y,test_X,test_Y] = test_train_split(X,Y,test_size);

%% start RNN

% data manipulate
norm_train_X = normalize(train_X);
norm_train_Y = train_Y/100;

norm_test_X = normalize(test_X);
norm_test_Y = test_Y/100;

% Define Network Architecture
numResponses = size(norm_train_Y,2);
featureDimension = size(norm_train_X,2);
numHiddenUnits = 16;

layers = [ ...
    sequenceInputLayer(featureDimension)
    lstmLayer(numHiddenUnits,'OutputMode','sequence')
    dropoutLayer(0.5)
    fullyConnectedLayer(numResponses)
    regressionLayer];

maxEpochs = 100;
miniBatchSize = 10;

options = trainingOptions('adam', ...
    'MaxEpochs',maxEpochs, ...
    'MiniBatchSize',miniBatchSize, ...
    'InitialLearnRate',0.01, ...
    'GradientThreshold',0.001, ...
    'Plots','training-progress',...
    'Verbose',0);

% Train the Network
net = trainNetwork(norm_train_X',norm_train_Y',layers,options);

% Test the network
pred_y = predict(net, norm_test_X');


%% Evaluation
pred_y = pred_y';
residual=zeros(size(test_Y));
for i=1:length(test_Y)
    residual(i)=norm_test_Y(i)-pred_y(i);
end
% RMSE
rmse = sqrt(mean((pred_y - norm_test_Y).^2));

MAE = mae(residual);

%R square
Rsq = 1 - sum((norm_test_Y - pred_y).^2)/sum((norm_test_Y - mean(norm_test_Y)).^2);

% rmse = 0.0467

% Residual Plot

figure()
plot(test_Y,residual, 'ro')
hold on
yline(0,'r--')
xlabel('State of Charge')
ylabel('Residual')
legend('Residual','Baseline')
title('SOC VS Residual')

% prediction plot
figure()
plot(test_Y)
hold on
plot(pred_y*100)
xlabel('observations')
ylabel('SOC')
legend('True','Prediction')

