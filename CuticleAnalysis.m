%% This script was written by Milda Pucetaite, Dept. of Biology, Lund University (2020)
% The script was used to analyze infrared spectroscopy data of gymnosperm fossil cuticles
% The script performs hierarchical cluster analysis (HCA) and principal component analysis (PCA)
% of derivative (optional), vector-normalized data. 

%%
clear; close all; clc;

%% Load spectral files, set parameters for pre-processing
fprintf('Please select the files\n');
[fileNames, FullPath,~] = uigetfile('MultiSelect','on');
fprintf('You have selected %d files\n',numel(fileNames));
order = input('Please, enter the order of the derivative');
order1 = input('Please, enter the smoothing window (odd number)');
% Interpolation has to be performed within LoadFiles if resolution/data
% point number is not consistent. In this case, Savitzky-Golay derivative
% is calculated within LoadFiles function (needs to be uncommented)
% If interpolation is performd, the data is saved into the same file
% Part of filename that will be used to label data can be chosen within
% LoadFiles function
[Data, labels, Wavenumbers] = LoadFiles(fileNames,'.dpt', order, order1);
%the .dpt extension can be changed to .txt

%% Select spectral region of interest for analysis
a = 1300; %select lower wavenuber limit
b = 1850; %select higher wavenumber limit

resolution = Wavenumbers(1)-Wavenumbers(2);
low_wavenumber_limit = find(Wavenumbers(:,1) >= a&Wavenumbers(:,1) <= a+resolution);
high_wavenumber_limit = find(Wavenumbers(:,1) >= b&Wavenumbers(:,1) <= b+resolution);
Truncated_Data = Data(high_wavenumber_limit:low_wavenumber_limit,:);
Truncated_Wavenumbers = Wavenumbers(high_wavenumber_limit:low_wavenumber_limit,:);

%% Savitzky-Golay derivative and smoothing 
% If interpolation is not performed under LoadFiles, the derivative can be
% calculated here (uncomment)
% [Truncated_Data] = First_Derivative(Truncated_Data, order, order1);

%% Vector normalization
[Preprocessed_Data] = Vector_normalization(Truncated_Data);

%% Perform HCA on the pre-processed data
D = pdist(Preprocessed_Data');
HCA = linkage(Preprocessed_Data','ward');
leafOrder = optimalleaforder(HCA,D);
figure
H = dendrogram(HCA,0,'labels',labels,'Orientation','left','reorder', leafOrder, 'ColorThreshold', 1.2);
box on
xlabel('Euclidean distance')
set(H,'LineWidth',2)

% Verification
c=cophenet(HCA,D);
I=inconsistent(HCA);


%% Heat-maps
hm = clustergram(Preprocessed_Data', 'linkage', 'ward', 'RowLabels', labels, 'ColumnLabels', Truncated_Wavenumbers, 'Colormap', redbluecmap, 'OptimalLeafOrder',leafOrder,'Cluster',1,'Dendrogram',5);

%% Reconstruct similarity matrix (if necessary)
% SM = SimilarityMatrix(size(Data,2),D);
% dlmwrite('Similarity_Matrix_AllFoss.txt',SM,'delimiter','\t');
 
%% Perform PCA 
[Coeff,PCs,Latent] = pca(Preprocessed_Data'); 

% Uncomment mapcaplot for interactive inspection of PCs
% mapcaplot(PCs,labels); 
figure
gscatter(PCs(:,1),PCs(:,2),labels,'','.',30);
box on
xlabel('PC1');
ylabel('PC2');
legend('location','Southeast');
text(PCs(:,1),PCs(:,2),labels);

% figure
% biplot(Coeff(:,1:2),'scores',PCs(:,1:2), 'varlabels', num2str(Truncated_Wavenumbers))

figure
gscatter(PCs(:,1),PCs(:,3),labels,'','.',30);
box on
xlabel('PC1');
ylabel('PC3');
legend('location','Southeast');
text(PCs(:,1),PCs(:,3),labels);

% Plot the PC loadings
figure
plot(Truncated_Wavenumbers, Coeff(:,1:3))
