P = [189; 149; 177; 158; 140; 192; 155; 165; 160;
    102; 134; 100; 174; 188; 102; 166; 135; 101];
W = [920; 1021; 1065; 1038; 1041; 1089; 1016; 1081; 920;
    1035; 977; 1039; 976; 979; 926; 1085; 931; 937];
restriction = 1e4;
initialTemp = 97;
coolRate = 0.99;
endTemp = 3;
maxIter = 1000;
nSwap = 18;

sumprice = 0;
sumweight = 0;
n = 50;
for i = 1 : n
    [price, weight, sol] = Packing_SA(P,W,restriction,initialTemp, ...
        endTemp,coolRate, maxIter, nSwap);
    sumprice = sumprice + price;
    sumweight = sumweight + weight;
end
fprintf("模拟退火法结果\n");
fprintf("总价格 = %f\n", sumprice/n);
fprintf("总重量 = %f\n", sumweight/n);

