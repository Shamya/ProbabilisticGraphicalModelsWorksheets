clear all; close all;

%P(BN) = P(G,A,BP,CH,HD,CP,EIA,ECG,HR)
%= P (G)P (A)P (BP |G)P (CH|G, A)P (HD|BP, CH)P (CP |HD)P (EIA|HD)P (ECG|HD) P(HR|HD,A)

%calculate the CPTs for all the random variables in this bayesian network. 
%This is used to pick the necessary values to substitute in the above equations. 
%The maximum likelihood estimate for all the parameters are listed in these CPTs too.

%read first training data into a matrix for parameter learning
M = csvread('data-train-1.txt');
% P(G)
%the random variable G corresponds to the second column of the matrix and
%can take 2 possible values

x = find(M(:,2)==1);
y = find(M(:,2)==2);

total = size(x,1) +size(y,1) ;
if (total ~= 243)
    disp('P(G): sum to one mismatch at count');
end

PG = zeros(2,1);
PG(1) = size(x,1)/243;
PG(2) = size(y,1)/243;

total = sum(PG);
if (total ~= 1)
    disp('P(G): sum to one mismatch at parameter value');
end

disp('P(G)');
disp('1-2');
disp(PG);

% P(A)
%the random variable A corresponds to the first column of the matrix and
%can take 3 possible values
x = find(M(:,1)==1);
y = find(M(:,1)==2);
z = find(M(:,1)==3);

total = size(x,1) +size(y,1) + size(z,1);
if (total ~= 243)
    disp('P(A): sum to one mismatch at count');
end

PA = zeros(3,1);
PA(1) = size(x,1)/243;
PA(2) = size(y,1)/243;
PA(3) = size(z,1)/243;

total = sum(PA);
if (total ~= 1)
    disp('P(A): sum to one mismatch at parameter value');
end

disp('P(A)');
disp('1-2-3');
disp(PA);

%P(BP|G)
%the random variable BP corresponds to the fourth column of the matrix and
%can take 2 possible values and its parent G corresponds to second column and can
%take 2 values
count11 = 0;
count12 = 0;
count21 = 0;
count22 = 0;

x = find(M(:,4)==1);
sz = size(x,1);

for i = 1 : sz
    if(M(x(i),2) == 1)
        count11 = count11 + 1;
    else 
        count12 = count12 + 1;
    end
end

y = find(M(:,4)==2);
sz = size(y,1);
for i = 1 : sz
    if(M(y(i),2) == 1)
        count21 = count21 + 1;
    else 
        count22 = count22 + 1;
    end
end

total = count11 + count12 + count21 + count22;
if (total ~= 243)
    disp('P(B): sum to total mismatch at count');
end

w = find(M(:,2)==1);
w1 = size(w,1);
w = find(M(:,2)==2);
w2 = size(w,1);

PB = zeros(4,1);
PB(1) = count11/w1;
PB(2) = count21/w1;
PB(3) = count12/w2;
PB(4) = count22/w2;

total = sum(PB);
if (total ~= 2)
    disp('P(B): sum to one mismatch at parameter value');
end

disp('P(BP|G)');
disp('BP - G');
disp('11-21-12-22');
disp(PB);

%P?(HD|BP, CH) 
%the random variable HD corresponds to the ninth column of the matrix and
%can take 2 possible values and its parent BP and CH corresponds to fourth and fifth columns 
%and can take 2 values each

countFnd = zeros(8,1);
cnt = 1;
for i = 1:2
    for j = 1:2
        for k = 1:2
            fnd = size(find(M(:,9)==k & M(:,4)==j & M(:,5)==i),1);
            countFnd(cnt) = fnd;
            cnt = cnt +1;
        end
    end
end

countParent = zeros(4,1);
cnt = 1;
%find count of the parent occurences
for i = 1:2
    for j = 1:2
            fnd = size(find(M(:,4)==j & M(:,5)==i),1);
            countParent(cnt) = fnd;
            cnt = cnt +1;
    end
end

total = sum(countFnd);
if (total ~= 243)
    disp('P(C): sum to one mismatch at count');
end

PC = zeros(8,1);
PC(1) = countFnd(1)/countParent(1);
PC(2) = countFnd(2)/countParent(1);
for i = 2:4
    PC(i+(i-1)) = countFnd(i+(i-1))/countParent(i);
    PC(i*2) = countFnd(i*2)/countParent(i);
end 


total = sum(PC);
if (total ~= 4)
    disp('P(C): sum to one mismatch at parameter value');
end

