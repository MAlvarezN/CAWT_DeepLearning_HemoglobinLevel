% neural_calibration_v1
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

treshold = floor( .8 * mn(1) ) ;
indexTrain = 1 : treshold ;
indexTest  = treshold + 1 : mn(1) ;

net = feedforwardnet(5);
[net,tr] = train(net,inputs(:,indexTrain),targets(1,indexTrain))


outN = net(inputs(:,indexTest))
outT = targets(1,indexTest)
outN - outT
error = sqrt( sum( (outN - outT).^2 ) )

testoutlayers = [1 7 15] 
outN = net(inputs(:,testoutlayers))
outT = targets(1,testoutlayers)
outN - outT
error = sqrt( sum( ( outN - outT).^2 ) )