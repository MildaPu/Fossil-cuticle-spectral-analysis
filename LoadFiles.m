function [Raw_Data, labels, Wavenumbers] = LoadFiles(fileNames, extension, order, order1)

%% 
%===========Load spectral files, put them into one matrix==============
if ischar(fileNames)
    fileNames = {fileNames};
end

%% Uncomment the following section if interpolation of data is necessary

for j = 1:numel(fileNames)
    Spectrum = dlmread(fileNames{j});
    Spectrum_der = First_Derivative(Spectrum(:,2), order, order1);
    dlmwrite(fileNames{j},[Spectrum(:,1), Spectrum_der], 'delimiter' , '\t', 'precision', '%10.5f');
end
    
interpolation_of_data(fileNames);

%%
data = cell(numel(fileNames),1);
for ii = 1:numel(fileNames)    
   data{ii,1} = dlmread(fileNames{ii});
end
DataSet = vertcat(data{:});
DataPoints = size(DataSet,1)/numel(fileNames);
Wavenumbers = DataSet(1:DataPoints,1);
Raw_Data = reshape(DataSet(:,2), DataPoints, numel(fileNames));
% [m,n] = size(Raw_Data);

%% 
% =============Label the data===================
% Uncomment the following line if the whole file name is to be used as label
% labels = regexprep(fileNames,extension,'');

% 6 first characters of the file name is used as label
labels = cell(numel(fileNames),1);
for i = 1:numel(fileNames)
    labels{i} = extractBefore(fileNames{i},6);
end


end