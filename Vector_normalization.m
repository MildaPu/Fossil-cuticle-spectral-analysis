function [Normalized] = Vector_normalization(Data)
%==============Vector normalization===================
[m,n] = size(Data);
Mean = mean(Data); Mean = Mean';
Mums = zeros(m,n);
Normalized = zeros(m,n);
Squares = zeros(1,n);
for j = 1:n
    Mums(1:m,j) = Data(1:m,j)-Mean(j);
    Squares(j) = sum(Mums(:,j).^2);
    Normalized(:,j) = Mums(:,j)/(Squares(j).^0.5);
end

end

