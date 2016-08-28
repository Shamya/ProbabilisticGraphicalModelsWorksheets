clear all; close all;
%Learning: Implement the maximum likelihood parameter estimates for all CPTs in the model. 
%For this question, run your code on the data in the first training data set only to compute the 
%maximum likelihood parameter estimates for each CPT in the model. 

%P(BN) = P(G,A,BP,CH,HD,CP,EIA,ECG,HR)
%= P (G)P (A)P (BP |G)P (CH|G, A)P (HD|BP, CH)P (CP |HD)P (EIA|HD)P (ECG|HD) P(HR|HD,A)

%read first training data into a matrix for parameter learning
M = csvread('data-train-1.txt');

%(a) P?(A)
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
disp(PA);

%(b) P?(BP|G)
%the random variable BP corresponds to the fourth column of the matrix and
%can take 2 possible values and its parent G corresponds to second column and can
%take 2 values
count11 = 0;
count12 = 0;
count21 = 0;
count22 = 0;

x = find(M(:,4)==1);
w = find(M(:,2)==1);
w1 = size(w,1);
w = find(M(:,2)==2);
w2 = size(w,1);
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
disp(PB);

%(c) P?(HD|BP, CH) 
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
disp(PC);

%(d) P?(HR|A, HD)
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
disp(PD);