disp('P(HD|BP, CH)');
disp('CH-BP-HD');
dispMat = zeros(8,3);
cnt = 1;
for i = 1:2
    for j = 1:2
        for k = 1:2
            dispMat(cnt,:) = [i, j, k];
            cnt = cnt +1;
        end
    end
end
disp(dispMat);
disp(PC);

%P(HR|A, HD)
%the random variable HR corresponds to the seventh column of the matrix and
%can take 2 possible values and its parent A and HD corresponds to first and ninth columns 
%and can take 3 values and 2 values each

countFnd = zeros(12,1);
cnt = 1;
%second method - using find to verify the results
for i = 1:2
    for j = 1:3
        for k = 1:2
            fnd = size(find(M(:,9)==i & M(:,1)==j & M(:,7)==k),1);
            countFnd(cnt) = fnd;
            cnt = cnt +1;
        end
    end
end

countParent = zeros(6,1);
cnt = 1;
%find count of the parent occurences
for i = 1:2
    for j = 1:3
            fnd = size(find(M(:,9)==i & M(:,1)==j),1);
            countParent(cnt) = fnd;
            cnt = cnt +1;
    end
end

total = sum(countFnd);
if (total ~= 243)
    disp('P(D): sum to one mismatch at count');
end


PD = zeros(12,1);
PD(1) = countFnd(1)/countParent(1);
PD(2) = countFnd(2)/countParent(1);
for i = 2:6
    PD(i+(i-1)) = countFnd(i+(i-1))/countParent(i);
    PD(i*2) = countFnd(i*2)/countParent(i);
end 

total = sum(PD);
if (total ~= 6)
    disp('P(D): sum to one mismatch at parameter value');
end

% only for HR = low
PDdisp = zeros(6,1);
PDdisp(1) = PD(1);
for i = 2:6
    PDdisp(i) = PD(i+(i-1));
end

disp('P(HR|A, HD)');
disp('HD-A-HR');
dispMat = zeros(12,3);
cnt = 1;
for i = 1:2
    for j = 1:3
        for k = 1:2
            dispMat(cnt,:) = [i, j, k];
            cnt = cnt +1;
        end
    end
end
disp(dispMat);
disp(PD);

%P (CH|G, A)
%the random variable CH corresponds to the fifth column of the matrix and
%can take 2 possible values and its parent G and A corresponds to second and first columns 
%and can take 2 values and 3 values each

countFnd = zeros(12,1);
cnt = 1;
%second method - using find to verify the results
for i = 1:3
    for j = 1:2
        for k = 1:2
            fnd = size(find(M(:,1)==i & M(:,2)==j & M(:,5)==k),1);
            countFnd(cnt) = fnd;
            cnt = cnt +1;
        end
    end
end

countParent = zeros(6,1);
cnt = 1;
%find count of the parent occurences
for i = 1:3
    for j = 1:2
            fnd = size(find(M(:,1)==i & M(:,2)==j),1);
            countParent(cnt) = fnd;
            cnt = cnt +1;
    end
end

total = sum(countFnd);
if (total ~= 243)
    disp('P(CH): sum to one mismatch at count');
end

PCH = zeros(12,1);
PCH(1) = countFnd(1)/countParent(1);
PCH(2) = countFnd(2)/countParent(1);
for i = 2:6
    PCH(i+(i-1)) = countFnd(i+(i-1))/countParent(i);
    PCH(i*2) = countFnd(i*2)/countParent(i);
end 

total = sum(PCH);
if (total ~= 6)
    disp('P(CH): sum to one mismatch at parameter value');
end

disp('P(CH|G,A)');
disp('A-G-CH');
dispMat = zeros(12,3);
cnt = 1;
for i = 1:3
    for j = 1:2
        for k = 1:2
            dispMat(cnt,:) = [i, j, k];
            cnt = cnt +1;
        end
    end
end
disp(dispMat);
disp(PCH);


%P (CP |HD)
%the random variable CP corresponds to the third column of the matrix and
%can take 4 possible values and its parent HD corresponds to ninth column and can
%take 2 values

countFnd = zeros(8,1);
cnt = 1;
%second method - using find to verify the results
    for j = 1:2
        for k = 1:4
            fnd = size(find(M(:,9)==j & M(:,3)==k),1);
            countFnd(cnt) = fnd;
            cnt = cnt +1;
        end
    end


countParent = zeros(2,1);
cnt = 1;
%find count of the parent occurences
    for j = 1:2
            fnd = size(find(M(:,9)==j),1);
            countParent(cnt) = fnd;
            cnt = cnt +1;
    end

total = sum(countFnd);
if (total ~= 243)
    disp('P(CP): sum to one mismatch at count');
end

