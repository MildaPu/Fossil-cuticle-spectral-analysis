function [ SM ] = SimilarityMatrix( SampleNo,DistanceVector )
%Converts DistanceVector (output of pdist function) into symmetric
%similarity matrix

j = 1;
n = 1;
SM = zeros(SampleNo,SampleNo);
c = 0;
for i = 1:SampleNo
    j = j+1;
    c = c+1;
    SM(i,j:end) = DistanceVector(n:(n+SampleNo-j));
    n = n+SampleNo-c;
end
SM_temp = SM';
for i = 1:SampleNo
    for j = 1:SampleNo
        if i == j
            SM(i,j) = 0;
        else if SM(i,j) == 0
                SM(i,j) = SM_temp(i,j);
            end
        end
    end
end


end


