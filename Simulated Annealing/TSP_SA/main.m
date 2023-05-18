Coord = [12, 18, 24, 29, 31, 36, 37, 42, 51, 62, 63, 69, 81, 82, 83, 88;
    12, 23, 21, 25, 52, 43, 14, 8, 47, 53, 19, 39, 7, 18, 40, 30];
initialTemp = 5000; % 初 温
coolRate = 0.95;
nSwap = 3;
maxIter = 2000;
TSP_SA(Coord, initialTemp, coolRate, maxIter, nSwap)