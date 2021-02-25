function [ Derivative ] = First_Derivative(Data, order, order1)
%============Savitzky-Golay derivative and smoothing============
[r, c] = size(Data);
[~, g] = sgolay(2,order1);
Derivative = zeros(r,c);
for i = 1:c
  Derivative(:,i) = conv(Data(:,i), factorial(order)/(-2)^1 * g(:,order+1), 'same');
end

end

