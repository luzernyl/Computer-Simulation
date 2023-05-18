function s = swapcities(cityXY, m)
% 这个函数执行部分路径逆转操作
% cityXY为城市的坐标
% m为被逆转的城市数
s = cityXY;
%{
for i = 1 : m
    city_1 = round(length(cityXY)*rand(1));
    if city_1 < 1
        city_1 = 1;
    end
    city_2 = round(length(cityXY)*rand(1));
    if city_2 < 1
        city_2 = 1;
    end
    temp = s(:, city_1);
    s(:,city_1) = s(:,city_2);
    s(:,city_2) = temp;
end 
%}
for i = 1 : m
    city_1 = round(length(cityXY)*rand(1));
    if city_1 < 1
        city_1 = 1;
    end
    city_2 = round(length(cityXY)*rand(1));
    if city_2 < 1
        city_2 = 1;
    end
    temp = s(:, city_1);
    s(:,city_1) = s(:,city_2);
    s(:,city_2) = temp;
    
    % 逆转 city_1 到 city_2 的路径
    max_city = max(city_1, city_2);
    min_city = min(city_1, city_2);
    diff = max_city - min_city;
    for i = 1 : floor((diff-1)/2)
        min_city = min_city + 1;
        max_city = max_city - 1;
        temp = s(:, min_city);
        s(:,min_city) = s(:,max_city);
        s(:,max_city) = temp;
    end
end 
