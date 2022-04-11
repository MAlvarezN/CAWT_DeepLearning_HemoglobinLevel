% main_ppgSim_multipleFiles.m
% 
% load xlsxfiles.mat to read multiple xlsx files in the "Data lab v2'
% folder to create a separate 
%  .mat with parameter of TwoGaussian aproximation: para and ppg_temp
% 
% para
%       disp(' Generated coefficients: ')
%       thetai = [para(2) para(5)]
%       ai = [para(1) para(4)]
%       bi = [para(3) para(6)]
%
% ppg_temp
%       ppg_temp.val = template ;
%       ppg_temp.max = maxTemplate ;
%       ppg_temp.min = minTemplate ;
%       ppg_temp.rang = maxTemplate - minTemplate ;
% 
% 
% Michael Alvarez
% michael.alvarez2@upr.edu


close all force
clear
clc

addpath(genpath('.\..\..\Codes\TwoGaussian\'))


filepath = '.\..\..\Data Lab v2\ref_ppg\';
% filename = '20220303-10000008.xlsx' ;
load('xlsxfiles')

rng(1) % control random numbers

opt.fs = 120 ;
opt.N = 20 ;

mn = size( xlsxfiles ) ;
for kf = 6 : mn(1)
    
    filename = xlsxfiles(kf).name ; 
    T = readmatrix( strcat(filepath , filename) ) ;

    clear para ppg_temp
    disp(["Processing: " + filename])
    filemat = strcat( filename(1:end-4) , 'mat') ;
    if exist( filemat ,'file') > 0
        disp(" ")
        disp(" Found record .mat")
        disp(" ")
    else

        for k = 4 : 10 % base on xlsx file
            % 4 == 700 nm
            % 5 == 750 nm
            % 6 == 800 nm
            % 7 == 850 nm
            % 8 == 900 nm
            % 9 == 950 nm
            % 10 == 1000 nm
            opt.wavl = (k-3)*50 + 650 ;

            ppg = T(:,k) ;
            [ para{k-3} , ppg_temp{k-3} ] = ppgSimTwoGaussian( ppg , opt ) ;

        end
        disp(" ")
        disp(' Save .mat')
        disp(" ")        
        save(filemat,'para','ppg_temp')
        
    end

end
