% show_ppg2oxyHemo_clasicApproach
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

% data.oxyMatrix   %   = oxyMatrix ;
% data.oxyMasimo   % oxygen reference
% 
% data.hemoMatrix   %  = hemoMatrix ;
% data.hemoMasimo   % Hemoglobin reference

[rowO,colO,errorO] = minMatrix( data.oxyMatrix , data.oxyMasimo );
[rowH,colH,errorH] = minMatrix( data.hemoMatrix / 1e5, data.hemoMasimo );

errorOv(kf) = errorO ;
errorHv(kf) = errorH ;

rowHv(kf) = rowH *50 + 650 ; 
colHv(kf) = colH *50 + 650 ;

rowOv(kf) = rowO *50 + 650 ;
colOv(kf) = colO *50 + 650 ;
end

figure,
    subplot(121), plot(errorOv,'--*b'), title('Error Oxigen')
        xlabel('id sample')
        ylabel('| Oxigen_{Masimo} - Oxigen_{Computed} |')
    subplot(122), plot(errorHv,'--*r'), title('Error Hemoglobin')
        xlabel('id sample')
        ylabel('| Hemoglobin_{Masimo} - Hemoglobin_{Computed} |')


figure,
    subplot(121), 
        plot(rowOv,'--*b'), title('PPG O')
        hold on
        plot(colOv,'--sb'), 
        xlabel('id sample')
%         ylabel('| Oxigen_{Masimo} - Oxigen_{Computed} |')
    subplot(122),
        plot(colHv,'--*r'), title('PPG H')
        hold on
        plot(rowHv,'--sr'),
        xlabel('id sample')
%         ylabel('| Hemoglobin_{Masimo} - Hemoglobin_{Computed} |')        
        


function [row,col,error] = minMatrix( A , v)

[ a , b ] = min( abs( abs(A) - v ) ) ;
[ c , d ] = min( a ) ;

col = d ;
row = b(d) ;
error = c ;
A(row,col)
v
end