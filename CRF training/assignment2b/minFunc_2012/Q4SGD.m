%Question 4
format shortEng
format compact

%use the character ordering
keySet =   {'e', 't', 'a', 'i', 'n', 'o', 's', 'h', 'r', 'd'};
valueSet = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
mapObj = containers.Map(keySet,valueSet);

valueSetX =   {'e', 't', 'a', 'i', 'n', 'o', 's', 'h', 'r', 'd'};
keySetX = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
mapObjX = containers.Map(keySetX,valueSetX);

%get train labels
fileID = fopen('data/train_words.txt');
C = textscan(fileID,'%s','Delimiter','\n');
fclose(fileID);
label_list = C{1};

%Stochastic Gradient Descent
%{
for each epoch do
    randomly permute the training data
    for each minibatch of size B from the training data do
        for each training instance i in minibatch do
            compute gradient gi
??      end for
        gk = (1/B)* sumB gi
        ?k+1 = ?k ? ?gk (Subtract gradient of negative loglikelihood)
        k=k+1
    end for
end for
%}

% Initialize weights=0
w = zeros(1, 3310);

%Set step size ? = 10?4, batch size B = 1, counter k = 0
step_size = 0.0001;
batch_size = 1;
counter = 0;
err= [];
%for each epoch
for epoch = 1:400
    
    %permute training data
    file_num = 1:400;
    file_num = file_num(randperm(size(file_num,2)));
    
    %for each minibatch of size B from the training data do
    %for each training instance i in minibatch do
    for bat = 1:400
        n = 1;
        x = textread(strcat('data/train_img',num2str(file_num(bat)),'.txt'));
        pos = file_num(bat);
        
        %get feature parameter
        wf = reshape(w(1:3210),[10,321]);
        %get transition parameter
        wt = reshape(w(3211:end),[10,10]);
        gradwf = zeros(size(wf));
        gradwt = zeros(size(wt));
        
        %sum-product inference algorithm for the CRF model
        %compute node potentials
        np = node_potential (x, wf);
        sz = size(np,2);
        cp = zeros(10,1);
        for i = 1:sz-1
            clique =repmat(np(:,i),1,10) + wt;
            cp = [cp clique];
        end
        
        cp = cp(:,2:end);
        szn = (sz-2)*10;
        cp(:,(((szn)+1):end)) = repmat(np(:,sz)',10,1) + cp(:,((szn)+1):end);
        
        %cliquePrint(cp);
        %compute sum product messages
        %cliquePrint(cp);
        %compute sum product messages
        msg = log(sum(exp(cp(:,(((sz-2)*10)+1):(((sz-2)*10)+10))),2));
        %disp(msg);
        for i = (sz-3):-1:1
            msgt = [];
            for p = 1:10
                msgt = [msgt;  logsumexp(msg(p,:))];
            end
            in = (i)*10;
            msgt = (cp(:,((in)+1):((in)+10))) + repmat(msgt',10,1);
            temp = [];
            for p = 1:10
                temp = [temp;  logsumexp(msgt(p,:))];
            end
            msg = [msg temp];
        end
        
        msgb = log(sum(exp(cp(:,(1:10))),1))';
        for i = 1:sz-3
            msgt = [];
            for p = 1:10
                msgt = [msgt;  logsumexp(msgb(p,:))];
            end
            in = (i)*10;
            msgt = (cp(:,((in)+1):((in)+10))) + (repmat(msgt,1,10));
            
            temp = [];
            for p = 1:10
                temp = [temp logsumexp(msgt(:,p))];
            end
            msgb = [msgb temp'];
        end
        msg = [msg msgb];
        
        %compute log beliefs
        sz2 = size(msg,2)/2;
        blf =(cp(:,1:10)) + (repmat((msg(:,sz2)'),10,1));
        for i = 1:((size(np,2))-3)
            in = (i)*10;
            blft = (cp(:,((in)+1):((in)+10))) + (repmat((msg(:,((sz2)+i))),1,10));
            blft = blft + (repmat((msg(:,((sz2)-i))'),10,1));
            blf = [blf blft];
        end
        blft = (cp(:,end-9:end)) + (repmat((msg(:,end)),1,10));
        blf = [blf blft];

        %Marginal Probability Distribution - node
        partition = [];
        blft = (blf(:,1:10));
        temp = [];
        for p = 1:10
            temp = [temp logsumexp(blft(:,p))];
        end
        b1z = logsumexp(temp);
        partition = [partition b1z];

        b1 = blft - repmat(b1z,10,10);
        temp = [];
        for p = 1:10
            temp = [temp; logsumexp(b1(p,:))];
        end
        nodemarg = temp;
        
        for i = 1:((size(np,2))-2)
            in = i*10;
            blft = (blf(:,((in)+1):((in)+10)));
            temp = [];
            for p = 1:10
                temp = [temp logsumexp(blft(:,p))];
            end
            partition = [partition logsumexp(temp)];
            b1 = blft - repmat(b1z,10,10);
            temp = [];
            for p = 1:10
                temp = [temp; logsumexp(b1(p,:))];
            end
            nodemarg = [nodemarg temp];
        end
        
        blft = (blf(:,end-9:end));
        temp = [];
        for p = 1:10
            temp = [temp logsumexp(blft(:,p))];
        end
        partition = [partition logsumexp(temp)];
        b1 = blft - repmat(b1z,10,10);
        temp = [];
        for p = 1:10
            temp = [temp logsumexp(b1(:,p))];
        end
        
        nodemarg = [nodemarg temp'];
        
        label = char(label_list(pos));
        
        lab = [];
        for c = 1:size(label,2)
            lab = [lab mapObj(label(c))];
        end
        
        %calculate gradient wrto feature params
        for j = 1:size(x,1)
            for fe = 1:size(x,2)
                gradwf(lab(j),fe) = gradwf(lab(j),fe) + x(j,fe);
                for c = 1:10
                    gradwf(c,fe) = gradwf(c,fe) - (exp(nodemarg(c,j)) * x(j,fe));
                end
            end
        end
        
        pairmarg = exp(blf-partition(1));
        %at = logsumexp(nodemarg(p,:))
        %calculate gradient wrto transisition params
        for j = 0:(size(x,1)-2)
            cj = lab(j+1);
            cj1 =lab(j+2);
            gradwt(cj,cj1) = gradwt(cj,cj1) + 1;
            for c1 = 1:10
                for c2 = 1:10
                    jn = j*10;
                    pairsplit = pairmarg(:,(jn)+1:(jn)+10);
                    gradwt(c1,c2) = gradwt(c1,c2) - pairsplit(c1,c2);
                end
            end
        end
        
        %negative avg gradient
        gradwf1 = (1/n) * gradwf;
        gradwt1 = (1/n) * gradwt;
        gradwf = reshape(gradwf1,[1,(size(gradwf1,1) * size(gradwf1,2))]);
        gradwt = reshape(gradwt1,[1,(size(gradwt1,1) * size(gradwt1,2))]);
        gradw = -[gradwf gradwt];
        
        %Subtract gradient of negative loglikelihood.
        w = w - (step_size * gradw);
        
        counter=counter+1;
    end
    %disp(negloglike);
    %disp(gradwf1(1,:));
    %disp(gradwt1(1,:));
    %{
disp('Average log likelihood value -');
disp(loglike);
disp('Gradient WF');
disp(gradwf);
disp('Gradient WT');
disp(gradwt);
    %}
err_new = (test_inference(w));
disp(err_new);
err = [err err_new];    
end

p = plot(err,'-');
p(1).LineWidth = 2;
title('Test error with 400 epochs of stochastic gradient descent');
xlabel('epoch number');
ylabel('test error');