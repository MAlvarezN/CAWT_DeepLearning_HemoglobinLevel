% deepL_calibration_v1
% 
% 
%
% Michael Alvarez
% michael.alvarez2@upr.edu

close all force
clear
clc

addpath(genpath('.\..\..\Codes\TwoGaussian\'))


filepath = '.\..\..\Data Lab v2\ref_ppg\';

filepathsave = '.\oxyHemo_clasicApproach\' ;

load( 'xlsxfiles' )


load(strcat( filepathsave +"listErrors" ) )
mn = size( xlsxfiles ) ;

for kf = 1 : mn(1)
    
    filename = xlsxfiles(kf).name ;    
    filemat = strcat( filename(1:end-4) , 'mat') ;
    
load( strcat( filepathsave , filemat(1:end-4) , "_OxyHemo") , 'data' )

A = data.hemoMatrix / 1e5 ;
m  = tril(true(size(A))) ;
v = A(m) ;

inputs(:,kf) = v ;
targets(1,kf) = data.hemoMasimo ;

end

thIndex = floor( .8 * mn(1) ) ;
indexTrain = 1 : thIndex ;
indexTest  = thIndex + 1 : mn(1) ;

%% Deep Learning model

numFeatures = length( v ) ;
numHiddenUnits = 125;
numResponses = 1;

clear XTrain YTrain
for kf = 1 :thIndex
    
    XTrain{kf,1} = inputs(:,kf) ; 
    YTrain(kf,1) = targets(1,kf) ; 
end

rng(95)

% DL model
layers = [ ...
    sequenceInputLayer(numFeatures)
    lstmLayer(numHiddenUnits,'OutputMode','last')
    fullyConnectedLayer(numResponses)
    regressionLayer];

% options
maxEpochs = 100;
miniBatchSize = 30;

options = trainingOptions('adam', ...
    'ExecutionEnvironment','cpu', ...
    'MaxEpochs',maxEpochs, ...
    'MiniBatchSize',miniBatchSize, ...
    'GradientThreshold',1, ...
    'Verbose',false, ...
    'Plots','training-progress');

% Train the model with the specified training options.

net = trainNetwork(XTrain,YTrain,layers,options);

%% Predict values
clear XTest YTest
for kf =  thIndex + 1 : mn(1)
    
    XTest{kf-thIndex,1} = inputs(:,kf) ; 
    YTest(kf-thIndex,1)  = targets(1,kf) ; 
    
end

outN = predict(net,XTest) ;
difference = outN - YTest ;
error = sqrt( sum( ( outN - YTest ).^2 ) ) ;
meanError = mean( abs( difference ) ) ;
variError = var( abs( difference ) ) ;

disp('Test Deep learning model: ')
disp('Target:')
disp(YTest')
disp('Deep model:')
disp(outN')
disp('Diference:')
disp(difference')
disp(["Error: "+ meanError + " +- " + variError + " [g/dL]"])

% RMSE: 2.9723[g/dL] rng(1)
% RMSE: 1.4979[g/dL] rng(10) save it!

rmse_rng = zeros(1,100) ;

for k = 1 : 100

    rng( k )
    
    net   = trainNetwork( XTrain , YTrain , layers , options ) ;
    
    outN  = predict( net , XTest ) ;
    error = sqrt( sum( ( outN - YTest ).^2 ) ) ;

    rmse_rng( k ) = error ;
    
    disp(error)
    pause(1)
    
    close all force
    
end

% testoutlayers = [1 7 15] 
%% Predict values
clear XTest YTest
cont = 1 ;
for kf =  [1 7 15]
    
    XTest{cont,1}  = inputs(:,kf) ; 
    YTest(cont,1)  = targets(1,kf) ; 
    
    cont = cont + 1 ;
    
end

outN = predict(net,XTest) ;
difference = outN - YTest ;
error = sqrt( sum( ( outN - YTest ).^2 ) ) ;
meanError = mean( abs( difference ) ) ;
variError = var( abs( difference ) ) ;

disp('-- outliers --')
disp('Test Deep learning model: ')
disp('Target:')
disp(YTest')
disp('Deep model:')
disp(outN')
disp('Diference:')
disp(difference')
disp(["Error: "+ meanError + " +- " + variError + " [g/dL]"])

% disp(["RMSE: " + error + "[g/dL]"])


