function shuffled_data = shuffle(data)
data = data';
length = size(data,2);
index = randperm(length);
shuffled_data = data(:,index);
shuffled_data = shuffled_data';
end

