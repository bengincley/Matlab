clear all;
name = 'optical_raw_data';
[num,raw,raw2] = xlsread(name,'CG1048:CG1052'); % read in values
raw=replace(raw,'{',''); raw=replace(raw,'}',''); raw=replace(raw,'|',''); raw=replace(raw,';',' '); % remove problematic symbols
rawAPI=str2mat(raw); rawAPI=str2num(rawAPI); % convert to matrix

for n=1:size(rawAPI,1)
    figure(n)
    plot(1:length(rawAPI(n,:)),rawAPI(n,:))
end
