function [price, weight, sol_best] = Packing_SA(P,W,restriction,initialTemp, endTemp,coolRate, maxIter, nSwap)
% P �۸� 
% W ����
% restriction ��������
num = nSwap;
P = -P;
sol_new = ones(1,num);          %���ɳ�ʼ��
E_current = inf;
E_best = inf;
%E_current�ǵ�ǰ���Ӧ��Ŀ�꺯��ֵ������������Ʒ�ܼ�ֵ��
%E_new���½��Ŀ�꺯��ֵ
%E_best�����Ž�
sol_current = sol_new;
sol_best = sol_new;
t = initialTemp;
tf = endTemp;
iterations = 1;

while t>tf
    while iterations < maxIter
        %��������Ŷ�
        tmp = ceil(rand*num);
        sol_new(1,tmp) = ~sol_new(1,tmp);
        %����Ƿ�����Լ��
        while 1
            q = (sol_new * W <= restriction);
            if ~q
               %���������Լ���������һ����Ʒ
                temp2=find(sol_new==1);
                temp3=ceil(rand*length(temp2));
                sol_new(temp2(temp3))=~sol_new(temp2(temp3));
            else
                break
            end
        end
        
        %���㱳���е���Ʒ��ֵ
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
    fprintf('�������� = %d', iterations);
    disp('��ǰ��Ϊ:');
    disp(sol_best)
    disp('��Ʒ�ܼ�ֵ����:');
    val = -E_best;
    disp(val);
    disp('��������Ʒ������:');
    disp(sol_best * W);
        %}
    end
end
weight = sol_best*W;
price = -E_best;
%disp(t);
end
