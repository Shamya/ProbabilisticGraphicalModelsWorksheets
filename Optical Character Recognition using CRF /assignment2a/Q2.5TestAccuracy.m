%sum-product inference algorithm for the CRF model
format shortEng
format compact

%use the character ordering
keySet =   {'e', 't', 'a', 'i', 'n', 'o', 's', 'h', 'r', 'd'};
valueSet = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
mapObj = containers.Map(keySet,valueSet);

valueSetX =   {'e', 't', 'a', 'i', 'n', 'o', 's', 'h', 'r', 'd'};
keySetX = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
mapObjX = containers.Map(keySetX,valueSetX);

%get feature parameter
wf = textread('model/feature-params.txt','%.6f');
wf = reshape(wf,[321,10]);
wf = wf';

%get transition parameter
wt = textread('model/transition-params.txt','%.6f');
wt = reshape(wt,[10,10]);
wt = wt';

count = 0;
counttot = 0;
actual = importdata('data/test_words.txt');
%read the data for the test word
f = dir('data/');
f = regexpi({f.name},'test_img*.*txt','match');
f = [f{:}];
for fl = 1:size(f,2)
    ft2 = f{fl};
    ft1 = 'data/';
    ft = strcat(ft1,ft2);
    x = textread(ft);
    
    a = strfind(ft2,'g');
    b = strfind(ft2,'.');
    pos = str2double(ft2(a+1:b-1));
    
    %compute node potentials
    np = node_potential (x, wf);
    sz = size(np,2);
    cp = zeros(10,1);
    for i = 1:sz-1
        clique =repmat(np(:,i),1,10) + wt;
        cp = [cp clique];
    end
    
    cp = cp(:,2:end);
    cp(:,(((sz-2)*10)+1):end) = repmat(np(:,sz)',10,1) + cp(:,(((sz-2)*10)+1):end);
    
    %cliquePrint(cp);
    %compute sum product messages
    msg = log(sum(exp(cp(:,(((sz-2)*10)+1):(((sz-2)*10)+10))),2));
    %disp(msg);
    for i = (sz-3):-1:1
        msgt = msg(:,1);
        szm = size(msg,2);
        if szm >1
            for j = 2:szm
                msgt = msgt + msg(:,j);
            end
        end
        
        msgt = (cp(:,(((i)*10)+1):(((i)*10)+10))) + repmat(msgt',10,1);
        temp = [];
        for p = 1:10
            a = msgt(p,:);
            at = logsumexp(a);
            temp = [temp; at];
        end
        msgt = temp;
        
        msg = [msg msgt];
    end
    
    msgb = log(sum(exp(cp(:,(1:10))),1))';
    for i = 1:sz-3
        msgt = msgb(:,1);
        szm = size(msgb,2);
        if szm > 1
            for j = 2:szm
                msgt = msgt + msgb(:,j);
            end
        end
        
        msgt = (repmat(msgt,1,10));
        msgt = (cp(:,(((i)*10)+1):(((i)*10)+10))) + msgt;
        
        temp = [];
        for p = 1:10
            a = msgt(:,p);
            at = logsumexp(a);
            temp = [temp at];
        end
        msgt = temp;
        msgb = [msgb msgt'];
    end
    msg = [msg msgb];
    
    %compute log beliefs
    sz = size(msg,2);
    blf =(cp(:,1:10)) + (repmat((msg(:,sz/2)'),10,1));
    for i = 1:((size(np,2))-3)
        blft = (cp(:,((i*10)+1):((i*10)+10))) + (repmat((msg(:,((sz/2)+i))),1,10));
        blft = blft + (repmat((msg(:,((sz/2)-i))'),10,1));
        blf = [blf blft];
    end
    blft = (cp(:,end-9:end)) + (repmat((msg(:,end)),1,10));
    blf = [blf blft];
    
    
    %Marginal Probability Distribution
    blft = (blf(:,1:10));
    temp = [];
    for p = 1:10
        a = blft(:,p);
        at = logsumexp(a);
        temp = [temp at];
    end
    b1z = temp;
    b1z = logsumexp(b1z);
    b1 = blft - repmat(b1z,10,10);
    temp = [];
    for p = 1:10
        a = b1(p,:);
        at = logsumexp(a);
        temp = [temp; at];
    end
    b1 = temp;
    margprob = b1;
    
    for i = 1:((size(np,2))-2)
        blft = (blf(:,((i*10)+1):((i*10)+10)));
        temp = [];
        for p = 1:10
            a = blft(:,p);
            at = logsumexp(a);
            temp = [temp at];
        end
        b1z = temp;
        b1z = logsumexp(b1z);
        b1 = blft - repmat(b1z,10,10);
        temp = [];
        for p = 1:10
            a = b1(p,:);
            at = logsumexp(a);
            temp = [temp; at];
        end
        b1 = temp;
        margprob = [margprob b1];
    end
    
    
    blft = (blf(:,end-9:end));
    temp = [];
    for p = 1:10
        a = blft(:,p);
        at = logsumexp(a);
        temp = [temp at];
    end
    b1z = temp;
    b1z = logsumexp(b1z);
    b1 = blft - repmat(b1z,10,10);
    temp = [];
    for p = 1:10
        a = b1(:,p);
        at = logsumexp(a);
        temp = [temp at];
    end
    b1 = temp;
    
    margprob = [margprob b1'];
    
    %compare actual and predicted label
    [x,y] = max(margprob);
    act = char(actual(pos));
    pred ='';
    for i = 1:size(y,2)
        if(act(i) == mapObjX(y(i)))
            count = count + 1;
        end
        
        pred = strcat(pred, mapObjX(y(i)));
        counttot = counttot +1;
    end
    xz = [act ' ' pred];
    disp(xz);
end;
disp('Total Characters:');
disp(counttot);
disp('Correctly Predicted:');
disp(count);
disp('Accuracy:');
disp((count/counttot)*100);

