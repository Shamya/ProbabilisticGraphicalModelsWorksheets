clear all; close all;
%P(BN1) = P (G)P (A)P (BP |G, A)P (CH|G, A)P (HD|BP, CH)P (CP |HD)P (EIA|HD)P (ECG|HD)P (HR|HD)
%calculate the CPTs for all the random variables in this bayesian network. 
%The maximum likelihood estimate for all the parameters are listed in these CPTs too. 
%The code trains on the train data in file i and tests in on the test data in the corresponding file i. 
%It also gives the classification accuracy and the count of misclassified data points.

%read first training data into a matrix for parameter learning
%uncomment the one needed
%M = csvread('data-train-1.txt');
%M = csvread('data-train-2.txt');
%M = csvread('data-train-3.txt');
%M = csvread('data-train-4.txt');
M = csvread('data-train-5.txt');

disp('Computing CPT...');
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
%disp('1-2');
%disp(PG);
x = [1;2];
fullPG = [x,PG];
disp(fullPG);

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
%disp('1-2-3');
%disp(PA);
x = [1;2;3];
fullPA = [x,PA];
disp(fullPA);

%P(BP|G,A)
%the random variable BP corresponds to the fourth column of the matrix and
%can take 2 possible values and its parents G and A correspond to second and first 
%column and can take 2  and 3 values
countFnd = zeros(12,1);
cnt = 1;
%second method - using find to verify the results
for i = 1:3
    for j = 1:2
        for k = 1:2
            fnd = size(find(M(:,1)==i & M(:,2)==j & M(:,4)==k),1);
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
    disp('P(BP): sum to one mismatch at count');
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
    disp('P(BP): sum to one mismatch at parameter value');
end

disp('P(BP|G,A)');
disp('A-G-BP');
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
%disp(dispMat);
%disp(PBP);
fullPAGBP = [dispMat,PCH];
disp(fullPAGBP);

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
%disp(dispMat);
%disp(PC);
fullPCHBPHD = [dispMat,PC];
disp(fullPCHBPHD);

%P(HR|HD)
%the random variable HR corresponds to the seventh column of the matrix and
%can take 2 possible values and its parent A and HD corresponds to first and ninth columns 
%and can take 3 values and 2 values each

countFnd = zeros(4,1);
cnt = 1;
%second method - using find to verify the results
for i = 1:2
        for k = 1:2
            fnd = size(find(M(:,9)==i & M(:,7)==k),1);
            countFnd(cnt) = fnd;
            cnt = cnt +1;
        end
end

countParent = zeros(2,1);
cnt = 1;
%find count of the parent occurences
for i = 1:2
            fnd = size(find(M(:,9)==i),1);
            countParent(cnt) = fnd;
            cnt = cnt +1;
end
total = sum(countFnd);
if (total ~= 243)
    disp('P(D): sum to one mismatch at count');
end


PD = zeros(4,1);
PD(1) = countFnd(1)/countParent(1);
PD(2) = countFnd(2)/countParent(1);
PD(3) = countFnd(3)/countParent(2);
PD(4) = countFnd(4)/countParent(2);

total = sum(PD);
if (total ~= 2)
    disp('P(D): sum to one mismatch at parameter value');
end

disp('P(HR| HD)');
disp('HD-HR');
dispMat = zeros(4,2);
cnt = 1;
for i = 1:2
        for k = 1:2
            dispMat(cnt,:) = [i, k];
            cnt = cnt +1;
        end
end
%disp(dispMat);
%disp(PD);
fullPHDHR = [dispMat,PD];
disp(fullPHDHR);

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
%disp(dispMat);
%disp(PCH);
fullPAGCH = [dispMat,PCH];
disp(fullPAGCH);

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
%disp(dispMat);
%disp(PCP);
fullPHDCP = [dispMat,PCP];
disp(fullPHDCP);
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
%disp('11-21-12-22');
%disp(PEIA);
x = [1 1;2 1;1 2; 2 2];
fullPEIAHD = [x,PEIA];
disp(fullPEIAHD);

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
%disp('11-21-12-22');
%disp(PECG);
x = [1 1;2 1;1 2; 2 2];
fullPECGHD = [x,PECG];
disp(fullPECGHD);

disp('End of CPT computation...');

%computing value for HD
%P (HD|BP, CH)P (CP |HD)P (EIA|HD)P (ECG|HD)P (HR|HD, A)
%N = csvread('data-test-1.txt');
%N = csvread('data-test-2.txt');
%N = csvread('data-test-3.txt');
%N = csvread('data-test-4.txt');
N = csvread('data-test-5.txt');
sz = size(N,1);
%column - RV mapping
%1 A 3
%2 G 2
%3 CP 4
%4 BP 2
%5 CH 2
%6 ECG 2
%7 HR 2
%8 EIA 2
%9 HD 2

% paramerters stored as 
% fullPCHBPHD - fullPHDCP - fullPEIAHD - fullPECGHD - fullPHDAHR

predErr = zeros(sz,1);
for i = 1:sz
   temp = N(i,:); 
   bp = temp(4);
   ch = temp(5);
   cp = temp(3);
   eia = temp(8);
   ecg = temp(6);
   hr = temp(7);
   a = temp(1);
   hd = 1;
   
   %for HD low
   rw = find(fullPCHBPHD(:,1) == ch & fullPCHBPHD(:,2)==bp & fullPCHBPHD(:,3)== hd);
   p1 = fullPCHBPHD(rw,4);
   %rw = find(fullPHDCP(:,1) == hd & fullPHDCP(:,2)==cp);
   %p2 = fullPHDCP(rw,3);
   rw = find(fullPEIAHD(:,1) == eia & fullPEIAHD(:,2)==hd);
   p3 = fullPEIAHD(rw,3);
   rw = find(fullPECGHD(:,1) == ecg & fullPECGHD(:,2)==hd);
   p4 = fullPECGHD(rw,3);
   rw = find(fullPHDHR(:,1) == hd  & fullPHDHR(:,2)== hr);
   p5 = fullPHDHR(rw,3);
   
   %for HD high
   hd = 2;
   rw = find(fullPCHBPHD(:,1) == ch & fullPCHBPHD(:,2)==bp & fullPCHBPHD(:,3)== hd);
   p12 = fullPCHBPHD(rw,4);
   %rw = find(fullPHDCP(:,1) == hd & fullPHDCP(:,2)==cp);
   %p22 = fullPHDCP(rw,3);
   rw = find(fullPEIAHD(:,1) == eia & fullPEIAHD(:,2)==hd);
   p32 = fullPEIAHD(rw,3);
   rw = find(fullPECGHD(:,1) == ecg & fullPECGHD(:,2)==hd);
   p42 = fullPECGHD(rw,3);
   rw = find(fullPHDHR(:,1) == hd  & fullPHDHR(:,2)== hr);
   p52 = fullPHDHR(rw,3);
   
   mul1 = p1*p3*p4*p5;
   mul2 = p12*p32*p42*p52;
   hdpred= (mul1)/(mul1+mul2);
   
   if(hdpred >= 0.5)
      hdpred = 1;
   else
       hdpred = 2;
   end
   
   %verify - 1 if misclassified 
   hdorig = temp(9);
   
   if (hdorig == hdpred)
       predErr(i) = 0;
   else
       predErr(i) = 1;
   end 
end

missClassify = sum(predErr);
disp('Total number of testing data');
disp(sz);
disp('Number of test data misclassified:');
disp(missClassify);
accuracy = (sz-missClassify)/sz;
disp('Accuracy:');
disp(accuracy);
