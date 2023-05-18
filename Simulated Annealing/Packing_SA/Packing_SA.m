function [price, weight, sol_best] = Packing_SA(P,W,restriction,initialTemp, endTemp,coolRate, maxIter, nSwap)
% P 价格 
% W 重量
% restriction 重量限制
num = nSwap;
P = -P;
sol_new = ones(1,num);          %生成初始解
E_current = inf;
E_best = inf;
%E_current是当前解对应的目标函数值（即背包中物品总价值）
%E_new是新解的目标函数值
%E_best是最优解
sol_current = sol_new;
sol_best = sol_new;
t = initialTemp;
tf = endTemp;
iterations = 1;

while t>tf
    while iterations < maxIter
        %产生随机扰动
        tmp = ceil(rand*num);
        sol_new(1,tmp) = ~sol_new(1,tmp);
        %检查是否满足约束
        while 1
            q = (sol_new * W <= restriction);
            if ~q
               %如果不满足约束随机放弃一个物品
                temp2=find(sol_new==1);
                temp3=ceil(rand*length(temp2));
                sol_new(temp2(temp3))=~sol_new(temp2(temp3));
            else
                break
            end
        end
        
        %计算背包中的物品价值
        E_new = sol_new * P;
        if E_new < E_current
            E_current = E_new;
            sol_current = sol_new;
            if E_new < E_best
                E_best = E_new;
                sol_best = sol_new;
            end
            iterations = iterations + 1;
        else
            if rand < exp( -(E_new - E_current) / t)
                E_current = E_new;
                sol_current = sol_new;
                iterations = iterations + 1;
            else
                sol_new = sol_current;
            end
        end
        t = t * coolRate;
        %{
    fprintf('迭代次数 = %d', iterations);
    disp('当前解为:');
    disp(sol_best)
    disp('物品总价值等于:');
    val = -E_best;
    disp(val);
    disp('背包中物品重量是:');
    disp(sol_best * W);
        %}
    end
end
weight = sol_best*W;
price = -E_best;
%disp(t);
end
