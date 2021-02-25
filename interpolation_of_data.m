function interpolation_of_data(filename)
  n = zeros(numel(filename),1);
  for i = 1:numel(filename)  
  [fid, ~] = fopen(filename{1, i});
    while true
        t = fgetl(fid);
        if ~ischar(t)
            break;
        else
            n(i) = n(i) + 1;
        end
    end
  for j = i+1:numel(filename)
        if n(j) ~= n(1)
            y = dlmread(filename{1});
            y1 = dlmread(filename{j});
            new_y = interp1(y1(:,1),y1(:,2),y(:,1),'spline','extrap');
            dlmwrite(filename{j},[y(:,1), new_y], 'delimiter' , '\t', 'precision', '%10.5f');        end
        end
    fclose(fid);
  end
  
 