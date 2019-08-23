clear 
clc
%% read data
%Test 1
[X1_PB1,Y1_PB1]=extract_data('Test01.xlsx',3);
[X1_LG,Y1_LG]=extract_data('Test01.xlsx',10);
[X1_PB2,Y1_PB2]=extract_data('Test01.xlsx',17);

%Test 2
[X2_PB1,Y2_PB1]=extract_data('Test02.xlsx',5);
[X2_LG,Y2_LG]=extract_data('Test02.xlsx',12);
[X2_PB2,Y2_PB2]=extract_data('Test02.xlsx',19);

%Test 3
[X3_PB1,Y3_PB1]=extract_data('Test03.xlsx',5);
[X3_LG,Y3_LG]=extract_data('Test03.xlsx',12);
[X3_PB2,Y3_PB2]=extract_data('Test03.xlsx',19);

%Test 4
[X4_PB1,Y4_PB1]=extract_data('Test04.xlsx',5);
% [X4_LG,Y4_LG]=extract_data('Test04.xlsx',12);
% [X4_PB2,Y4_PB2]=extract_data('Test04.xlsx',19);

%% new data --- aggregate 10 module
M=readmatrix('new_data.xlsx','Sheet',2);
Y=M(:,1);
X=M(:,2:7);


%% combine and split train and test

level=30;
X=[X1_PB1;X1_LG;X1_PB2;X2_PB1;X2_LG;X2_PB2;X3_PB1;X3_LG;X3_PB2];
Y=[Y1_PB1;Y1_LG;Y1_PB2;Y2_PB1;Y2_LG;Y2_PB2;Y3_PB1;Y3_LG;Y3_PB2];


%% Start Random forest
Y=Y>30;
accuracy=[];
test_size=0.3;
nTree=50;
%begin with generate decision trees
for i=1:100
    [train_X,train_Y,test_X,test_Y] = test_train_split(X,Y,test_size);
    pred_label = random_forest_classifier(nTree,train_X,train_Y,normalize(test_X),test_Y);
    C=confusionmat(double(test_Y),pred_label);
    score=(C(1,1)+C(2,2))/sum(sum(C));
    accuracy=[accuracy;score]; 
end
% %evaluate
% C=confusionmat(double(test_Y),pred_label);
% confusionchart(C);
% 
% figure;
% oobErrorBaggedEnsemble = oobError(tree);
% plot(oobErrorBaggedEnsemble)
% xlabel 'Number of grown trees';
% ylabel 'Out-of-bag classification error';

%% start random forest regression
rmse=[];
test_size=0.3;
for i=1:100
    [train_X,train_Y,test_X,test_Y] = test_train_split(X,Y,test_size);
    [model,pred_y,score] = random_forest_regression(80,normalize(train_X),train_Y/100,normalize(test_X),test_Y/100);
    rmse=[rmse;score];  
    
end

% 
% yy=[Y4_PB1/100 pred_y4];
% yy_sort=sortrows(yy,1);
% figure()
% plot(yy_sort(:,1))
% hold on
% plot(yy_sort(:,2))


%% SVM classfier

Y=Y>30;
accuracy=[];
test_size=0.3;
for i=1:100
    [train_X,train_Y,test_X,test_Y] = test_train_split(X,Y,test_size);
    SVMModel = fitcsvm(train_X,train_Y,'KernelFunction','Linear','Standardize',true);
    label=predict(SVMModel,test_X);
    C=confusionmat(test_Y,label);
    score=(C(1,1)+C(2,2))/sum(sum(C));
    accuracy=[accuracy;score];
end

figure;
gscatter(test_X(:,1),test_X(:,2),test_Y,'rb');
hold on
gscatter(test_X(:,1),test_X(:,2),label,'kr','*d');
xlabel('OCV(V)');
ylabel('Rhf(Ohm)');
legend('true-SOC<30%','true-SOC>30%','pred-SOC<30%','pred-SOC>30%')