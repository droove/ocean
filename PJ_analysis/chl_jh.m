function [chl] = chl_jh(a630,a647,a664,a750,acetonV,filtV)

% % From Jeffrey and Humphrey(1975) formular
% Jeffrey, SW t, & Humphrey, GF. (1975). New spectrophotometric equations for determining chlorophylls a, b, c1 and c2 in higher plants, algae and natural phytoplankton. Biochem. Physiol. Pflanz, 167(19), 1-194. 

% chl=chlorophyll concentration (mg m^-3)
% a630= absorbance at 630 nm
% a647= absorbance at 647 nm
% a664= absorbance at 664 nm
% acetonV= aceton Volume (ml)
% filtV= filtering sea water Volume (ml)
a=0.08;
b=1.54;
c=11.85;
aa664=a664-a750;
aa647=a647-a750;
aa630=a630-a750;

aa664(find(aa664<0))=0;
aa647(find(aa647<0))=0;
aa630(find(aa630<0))=0;

chl= ( ( (c*aa664)-(b*aa647)-(a*aa630) )*acetonV )/ filtV*1000;
chl( find(chl<0) )=0;




