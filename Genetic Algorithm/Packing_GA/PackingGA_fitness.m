function [ fitnessvar, sumWeight, sumPrice, minPrice, maxPrice, ...
    minWeight, maxWeight ] = PackingGA_fitness(Price, Weight, pop )
% 计算整个种群的适应度值
    [popSize, col] = size(pop);
    sumPrice = [];
    sumWeight = [];
    fitnessvar = zeros(popSize,2);
    
    for i=1:popSize
        p = 0;
        w = 0;
       for j=1:col
          p = p + pop(i,j)*Price(j);
          w = w + pop(i,j)*Weight(j);
       end 
       if(w <= 1e4)
           sumPrice(end+1,:) = p;
           sumWeight(end+1,:) = w;
       end
    end
    
    minPrice = min(sumPrice);
    maxPrice = max(sumPrice);
    minWeight = min(sumWeight);
    maxWeight = max(sumWeight);
    fitnessvar = zeros(length(sumPrice),2);
    for i=1:length(sumPrice)
        pricefitness = (maxPrice - sumPrice(i,1)+0.000001) ...
            / (maxPrice-minPrice+0.00000001);
        weightfitness = (maxWeight - sumWeight(i,1) + 0.000001) ...
            / (maxWeight-minWeight+0.00000001);
        fitnessvar(i,1)= pricefitness;
        fitnessvar(i,2) = weightfitness;
    end
end