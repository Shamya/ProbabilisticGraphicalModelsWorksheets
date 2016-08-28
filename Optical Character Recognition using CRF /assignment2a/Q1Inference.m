format shortEng
format compact

%use the character ordering
keySet =   {'e', 't', 'a', 'i', 'n', 'o', 's', 'h', 'r', 'd'};
valueSet = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
mapObj = containers.Map(keySet,valueSet);

%***************Q1.1**************
%read the data for the first test word
%pulls the 321 long feature vector for each character in the test image
x = textread('data/test_img1.txt');

%get feature parameter
wf = textread('model/feature-params.txt','%.6f');
wf = reshape(wf,[321,10]);
wf = wf';

%get transition parameter
wt = textread('model/transition-params.txt','%.6f');
wt = reshape(wt,[10,10]);
wt = wt';

%compute node potentials
np = node_potential (x, wf);
disp('1.1) node potential for each position (columns) in the test word');
disp(np);

%***************Q1.2**************
%compute negative energy
%get test words
fileID = fopen('data/test_words.txt');
C = textscan(fileID,'%s','Delimiter','\n');
fclose(fileID);
label_list = C{1};

e = [];

%first word
x = textread('data/test_img1.txt');
label = char(label_list(1));
e1 = negative_energy(x,label,mapObj,wt,wf);
e = [e, e1];

%second word
x = textread('data/test_img2.txt');
label = char(label_list(2));
e2 = negative_energy(x,label,mapObj,wt,wf);
e = [e, e2];

x = textread('data/test_img3.txt');
label = char(label_list(3));
e3 = negative_energy(x,label,mapObj,wt,wf);
e = [e, e3];

disp('1.2) negative energy value');
disp(e);

%***************Q1.3**************
%compute partition function
%first word
op = [];
x = textread('data/test_img1.txt');
res1 = [];
ip1 = zeros(1,4);
for a = 1:10
    for b = 1:10
        for c = 1:10
            for d = 1:10
                l = [a,b,c,d];
                ip1 = [ip1;l];
                e1 = negative_energy_int (x, l, wt, wf);
                res1 = [res1 e1];
            end
        end
    end
end

op = [op logsumexp(res1)];

%second word
x = textread('data/test_img2.txt');
res2 = [];
ip2 = zeros(1,4);
for a = 1:10
    for b = 1:10
        for c = 1:10
            for d = 1:10
                l = [a,b,c,d];
                ip2 = [ip2;l];
                e2 = negative_energy_int (x, l, wt, wf);
                res2 = [res2 e2];
            end
        end
    end
end

op = [op logsumexp(res2)];

%third word
x = textread('data/test_img3.txt');
res3 = [];
ip3 = zeros(1,5);
for a = 1:10
    for b = 1:10
        for c = 1:10
            for d = 1:10
                for e = 1:10
                    l = [a,b,c,d,e];
                    ip3 = [ip3;l];
                    e3 = negative_energy_int (x, l, wt, wf);
                    res3 = [res3 e3];
                end
            end
        end
    end
end

op = [op logsumexp(res3)];
disp('1.3) log partition function (used logsumexp)');
disp(op);

%***************Q1.4**************
%most likely joint labeling (character sequence) word. 
%labeling and its probability under the model.

[x1,y1] = max(res1);
[x2,y2] = max(res2);
[x3,y3] = max(res3);

valueSetX =   {'e', 't', 'a', 'i', 'n', 'o', 's', 'h', 'r', 'd'};
keySetX = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
mapObjX = containers.Map(keySetX,valueSetX);

a = ip1((y1+1),:);
sz = (size(a,2));
disp('1.4) most likely labeling for first word - ');
opt = [];
for i = 1:sz
    opt = [opt mapObjX(int8(a(i)))];
end;
disp(opt);
p = exp(x1 - op(1));
disp('probability -')
disp(p);

a = ip2((y2+1),:);
sz = (size(a,2));
disp('most likely labeling for second word');
opt = [];
for i = 1:sz
    opt = [opt mapObjX(int8(a(i)))];
end;
disp(opt);
p = exp(x2 - op(2));
disp('probability -')
disp(p);

a = ip3((y3+1),:);
sz = (size(a,2));
disp('most likely labeling for third word');
opt = [];
for i = 1:sz
     opt = [opt mapObjX(int8(a(i)))];
end;
disp(opt);
p = exp(x3 - op(3));
disp('probability -');
disp(p);

%***************Q1.5**************
%For the first test word only, compute the marginal probability distribution
%over character labels for each position in the word. 
%Report each marginal distribution using a table.

sz=size(ip1,1);
t = [ip1(2:sz,:) res1'];
z = op(1);
marg = [];
for i = 1:4
    for j = 1:10
        [a,b] = find(t(:,i) == j);
        x = [];
        for k = 1:size(a)
            x = [x t(a(k),5)];
        end 
        marg = [marg exp(logsumexp(x)-z)];
    end
end

marg = reshape(marg, [10,4]);
disp('1.5)marginal probability distribution ');
disp(marg);









