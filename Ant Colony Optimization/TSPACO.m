function TSPACO(cities, m, alpha, beta, rho, Q, iter_max)
%% ��ʼ������
n = size(cities,2);
D = calculateDistance(cities);
Eta = 1./D;                  % ��������,����Խ���ĳ���ת�Ƹ���Խ��
Tau = ones(n,n);                     % ��Ϣ�ؾ���
Table = zeros(m,n);                  % ·����¼��
best_route = zeros(iter_max,n);      % �������·��       
best_length = ones(iter_max,1)*inf;     % �������·���ĳ���  
gbest = inf;                         % ��ʼ�����ž���
iter = 1; 

%% ����Ѱ�����·��
 
while iter <= iter_max
    % ��������������ϵ�������
      start = zeros(m,1);
      for i = 1:m
          temp = randperm(n);
          start(i) = temp(1);
      end
      Table(:,1) = start; 
      citys_index = 1:n;
      % �������·��ѡ��
      for i = 1:m
          % �������·��ѡ��
         for j = 2:n
             tabu = Table(i,1:(j - 1));           % �ѷ��ʵĳ��м���(���ɱ�)
             allow_index = ~ismember(citys_index,tabu);
             allow = citys_index(allow_index);  % �����ʵĳ��м���
             P = allow;
             % ������м�ת�Ƹ���
             for k = 1:length(allow)
                 P(k) = Tau(tabu(end),allow(k))^alpha * Eta(tabu(end),allow(k))^beta;
             end
             P = P/sum(P);
             % ���̶ķ�ѡ����һ�����ʳ���
             Pc = cumsum(P);
            target_index = find(Pc >= rand);
            target = allow(target_index(1));
            Table(i,j) = target;
         end
      end
      % ����������ϵ�·������
      Length = zeros(m,1);
      for i = 1:m
          Route = Table(i,:);
          for j = 1:(n - 1)
              Length(i) = Length(i) + D(Route(j),Route(j + 1));
          end
          Length(i) = Length(i) + D(Route(n),Route(1));
      end
      % �������·������
      if iter == 1
          [min_Length,min_index] = min(Length);
          best_length(iter) = min_Length;  
          best_route(iter,:) = Table(min_index,:);
      else
          [min_Length,min_index] = min(Length);
          best_length(iter) = min(best_length(iter - 1),min_Length);
          if best_length(iter) == min_Length
              best_route(iter,:) = Table(min_index,:);
          else
              best_route(iter,:) = best_route((iter-1),:);
          end
      end
      % ������Ϣ��
      Delta_Tau = zeros(n,n);
      % ������ϼ���
      for i = 1:m
          % ������м���
          for j = 1:(n - 1)
              Delta_Tau(Table(i,j),Table(i,j+1)) = Delta_Tau(Table(i,j),Table(i,j+1)) + Q/Length(i);
          end
          Delta_Tau(Table(i,n),Table(i,1)) = Delta_Tau(Table(i,n),Table(i,1)) + Q/Length(i);
      end
      Tau = (1-rho) * Tau + Delta_Tau;
    % ���·����¼��
    iter = iter + 1;
    Table = zeros(m,n);
    
    %% �����ʾ
    [minLen,index] = min(best_length);
    minRoute = best_route(index,:);
    % ������ǰ״̬�µ����·��
    if minLen < gbest
        gbest = minLen;
        paint(cities, minRoute, minLen,iter);
    end
    
end

end