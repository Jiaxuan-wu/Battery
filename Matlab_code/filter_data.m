function filtered_data = filter_data(data, i, j)

index = find((data(:,1)>=i) & (data(:,1)<=j));
filtered_data = data(index,:);

end

