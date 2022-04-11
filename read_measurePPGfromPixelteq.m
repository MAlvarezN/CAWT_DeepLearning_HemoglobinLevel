% read_measurePPGfromPixelteq.m
% 
% read xlsx files in the "Data lab v2' folder to create a structure with
% dir command
%
% Michael Alvarez
% michael.alvarez2@upr.edu

close all force
clear
clc

filename = '.\..\..\Data Lab v2\ref_ppg\';
dir(filename)
A = dir(filename) ;

% filter xlsx: A = dir(filename,'*.xlsx')
mn = size( A ) ;
cont = 0 ; % count valid xlsx files
for k = 1 : mn(1)
    
    namefile = A(k).name ;
    if length(namefile) > 4
        
        if strcmp( namefile(end-3:end) , 'xlsx' )
            
            cont = cont + 1 ;
            xlsxfiles(cont,1) = A(k) ; % create a column structure 
            
        end
    end
end

disp(["There are " + cont + " xlsx files in the folder."])
disp(' Save structure with xlsx info')
save( 'xlsxfiles' , 'xlsxfiles')
disp( xlsxfiles )