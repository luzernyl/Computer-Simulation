Total_time = 18;  %总迭代时间
lambda = 1000; mu = 360*4;%到达率与服务率
arr_mean = 1 / lambda;   ser_mean = 1 / mu;  %平均到达时间与平均服务时间
%可能到达的最大顾客数（round：四舍五入求整数）
arr_num= round(Total_time*lambda*2);
guests = zeros(5,arr_num);%定义顾客信息的数组
%按指数分布产生各顾客到达的时间间隔
guests(1,:) = exprnd(arr_mean,1,arr_num);
%各顾客的到达时刻等于时间间隔的累计和
guests(1,:) = cumsum(guests(1,:));
%按指数分布产生各顾客服务时间
guests(2,:) = exprnd(ser_mean,1,arr_num);
%计算模拟的顾客个数，即到达时刻在模拟时间内的顾客数
len_sim = sum(guests(1,:) <= Total_time);
%***********************************
%初始化第1个顾客的信息
%***********************************
guests(3,1)=0;%第1个顾客进入系统后直接接受服务，无需等待
%其离开时刻等于其到达时刻与服务时刻之和
guests(4,1)=guests(1,1)+guests(2,1);
guests(5,1)=0;%此时系统内没有其他顾客，故附加信息为0
member=[1];%其进入系统后，系统内已有成员序号为1
%************************************
%计算第i个顾客的信息
%************************************
for i=2:arr_num
    %如果第i个顾客的到达时间超过了迭代时间，则跳出循环
    if guests(1,i)>Total_time
        break;
    else
        %如果第i个顾客的到达时间在迭代时间内，则计算在其到达时刻系统中已有的顾客数
        number=sum(guests(4,member)>guests(1,i));
        if number==0
            %如果系统为空，则第i个顾客直接接受服务，其等待时间为0
            guests(3,i)=0;
            %其离开时刻等于到达时刻与服务时刻之和
            guests(4,i)=guests(1,i)+guests(2,i);
            guests(5,i)=0;   %其附加信息是0
            member=[member,i];
        else
            %如果系统有顾客正在接受服务，且系统等待队列未满，则第i个顾客进入系统
            len_mem=length(member);
            %其等待时间等于队列中前一个顾客的离开时刻减去其到达时刻
            guests(3,i)=guests(4,member(len_mem))-guests(1,i);
            %其离开时刻等于队列中前一个顾客的离开时刻加上其服务时间
            guests(4,i)=guests(4,member(len_mem))+guests(2,i);
            %附加信息表示其进入系统时在他之前系统已有的顾客数
            guests(5,i)=number;
            member=[member,i];
        end
    end
end
len_mem=length(member);%模拟结束时，进入系统的总顾客数
avgtime = mean(guests(4,1:length(member))-guests(1,1:length(member)))*3600;
fprintf("平均时间 = %f 秒\n", avgtime);