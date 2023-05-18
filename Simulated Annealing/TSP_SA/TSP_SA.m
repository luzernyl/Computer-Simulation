function TSP_SA(cityXY, initialTemp, coolRate, maxIter, nSwap)
% 这个函数返回旅行商问题的最优解
% 输入变量是：
% cityXY: n个城市坐标的2*n矩阵
% initialTemp: 模拟退火的初始温度
% coolRate: 几何冷却的冷却率，必须小于1
% maxIter:设置最大迭代次数
% nSwap:指定逆转的城市数
global iterations;
temp = initialTemp;
% initial_cities_to_swap = nSwap;
iterations = 1;
final_temp_iterations = 0;
while iterations < maxIter
    previous_distance = distance(cityXY);
    pos_cities = swapcities(cityXY, nSwap);
    current_distance = distance(pos_cities);
    diff = abs(current_distance - previous_distance);
    if current_distance < previous_distance
        cityXY = pos_cities;
        plotcities(cityXY);
        if final_temp_iterations >= 10
            temp = coolRate*temp;
            final_temp_iterations = 0;
        end
        nSwap = round(nSwap*exp(-diff/(iterations*temp)));
        if nSwap == 0
            nSwap = 1;
        end
        iterations = iterations + 1;
        final_temp_iterations = final_temp_iterations + 1;
    else
        if rand(1) < exp(-diff/temp)
            cityXY = pos_cities;
            plotcities(cityXY);
            nSwap = round(nSwap * exp(-diff/(iterations*temp)));
            if nSwap == 0
                nSwap = 1;
            end
            final_temp_iterations = final_temp_iterations + 1;
            iterations = iterations + 1;
        end
    end
    clc
    fprintf('迭代次数 = %d\n', iterations);
    fprintf('最终温度 = %3.8f\n', temp);
end

        
