function gbest = PackingGA(Price, Weight, maxGEN, popSize, ...
    crossoverProbabilty, mutationProbabilty)
packNum = length(Price);
gbest = [-Inf,-Inf];

% 生成种群，每个个体代表一个解
pop = zeros(popSize,packNum);
for i = 1 : popSize
    pop(i,:) = randi([0,1],1,packNum);
end
offspring = zeros(popSize,packNum);
maxPriceGen = zeros(maxGEN,2); % 第一列为价格，第二列为对应的重量

% GA 算法
for gen = 1 : maxGEN
    % 计算适应度的值，即组合的总价格和总重量
    [fvar, sumWeight, sumPrice, minPrice, maxPrice, ...
    minWeight, maxWeight ] = PackingGA_fitness(Price, Weight, pop);

    newPopSize = length(sumWeight);

    %轮盘赌选择
    tournamentSize = 4;
    for k=1:newPopSize
        % 选择父代进行交叉
        tourPop = zeros(tournamentSize,2);
        for i=1:tournamentSize
            randomRow = randi(newPopSize);
            tourPop(i,1) = sumPrice(randomRow,1);
        end
        % 选择最好的，即价格最大的
        parent1  = max(tourPop);
        [parent1X,parent1Y] = find(sumPrice==parent1,1, 'first');
        parent1Combine = pop(parent1X(1,1),:);
 
        for i=1:tournamentSize
            randomRow = randi(newPopSize);
            tourPop(i,1) = sumPrice(randomRow,1);
        end
        parent2  = max(tourPop);
        [parent2X,parent2Y] = find(sumPrice==parent2,1, 'first');
        parent2Combine = pop(parent2X(1,1),:);
 
        subCombine = PackingGA_crossover(parent1Combine, ...
            parent2Combine, crossoverProbabilty);%交叉
        subCombine = PackingGA_mutate(subCombine, mutationProbabilty);%变异
 
        offspring(k,:) = subCombine(1,:);
        
        maxPriceGen(gen,1) = maxPrice; 
        maxPriceGen(gen,2) = maxWeight;
    end
    % 更新
    pop = offspring;
    % 画出当前状态下的最短路径
    if maxPriceGen(gen,1) > gbest(1)
        gbest(1) = maxPriceGen(gen,1);
        gbest(2) = maxPriceGen(gen,2);
    end
end