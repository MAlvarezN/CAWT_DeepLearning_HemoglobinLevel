% main_ppg2oxyHemo_multipleFile.m
% 
% load .mat with parameter of TwoGaussian aproximation: para and ppg_temp
%
% Michael Alvarez
% michael.alvarez2@upr.edu

close all force
clear
clc

addpath(genpath('.\..\..\Codes\TwoGaussian\'))


filepath = '.\..\..\Data Lab v2\ref_ppg\';

filepathsave = '.\oxyHemo_clasicApproach\' ;
mkdir( filepathsave )

% filename = '20220303-10000008.xlsx' ;
load( 'xlsxfiles' )

dataMasimo = readmatrix('.\..\..\Data Lab v2\dataset_Masimo_R7.xlsx');

rng(1)

mn = size( xlsxfiles ) ;

listErrors = zeros( 1 , mn(1) ) ; 

avWavel = 7 ; % available wavelengs

for kf = 1 : mn(1)
    
    filename = xlsxfiles(kf).name ;    
    filemat = strcat( filename(1:end-4) , 'mat') ;
    
    load( filemat )
    
    oxyMatrix  = zeros( avWavel , avWavel - 1 ) ;
    hemoMatrix = zeros( avWavel , avWavel - 1 ) ;
    oxyMatrixNorm  = zeros( avWavel , avWavel - 1 ) ;
    hemoMatrixNorm = zeros( avWavel , avWavel - 1 ) ;


%     ppgs{1,1} = ppg_temp{1,1} ;
%     ppgs{1,2} = ppg_temp{1,2} ;
% 
%     opt(1) = 700 ;
%     opt(2) = 750 ;
% 
%     [oxy,hemo] = ppg2oxyHemo(ppgs,opt)

    for j = 1 : avWavel % base on xlsx file
        for i = j + 1 : avWavel

            ppgs{1,1} = ppg_temp{1,j} ;
            ppgs{1,2} = ppg_temp{1,i} ;

            opt(1) = (j)*50 + 650 ;
            opt(2) = (i)*50 + 650 ;
            
            try
                [oxy,hemo] = ppg2oxyHemo(ppgs,opt)
            catch
                oxy = 0 ; hemo = [0 0] ;
                disp('mmm... at least one PPG without data...')
                listErrors(kf) = 1 ;
            end

            oxyMatrix(i,j)  = oxy ;
            hemoMatrix(i,j) = hemo(1)+hemo(2) ;

        end        
    end


    % normalization for an inividual
    trynorm = 1 ;
    try
        for k = 1 : avWavel
        
            vecMax(k) = ppg_temp{1,k}.max ;
            vecMin(k) = ppg_temp{1,k}.min ;
        end
    catch
        trynorm = 0 ;
    end
    
    if trynorm == 1 
        
        vmax = max(vecMax)  ;
        vmin = min(vecMin)  ;
        for k = 1 : avWavel
            ppg_temp{1,k}.maxn = (ppg_temp{1,k}.max - vmin) / (vmax - vmin) ;
            ppg_temp{1,k}.minn = (ppg_temp{1,k}.min - vmin) / (vmax - vmin) ;
        end

        opt(3) = 1 ;
        for j = 1 : avWavel - 1 % base on xlsx file
            for i = j + 1 : avWavel

                ppgs{1,1} = ppg_temp{1,j} ;
                ppgs{1,2} = ppg_temp{1,i} ;

                opt(1) = (j)*50 + 650 ;
                opt(2) = (i)*50 + 650 ;

                try
                    [oxy,hemo] = ppg2oxyHemo(ppgs,opt)
                catch
                    oxy = 0 ; hemo = [0 0] ;
                    disp('mmm... at least one PPG without data...')
                end

                oxyMatrixNorm(i,j)  = oxy ;
                hemoMatrixNorm(i,j) = hemo(1)+hemo(2) ;

            end   

        end
    end
    
    
    disp(" ")
    disp(' Save data Oxygen Hemoglobin ... ')
    disp(" ")  
    
    data.oxyMatrix      = oxyMatrix ;
    data.hemoMatrix     = hemoMatrix ;
    data.oxyMatrixNorm  = oxyMatrixNorm ;
    data.hemoMatrixNorm = hemoMatrixNorm ;
    
    data.oxyMasimo  = dataMasimo(kf,3) ; % oxygen reference
    data.hemoMasimo = dataMasimo(kf,4) ; % Hemoglobin reference
    
    save( strcat( filepathsave , filemat(1:end-4) , "_OxyHemo") , 'data' )
end

disp(" ")
disp(' Save list errors ... ')
disp(listErrors) 
save( strcat( filepathsave , "listErrors") , 'listErrors' )



