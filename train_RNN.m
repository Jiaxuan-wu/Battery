function rmse = train_RNN(norm_train_X, norm_train_Y, norm_test_X, norm_test_Y)
    % Define Network Architecture
    numResponses = size(norm_train_Y,2);
    featureDimension = size(norm_train_X,2);
    numHiddenUnits = 50;

    layers = [ ...
        sequenceInputLayer(featureDimension)
        lstmLayer(numHiddenUnits,'OutputMode','sequence')
        fullyConnectedLayer(20)
        dropoutLayer(0.5)
        fullyConnectedLayer(numResponses)
        regressionLayer];

    maxEpochs = 30;
    miniBatchSize = 10;

    options = trainingOptions('adam', ...
        'MaxEpochs',maxEpochs, ...
        'MiniBatchSize',miniBatchSize, ...
        'InitialLearnRate',0.01, ...
        'GradientThreshold',0.01, ...
        'Shuffle','never', ...
        'Plots','training-progress',...
        'Verbose',0);

    % Train the Network
    net = trainNetwork(norm_train_X',norm_train_Y',layers,options);

    % Test the network
    pred_y = predict(net, norm_test_X');


    %% Evaluation

    % RMSE
    rmse = sqrt(mean((pred_y - norm_test_Y').^2));

end

