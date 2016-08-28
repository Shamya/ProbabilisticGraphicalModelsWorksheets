%sum-product inference algorithm for the CRF model
format shortEng
format compact

%use the character ordering
keySet =   {'e', 't', 'a', 'i', 'n', 'o', 's', 'h', 'r', 'd'};
valueSet = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
mapObj = containers.Map(keySet,valueSet);

%***************Q2.1**************
%read the data for the first test word
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
cp = zeros(10,1);
for i = 1:3
    clique =repmat(np(:,i),1,10) + wt;
    cp = [cp clique];
end

cp = cp(:,2:end);
cp(:,21:end) = repmat(np(:,4)',10,1) + cp(:,21:end);
cp1 = cp(:,1:10);
cp2 = cp(:,11:20);
cp3 = cp(:,21:30);

ch = [];
val = mapObj('t');
ch = [ch val];
val = mapObj('a');
ch = [ch val];
val = mapObj('h');
ch = [ch val];

disp('2.1 Clique potential for the labels ?t,a,h? for each of the three clique potentials');
otp = zeros(1,3);
for i = 1:3
    tr = [];
    for j = 1:3
        t = cp1(ch(i),ch(j));
        tr = [tr t];
    end
    otp = [otp; tr];
end
otp=otp(2:end,:);
disp('C1:');
disp(otp);

otp = zeros(1,3);
for i = 1:3
    tr = [];
    for j = 1:3
        t = cp2(ch(i),ch(j));
        tr = [tr t];
    end
    otp = [otp; tr];
end
otp=otp(2:end,:);
disp('C2:');
disp(otp);

otp = zeros(1,3);
for i = 1:3
    tr = [];
    for j = 1:3
        t = cp3(ch(i),ch(j));
        tr = [tr t];
    end
    otp = [otp; tr];
end
otp=otp(2:end,:);
disp('C3:');
disp(otp);

%***************Q2.2**************
%compute sum product messages
%msg32 msg21 msg12 msg23
disp('2.2 sum product messages');
msg32 = log(sum(exp(cp3),2));
disp('msg 3->2');
disp(msg32);

t = sum(exp(cp3),2);
msg21t = exp(cp2) * t;
msg21 = log(sum(msg21t,2));
disp('msg 2->1');
disp(msg21);

msg12 = (log(sum(exp(cp1),1)))';
disp('msg 1->2');
disp(msg12);

t = sum(exp(cp1),1);
t = t';
msg23t = exp(cp2) .* (repmat(t,1,10)) ;
msg23 = (log(sum(msg23t,1)))';
disp('msg 2->3');
disp(msg23);

%***************Q2.3**************
%compute log beliefs

disp('2.3 Log beliefs');
b1y1y2 = exp(cp1) .* (repmat(exp(msg21'),10,1));
b1y1y2 = (log(b1y1y2));

ch = [];
val = mapObj('t');
ch = [ch val];
val = mapObj('a');
ch = [ch val];

otp = zeros(1,2);
for i = 1:2
    tr = [];
    for j = 1:2
        t = b1y1y2(ch(i),ch(j));
        tr = [tr t];
    end
    otp = [otp; tr];
end
otp=otp(2:end,:);
disp('log belief 1');
disp(otp);

b2y2y3 = exp(cp2) .* (repmat(exp(msg12),1,10));
b2y2y3 = b2y2y3 .* (repmat(exp(msg32'),10,1));

b2y2y3 = (log(b2y2y3));

otp = zeros(1,2);
for i = 1:2
    tr = [];
    for j = 1:2
        t = b2y2y3(ch(i),ch(j));
        tr = [tr t];
    end
    otp = [otp; tr];
end
otp=otp(2:end,:);
disp('log belief 2');
disp(otp);

b3y3y4 = exp(cp3) .* (repmat(exp(msg23),1,10));
b3y3y4 = (log(b3y3y4));

otp = zeros(1,2);
for i = 1:2
    tr = [];
    for j = 1:2
        t = b3y3y4(ch(i),ch(j));
        tr = [tr t];
    end
    otp = [otp; tr];
end
otp=otp(2:end,:);
disp('log belief 3');
disp(otp);

%***************Q2.4**************
%Marginal Probability Distribution

b1y1y2t = exp(b1y1y2);
b1z = sum(b1y1y2t,1);
b1z = sum(b1z,2);
pb1 = b1y1y2t / b1z;
b1 = sum(pb1,2);
marg = b1;

b2y2y3t = exp(b2y2y3);
b1z = sum(b2y2y3t,1);
b2z = sum(b1z,2);
pb2 = b2y2y3t / b2z;
b1 = sum(pb2,2);
marg = [marg b1];

b3y3y4t = exp(b3y3y4);
b1z = sum(b3y3y4t,1);
b3z = sum(b1z,2);
pb3 = b3y3y4t / b3z;
b1 = sum(pb3,2);
marg = [marg b1];

b3y3y4t = exp(b3y3y4);
b1z = sum(b3y3y4t,1);
b1z = sum(b1z,2);
b1 = b3y3y4t / b1z;
b1 = sum(b1,1);
marg = [marg b1'];

disp('2.4 Marginal Distribution -');
disp(marg);

ch = [];
val = mapObj('t');
ch = [ch val];
val = mapObj('a');
ch = [ch val];
val = mapObj('h');
ch = [ch val];

disp('Pairwise Marginals -');

otp = zeros(1,3);
for i = 1:3
    tr = [];
    for j = 1:3
        t = pb1(ch(i),ch(j));
        tr = [tr t];
    end
    otp = [otp; tr];
end
otp=otp(2:end,:);
disp('Belief 1:');
disp(otp);

otp = zeros(1,3);
for i = 1:3
    tr = [];
    for j = 1:3
        t = pb2(ch(i),ch(j));
        tr = [tr t];
    end
    otp = [otp; tr];
end
otp=otp(2:end,:);
disp('Belief 2:');
disp(otp);

otp = zeros(1,3);
for i = 1:3
    tr = [];
    for j = 1:3
        t = pb3(ch(i),ch(j));
        tr = [tr t];
    end
    otp = [otp; tr];
end
otp=otp(2:end,:);
disp('Belief 3:');
disp(otp);