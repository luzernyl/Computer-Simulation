Price = [189; 149; 177; 158; 140; 192; 155; 165; 160;
    102; 134; 100; 174; 188; 102; 166; 135; 101];
Weight = [920; 1021; 1065; 1038; 1041; 1089; 1016; 1081; 920;
    1035; 977; 1039; 976; 979; 926; 1085; 931; 937];
popSize = 100;
maxGEN = 1000;
crossoverProb = 0.9;
mutationProb = 0.1;
sumprice = 0;
sumweight = 0;
n = 50;
for i = 1 :n
    gbest = PackingGA(Price, Weight, maxGEN, popSize, ...
        crossoverProb, mutationProb);
    sumprice = sumprice + gbest(1);
    sumweight = sumweight + gbest(2);
end
fprintf("遗传算法结果\n");
fprintf("价格 = %f\n",sumprice/n);
fprintf("重量 = %f\n",sumweight/n);