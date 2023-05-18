function TSPACO(cities, m, alpha, beta, rho, Q, iter_max)
%% 初始化参数
n = size(cities,2);
D = calculateDistance(cities);
Eta = 1./D;                  % 启发函数,距离越近的城市转移概率越高
Tau = ones(n,n);                     % 信息素矩阵
Table = zeros(m,n);                  % 路径记录表
best_route = zeros(iter_max,n);      % 各代最佳路径       
best_length = ones(iter_max,1)*inf;     % 各代最佳路径的长度  
gbest = inf;                         % 初始化最优距离
iter = 1; 

%% 迭代寻找最佳路径
 
while iter <= iter_max
    % 随机产生各个蚂蚁的起点城市
      start = zeros(m,1);
      for i = 1:m
          temp = randperm(n);
          start(i) = temp(1);
      end
      Table(:,1) = start; 
      citys_index = 1:n;
      % 逐个蚂蚁路径选择
      for i = 1:m
          % 逐个城市路径选择
         for j = 2:n
             tabu = Table(i,1:(j - 1));           % 已访问的城市集合(禁忌表)
             allow_index = ~ismember(citys_index,tabu);
             allow = citys_index(allow_index);  % 待访问的城市集合
             P = allow;
             % 计算城市间转移概率
             for k = 1:length(allow)
                 P(k) = Tau(tabu(end),allow(k))^alpha * Eta(tabu(end),allow(k))^beta;
             end
             P = P/sum(P);
             % 轮盘赌法选择下一个访问城市
             Pc = cumsum(P);
            target_index = find(Pc >= rand);
            target = allow(target_index(1));
            Table(i,j) = target;
         end
      end
      % 计算各个蚂蚁的路径距离
      Length = zeros(m,1);
      for i = 1:m
          Route = Table(i,:);
          for j = 1:(n - 1)
              Length(i) = Length(i) + D(Route(j),Route(j + 1));
          end
          Length(i) = Length(i) + D(Route(n),Route(1));
      end
      % 计算最短路径距离
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
      % 更新信息素
      Delta_Tau = zeros(n,n);
      % 逐个蚂蚁计算
      for i = 1:m
          % 逐个城市计算
          for j = 1:(n - 1)
              Delta_Tau(Table(i,j),Table(i,j+1)) = Delta_Tau(Table(i,j),Table(i,j+1)) + Q/Length(i);
          end
          Delta_Tau(Table(i,n),Table(i,1)) = Delta_Tau(Table(i,n),Table(i,1)) + Q/Length(i);
      end
      Tau = (1-rho) * Tau + Delta_Tau;
    % 清空路径记录表
    iter = iter + 1;
    Table = zeros(m,n);
    
    %% 结果显示
    [minLen,index] = min(best_length);
    minRoute = best_route(index,:);
    % 画出当前状态下的最短路径
    if minLen < gbest
        gbest = minLen;
        paint(cities, minRoute, minLen,iter);
    end
    
end

end