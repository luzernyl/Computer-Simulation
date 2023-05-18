function TSP_SA(cityXY, initialTemp, coolRate, maxIter, nSwap)
% �������������������������Ž�
% ��������ǣ�
% cityXY: n�����������2*n����
% initialTemp: ģ���˻�ĳ�ʼ�¶�
% coolRate: ������ȴ����ȴ�ʣ�����С��1
% maxIter:��������������
% nSwap:ָ����ת�ĳ�����
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
    fprintf('�������� = %d\n', iterations);
    fprintf('�����¶� = %3.8f\n', temp);
end

        