PCP = zeros(8,1);
PCP(1) = countFnd(1)/countParent(1);
PCP(2) = countFnd(2)/countParent(1);
PCP(3) = countFnd(3)/countParent(1);
PCP(4) = countFnd(4)/countParent(1);
PCP(5) = countFnd(5)/countParent(2);
PCP(6) = countFnd(6)/countParent(2);
PCP(7) = countFnd(7)/countParent(2);
PCP(8) = countFnd(8)/countParent(2);

total = sum(PCP);
if (total ~= 2)
    disp('P(CP): sum to one mismatch at parameter value');
end

disp('P(CP |HD)');
disp('HD-CP');
dispMat = zeros(8,2);
cnt = 1;
for j = 1:2
        for k = 1:4
            dispMat(cnt,:) = [j, k];
            cnt = cnt +1;
        end
end
disp(dispMat);
disp(PCP);

%P (EIA|HD)
%the random variable EIA corresponds to the eigth column of the matrix and
%can take 2 possible values and its parent HD corresponds to ninth column and can
%take 2 values

count11 = 0;
count12 = 0;
count21 = 0;
count22 = 0;

x = find(M(:,8)==1);
sz = size(x,1);

for i = 1 : sz
    if(M(x(i),9) == 1)
        count11 = count11 + 1;
    else 
        count12 = count12 + 1;
    end
end

y = find(M(:,8)==2);
sz = size(y,1);
for i = 1 : sz
    if(M(y(i),9) == 1)
        count21 = count21 + 1;
    else 
        count22 = count22 + 1;
    end
end

total = count11 + count12 + count21 + count22;
if (total ~= 243)
    disp('P(EIA): sum to total mismatch at count');
end

w = find(M(:,9)==1);
w1 = size(w,1);
w = find(M(:,9)==2);
w2 = size(w,1);

PEIA = zeros(4,1);
PEIA(1) = count11/w1;
PEIA(2) = count21/w1;
PEIA(3) = count12/w2;
PEIA(4) = count22/w2;

total = sum(PEIA);
if (total ~= 2)
    disp('P(EIA): sum to one mismatch at parameter value');
end

disp('P(EIA|HD)');
disp('EIA - HD');
disp('11-21-12-22');
disp(PEIA);

%P (ECG|HD)
%the random variable ECG corresponds to the sixth column of the matrix and
%can take 2 possible values and its parent HD corresponds to ninth column and can
%take 2 values

count11 = 0;
count12 = 0;
count21 = 0;
count22 = 0;

x = find(M(:,6)==1);
sz = size(x,1);

for i = 1 : sz
    if(M(x(i),9) == 1)
        count11 = count11 + 1;
    else 
        count12 = count12 + 1;
    end
end

y = find(M(:,6)==2);
sz = size(y,1);
for i = 1 : sz
    if(M(y(i),9) == 1)
        count21 = count21 + 1;
    else 
        count22 = count22 + 1;
    end
end

total = count11 + count12 + count21 + count22;
if (total ~= 243)
    disp('P(ECG): sum to total mismatch at count');
end

w = find(M(:,9)==1);
w1 = size(w,1);
w = find(M(:,9)==2);
w2 = size(w,1);

PECG = zeros(4,1);
PECG(1) = count11/w1;
PECG(2) = count21/w1;
PECG(3) = count12/w2;
PECG(4) = count22/w2;

total = sum(PECG);
if (total ~= 2)
    disp('P(ECG): sum to one mismatch at parameter value');
end

disp('P(ECG|HD)');
disp('ECG - HD');
disp('11-21-12-22');
disp(PECG);

ans = 0;
num = 0;

for g = 1:2
        pg = find(PG(:,1) == g);
        bpg = find(PB(:,1) == 1 & PB(:,2) ==g);
        chga = find(PCH(:,3) == 2 & PCH(:,2) ==g & PCH(:,1)==2); 
        hdbpch = find(PC(:,3) == 1 & PC(:,2) ==1 & PC(:,1)==2); 
        
        num = num + (PG(pg,1)* PB(bpg,3)*PCH(chga,4)* PC(hdbpch,4));
end

din = 0;
for g = 1:2
    for bp =  1:2
        pg = find(PG(:,1) == g);
        bpg = find(PB(:,1) == bp & PB(:,2) ==g);
        chga = find(PCH(:,3) == 2 & PCH(:,2) ==g & PCH(:,1)==2); 
        hdbpch = find(PC(:,3) == 1 & PC(:,2) ==bp & PC(:,1)==2); 
        
        din = din + (PG(pg,1)* PB(bpg,3)*PCH(chga,4)* PC(hdbpch,4));
    end 
end

